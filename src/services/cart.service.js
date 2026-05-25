const pool = require('../config/database');

async function getOrCreateCart(userId) {
  let [rows] = await pool.query('SELECT id FROM carts WHERE user_id = ?', [userId]);
  if (rows.length) return rows[0].id;
  const [result] = await pool.query('INSERT INTO carts (user_id) VALUES (?)', [userId]);
  return result.insertId;
}

async function getCartItems(userId) {
  const [rows] = await pool.query(
    `SELECT ci.id, ci.quantity, ci.price_at_time,
            p.id AS product_id, p.name, p.slug, p.stock_quantity,
            p.price, p.sale_price, p.status,
            pi.image_url AS main_image
     FROM cart_items ci
     JOIN carts c ON ci.cart_id = c.id
     JOIN products p ON ci.product_id = p.id
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     WHERE c.user_id = ?
     ORDER BY ci.id DESC`,
    [userId]
  );
  return rows;
}

async function getCartSummary(userId) {
  const items = await getCartItems(userId);
  const subtotal = items.reduce((sum, i) => sum + i.price_at_time * i.quantity, 0);
  const shipping_fee = subtotal >= 2000000 ? 0 : 50000;
  const total = subtotal + shipping_fee;
  const count = items.reduce((sum, i) => sum + i.quantity, 0);
  return { items, subtotal, shipping_fee, total, count };
}

async function addItem(userId, productId, quantity) {
  quantity = parseInt(quantity);
  if (!quantity || quantity < 1) return { success: false, error: 'Số lượng không hợp lệ' };

  const [products] = await pool.query(
    'SELECT id, price, sale_price, stock_quantity, status FROM products WHERE id = ?',
    [productId]
  );
  if (!products.length || products[0].status === 'inactive') {
    return { success: false, error: 'Sản phẩm không tồn tại' };
  }
  const product = products[0];
  if (product.stock_quantity === 0) {
    return { success: false, error: 'Sản phẩm đã hết hàng' };
  }

  const cartId = await getOrCreateCart(userId);
  const price = product.sale_price || product.price;

  const [existing] = await pool.query(
    'SELECT id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?',
    [cartId, productId]
  );

  if (existing.length) {
    const newQty = existing[0].quantity + quantity;
    if (newQty > product.stock_quantity) {
      return { success: false, error: `Chỉ còn ${product.stock_quantity} sản phẩm trong kho` };
    }
    await pool.query('UPDATE cart_items SET quantity = ? WHERE id = ?', [newQty, existing[0].id]);
  } else {
    if (quantity > product.stock_quantity) {
      return { success: false, error: `Chỉ còn ${product.stock_quantity} sản phẩm trong kho` };
    }
    await pool.query(
      'INSERT INTO cart_items (cart_id, product_id, quantity, price_at_time) VALUES (?, ?, ?, ?)',
      [cartId, productId, quantity, price]
    );
  }

  const summary = await getCartSummary(userId);
  return { success: true, cartCount: summary.count };
}

async function updateItem(userId, itemId, quantity) {
  quantity = parseInt(quantity);

  const [rows] = await pool.query(
    `SELECT ci.id, ci.product_id FROM cart_items ci
     JOIN carts c ON ci.cart_id = c.id
     WHERE ci.id = ? AND c.user_id = ?`,
    [itemId, userId]
  );
  if (!rows.length) return { success: false, error: 'Không tìm thấy mục trong giỏ hàng' };

  if (quantity < 1) return removeItem(userId, itemId);

  const [stock] = await pool.query('SELECT stock_quantity FROM products WHERE id = ?', [rows[0].product_id]);
  if (quantity > stock[0].stock_quantity) {
    return { success: false, error: `Chỉ còn ${stock[0].stock_quantity} sản phẩm` };
  }

  await pool.query('UPDATE cart_items SET quantity = ? WHERE id = ?', [quantity, itemId]);
  const summary = await getCartSummary(userId);
  const [item] = await pool.query('SELECT price_at_time FROM cart_items WHERE id = ?', [itemId]);
  const itemTotal = item[0].price_at_time * quantity;

  return { success: true, cartCount: summary.count, subtotal: summary.subtotal,
           shipping_fee: summary.shipping_fee, total: summary.total, itemTotal };
}

async function removeItem(userId, itemId) {
  const [rows] = await pool.query(
    `SELECT ci.id FROM cart_items ci JOIN carts c ON ci.cart_id = c.id
     WHERE ci.id = ? AND c.user_id = ?`,
    [itemId, userId]
  );
  if (!rows.length) return { success: false, error: 'Không tìm thấy mục trong giỏ hàng' };

  await pool.query('DELETE FROM cart_items WHERE id = ?', [itemId]);
  const summary = await getCartSummary(userId);
  return { success: true, cartCount: summary.count, subtotal: summary.subtotal,
           shipping_fee: summary.shipping_fee, total: summary.total };
}

async function clearCart(userId) {
  const cartId = await getOrCreateCart(userId);
  await pool.query('DELETE FROM cart_items WHERE cart_id = ?', [cartId]);
}

module.exports = { getCartSummary, addItem, updateItem, removeItem, clearCart, getOrCreateCart };
