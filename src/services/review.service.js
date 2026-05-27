const pool = require('../config/database');

async function canReview(userId, productId, orderId) {
  const [orders] = await pool.query(
    "SELECT id FROM orders WHERE id = ? AND user_id = ? AND payment_status = 'paid' AND order_status != 'cancelled'",
    [orderId, userId]
  );
  if (!orders.length) return { allowed: false, reason: 'Đơn hàng chưa thanh toán hoặc không tồn tại' };

  const [items] = await pool.query(
    'SELECT id FROM order_items WHERE order_id = ? AND product_id = ?',
    [orderId, productId]
  );
  if (!items.length) return { allowed: false, reason: 'Sản phẩm không thuộc đơn hàng này' };

  const [existing] = await pool.query(
    'SELECT id FROM reviews WHERE user_id = ? AND product_id = ? AND order_id = ?',
    [userId, productId, orderId]
  );
  if (existing.length) return { allowed: false, reason: 'Bạn đã đánh giá sản phẩm này' };

  return { allowed: true };
}

async function createReview(userId, { product_id, order_id, rating, comment }) {
  const ratingNum = parseInt(rating);
  if (!ratingNum || ratingNum < 1 || ratingNum > 5) {
    return { success: false, error: 'Điểm đánh giá phải từ 1 đến 5' };
  }

  const check = await canReview(userId, product_id, order_id);
  if (!check.allowed) return { success: false, error: check.reason };

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    await conn.query(
      'INSERT INTO reviews (user_id, product_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)',
      [userId, product_id, order_id, ratingNum, comment?.trim() || null]
    );

    await conn.query(
      `UPDATE products SET
         avg_rating = (SELECT AVG(rating) FROM reviews WHERE product_id = ? AND status = 'visible'),
         review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = ? AND status = 'visible')
       WHERE id = ?`,
      [product_id, product_id, product_id]
    );

    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    return { success: false, error: 'Đánh giá thất bại' };
  } finally {
    conn.release();
  }
}

async function getProductReviews(productId, page = 1) {
  const pageSize = 5;
  const offset = (page - 1) * pageSize;
  const [reviews] = await pool.query(
    `SELECT r.*, u.full_name FROM reviews r JOIN users u ON r.user_id = u.id
     WHERE r.product_id = ? AND r.status = 'visible'
     ORDER BY r.created_at DESC LIMIT ? OFFSET ?`,
    [productId, pageSize, offset]
  );
  const [[{ cnt }]] = await pool.query(
    "SELECT COUNT(*) AS cnt FROM reviews WHERE product_id = ? AND status = 'visible'", [productId]
  );
  return { reviews, totalPages: Math.ceil(cnt / pageSize), page, total: cnt };
}

async function setReviewStatus(reviewId, status) {
  const valid = ['visible', 'hidden', 'pending'];
  if (!valid.includes(status)) return { success: false, error: 'Trạng thái không hợp lệ' };

  const [rows] = await pool.query('SELECT product_id FROM reviews WHERE id = ?', [reviewId]);
  if (!rows.length) return { success: false, error: 'Không tìm thấy đánh giá' };
  const productId = rows[0].product_id;

  await pool.query('UPDATE reviews SET status = ? WHERE id = ?', [status, reviewId]);

  await pool.query(
    `UPDATE products SET
       avg_rating = COALESCE((SELECT AVG(rating) FROM reviews WHERE product_id = ? AND status = 'visible'), 0),
       review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = ? AND status = 'visible')
     WHERE id = ?`,
    [productId, productId, productId]
  );

  return { success: true };
}

module.exports = { canReview, createReview, getProductReviews, setReviewStatus };
