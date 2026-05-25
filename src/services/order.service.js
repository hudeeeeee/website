const pool = require('../config/database');
const cartService = require('./cart.service');

function generateOrderCode() {
  const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const rand = Math.random().toString(36).substring(2, 7).toUpperCase();
  return `ORD-${date}-${rand}`;
}

async function createOrder(userId, { address_id, shipping_name, shipping_phone, shipping_address,
                                     payment_method, note }) {
  const validMethods = ['cod', 'bank_transfer', 'vnpay', 'momo'];
  if (!validMethods.includes(payment_method)) {
    return { success: false, error: 'Phương thức thanh toán không hợp lệ' };
  }

  let finalName = shipping_name, finalPhone = shipping_phone, finalAddress = shipping_address;
  if (address_id) {
    const [addrRows] = await pool.query(
      'SELECT * FROM addresses WHERE id = ? AND user_id = ?', [address_id, userId]
    );
    if (!addrRows.length) return { success: false, error: 'Địa chỉ không hợp lệ' };
    const addr = addrRows[0];
    finalName = addr.recipient_name;
    finalPhone = addr.phone;
    finalAddress = `${addr.address_line}, ${addr.ward}, ${addr.district}, ${addr.province}`;
  }
  if (!finalName || !finalPhone || !finalAddress) {
    return { success: false, error: 'Vui lòng nhập đầy đủ thông tin giao hàng' };
  }

  const { items } = await cartService.getCartSummary(userId);
  if (!items.length) return { success: false, error: 'Giỏ hàng trống' };

  for (const item of items) {
    const [rows] = await pool.query('SELECT stock_quantity, status FROM products WHERE id = ?', [item.product_id]);
    if (!rows.length || rows[0].status === 'inactive') {
      return { success: false, error: `Sản phẩm "${item.name}" không còn tồn tại` };
    }
    if (rows[0].stock_quantity < item.quantity) {
      return { success: false, error: `"${item.name}" chỉ còn ${rows[0].stock_quantity} sản phẩm` };
    }
  }

  const subtotal = items.reduce((s, i) => s + i.price_at_time * i.quantity, 0);
  const shipping_fee = subtotal >= 2000000 ? 0 : 50000;
  const total_amount = subtotal + shipping_fee;

  const orderCode = generateOrderCode();
  const paymentStatus = payment_method === 'cod' ? 'unpaid' : 'pending';

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [orderResult] = await conn.query(
      `INSERT INTO orders (user_id, order_code, subtotal, shipping_fee, total_amount,
        order_status, payment_status, payment_method, shipping_name, shipping_phone, shipping_address, note)
       VALUES (?, ?, ?, ?, ?, 'pending', ?, ?, ?, ?, ?, ?)`,
      [userId, orderCode, subtotal, shipping_fee, total_amount, paymentStatus, payment_method,
       finalName, finalPhone, finalAddress, note || null]
    );
    const orderId = orderResult.insertId;

    for (const item of items) {
      await conn.query(
        `INSERT INTO order_items (order_id, product_id, product_name, product_image, price, quantity, total_price)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [orderId, item.product_id, item.name, item.main_image, item.price_at_time,
         item.quantity, item.price_at_time * item.quantity]
      );
    }

    await conn.query(
      'INSERT INTO payments (order_id, payment_method, payment_status, amount) VALUES (?, ?, ?, ?)',
      [orderId, payment_method, paymentStatus, total_amount]
    );

    const [cartRows] = await conn.query('SELECT id FROM carts WHERE user_id = ?', [userId]);
    if (cartRows.length) {
      await conn.query('DELETE FROM cart_items WHERE cart_id = ?', [cartRows[0].id]);
    }

    await conn.commit();
    return { success: true, orderCode, orderId, payment_method };

  } catch (err) {
    await conn.rollback();
    console.error('Create order error:', err);
    return { success: false, error: 'Đặt hàng thất bại, vui lòng thử lại' };
  } finally {
    conn.release();
  }
}

async function getOrdersByUser(userId, page = 1) {
  const pageSize = 10;
  const offset = (page - 1) * pageSize;
  const [orders] = await pool.query(
    `SELECT o.*, COUNT(oi.id) AS item_count
     FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.id
     WHERE o.user_id = ? GROUP BY o.id ORDER BY o.created_at DESC
     LIMIT ? OFFSET ?`,
    [userId, pageSize, offset]
  );
  const [[{ cnt }]] = await pool.query('SELECT COUNT(*) AS cnt FROM orders WHERE user_id = ?', [userId]);
  return { orders, totalPages: Math.ceil(cnt / pageSize), page };
}

async function getOrderDetail(orderCode, userId) {
  const [rows] = await pool.query(
    'SELECT * FROM orders WHERE order_code = ? AND user_id = ?', [orderCode, userId]
  );
  if (!rows.length) return null;
  const order = rows[0];

  const [items] = await pool.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
  const [payment] = await pool.query('SELECT * FROM payments WHERE order_id = ?', [order.id]);
  const [reviews] = await pool.query(
    'SELECT product_id FROM reviews WHERE user_id = ? AND order_id = ?', [userId, order.id]
  );
  const reviewedProductIds = reviews.map(r => r.product_id);

  return { ...order, items, payment: payment[0] || null, reviewedProductIds };
}

async function cancelOrder(orderCode, userId, reason) {
  const [rows] = await pool.query(
    'SELECT * FROM orders WHERE order_code = ? AND user_id = ?', [orderCode, userId]
  );
  if (!rows.length) return { success: false, error: 'Không tìm thấy đơn hàng' };
  const order = rows[0];

  if (!['pending', 'confirmed'].includes(order.order_status)) {
    return { success: false, error: 'Đơn hàng này không thể hủy' };
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    await conn.query(
      "UPDATE orders SET order_status = 'cancelled', cancelled_reason = ?, updated_at = NOW() WHERE id = ?",
      [reason || 'Khách hàng hủy đơn', order.id]
    );

    if (order.payment_status === 'paid') {
      await conn.query(
        "UPDATE payments SET payment_status = 'refunded' WHERE order_id = ?", [order.id]
      );
    }

    if (order.order_status === 'confirmed') {
      const [items] = await conn.query('SELECT product_id, quantity FROM order_items WHERE order_id = ?', [order.id]);
      for (const item of items) {
        await conn.query(
          'UPDATE products SET stock_quantity = stock_quantity + ? WHERE id = ?',
          [item.quantity, item.product_id]
        );
        await conn.query(
          "UPDATE products SET status = 'active' WHERE id = ? AND status = 'out_of_stock' AND stock_quantity > 0",
          [item.product_id]
        );
      }
    }

    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    return { success: false, error: 'Hủy đơn thất bại' };
  } finally {
    conn.release();
  }
}

module.exports = { createOrder, getOrdersByUser, getOrderDetail, cancelOrder };
