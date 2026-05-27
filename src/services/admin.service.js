const pool = require('../config/database');

async function getDashboardStats() {
  const [[revenue]] = await pool.query(
    "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders WHERE order_status = 'completed' AND payment_status = 'paid'"
  );

  const [orderStats] = await pool.query(
    'SELECT order_status, COUNT(*) AS cnt FROM orders GROUP BY order_status'
  );
  const orderByStatus = {};
  orderStats.forEach(r => { orderByStatus[r.order_status] = r.cnt; });

  const [revenueByDay] = await pool.query(
    `SELECT DATE(created_at) AS day, SUM(total_amount) AS revenue
     FROM orders
     WHERE order_status = 'completed' AND payment_status = 'paid'
       AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
     GROUP BY DATE(created_at)
     ORDER BY day`
  );

  const [topProducts] = await pool.query(
    `SELECT p.name, SUM(oi.quantity) AS total_sold,
            SUM(oi.total_price) AS total_revenue,
            ANY_VALUE(pi.image_url) AS main_image
     FROM order_items oi
     JOIN products p ON oi.product_id = p.id
     JOIN orders o ON oi.order_id = o.id
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     WHERE o.order_status = 'completed'
     GROUP BY oi.product_id, p.name ORDER BY total_sold DESC LIMIT 5`
  );

  const [lowStock] = await pool.query(
    "SELECT id, name, stock_quantity, brand FROM products WHERE stock_quantity <= 5 AND status != 'inactive' ORDER BY stock_quantity ASC LIMIT 10"
  );

  const [recentOrders] = await pool.query(
    'SELECT order_code, total_amount, order_status, created_at FROM orders ORDER BY created_at DESC LIMIT 10'
  );

  const [revenueByMonth] = await pool.query(
    `SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
            SUM(total_amount) AS revenue,
            COUNT(*) AS order_count
     FROM orders
     WHERE order_status = 'completed' AND payment_status = 'paid'
       AND created_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
     GROUP BY DATE_FORMAT(created_at, '%Y-%m')
     ORDER BY month ASC`
  );

  return { totalRevenue: revenue.total, orderByStatus, revenueByDay, revenueByMonth, topProducts, lowStock, recentOrders };
}

async function getAdminProducts({ keyword, category, status, page = 1 }) {
  const pageSize = 20;
  const offset = (page - 1) * pageSize;
  const where = ['1=1'];
  const params = [];

  if (keyword) { where.push('p.name LIKE ?'); params.push(`%${keyword}%`); }
  if (category) { where.push('p.category_id = ?'); params.push(category); }
  if (status) { where.push('p.status = ?'); params.push(status); }

  const whereClause = `WHERE ${where.join(' AND ')}`;
  const [products] = await pool.query(
    `SELECT p.*, c.name AS category_name, pi.image_url AS main_image
     FROM products p
     JOIN categories c ON p.category_id = c.id
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     ${whereClause} ORDER BY p.created_at DESC LIMIT ? OFFSET ?`,
    [...params, pageSize, offset]
  );
  const [[{ cnt }]] = await pool.query(
    `SELECT COUNT(*) AS cnt FROM products p ${whereClause}`, params
  );
  return { products, total: cnt, page, totalPages: Math.ceil(cnt / pageSize) };
}

async function createProduct(data, imageFiles) {
  const { name, category_id, brand, sku, price, sale_price, stock_quantity,
          description, specifications, warranty_months } = data;

  const slugify = require('slugify');
  const slug = slugify(name, { lower: true, locale: 'vi', strict: true }) + '-' + Date.now();

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [result] = await conn.query(
      `INSERT INTO products (category_id, name, slug, brand, sku, price, sale_price,
        stock_quantity, description, specifications, warranty_months)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [category_id, name.trim(), slug, brand || null, sku || null,
       price, sale_price || null, stock_quantity || 0,
       description || null, specifications || null, warranty_months || 0]
    );
    const productId = result.insertId;

    for (let i = 0; i < imageFiles.length; i++) {
      await conn.query(
        'INSERT INTO product_images (product_id, image_url, is_main, sort_order) VALUES (?, ?, ?, ?)',
        [productId, '/uploads/' + imageFiles[i].filename, i === 0 ? 1 : 0, i]
      );
    }

    await conn.commit();
    return { success: true, productId };
  } catch (err) {
    await conn.rollback();
    return { success: false, error: err.message };
  } finally {
    conn.release();
  }
}

async function getAdminOrders({ status, keyword, page = 1 }) {
  const pageSize = 20;
  const offset = (page - 1) * pageSize;
  const where = ['1=1'];
  const params = [];

  if (status) { where.push('o.order_status = ?'); params.push(status); }
  if (keyword) { where.push('(o.order_code LIKE ? OR u.full_name LIKE ?)'); params.push(`%${keyword}%`, `%${keyword}%`); }

  const whereClause = `WHERE ${where.join(' AND ')}`;
  const [orders] = await pool.query(
    `SELECT o.*, u.full_name AS customer_name, u.email AS customer_email
     FROM orders o JOIN users u ON o.user_id = u.id
     ${whereClause} ORDER BY o.created_at DESC LIMIT ? OFFSET ?`,
    [...params, pageSize, offset]
  );
  const [[{ cnt }]] = await pool.query(
    `SELECT COUNT(*) AS cnt FROM orders o JOIN users u ON o.user_id = u.id ${whereClause}`, params
  );
  return { orders, total: cnt, page, totalPages: Math.ceil(cnt / pageSize) };
}

const VALID_ORDER_TRANSITIONS = {
  pending:    ['confirmed', 'cancelled'],
  confirmed:  ['processing', 'cancelled'],
  processing: ['shipping', 'cancelled'],
  shipping:   ['completed', 'cancelled'],
  completed:  [],
  cancelled:  []
};

async function updateOrderStatus(orderId, newStatus) {
  const [rows] = await pool.query('SELECT * FROM orders WHERE id = ?', [orderId]);
  if (!rows.length) return { success: false, error: 'Không tìm thấy đơn hàng' };
  const order = rows[0];

  if (!VALID_ORDER_TRANSITIONS[order.order_status]?.includes(newStatus)) {
    return { success: false, error: `Không thể chuyển từ "${order.order_status}" sang "${newStatus}"` };
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    await conn.query(
      'UPDATE orders SET order_status = ?, updated_at = NOW() WHERE id = ?',
      [newStatus, orderId]
    );

    if (newStatus === 'confirmed' && order.payment_method !== 'vnpay' && order.payment_method !== 'momo') {
      const [items] = await conn.query('SELECT product_id, quantity FROM order_items WHERE order_id = ?', [orderId]);
      for (const item of items) {
        await conn.query('UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?',
          [item.quantity, item.product_id]);
        await conn.query("UPDATE products SET status = 'out_of_stock' WHERE id = ? AND stock_quantity <= 0",
          [item.product_id]);
      }
    }

    if (newStatus === 'cancelled' && ['confirmed', 'processing', 'shipping'].includes(order.order_status)) {
      const [items] = await conn.query('SELECT product_id, quantity FROM order_items WHERE order_id = ?', [orderId]);
      for (const item of items) {
        await conn.query('UPDATE products SET stock_quantity = stock_quantity + ? WHERE id = ?',
          [item.quantity, item.product_id]);
        await conn.query("UPDATE products SET status = 'active' WHERE id = ? AND status = 'out_of_stock' AND stock_quantity > 0",
          [item.product_id]);
      }
    }

    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    return { success: false, error: err.message };
  } finally {
    conn.release();
  }
}

module.exports = { getDashboardStats, getAdminProducts, createProduct, getAdminOrders, updateOrderStatus };
