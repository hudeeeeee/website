const pool = require('../config/database');

const VALID_TRANSITIONS = {
  pending:    ['approved', 'rejected'],
  approved:   ['processing'],
  rejected:   [],
  processing: ['completed'],
  completed:  []
};

async function canSubmitWarranty(userId, productId, orderId) {
  const [orders] = await pool.query(
    "SELECT o.created_at FROM orders o WHERE o.id = ? AND o.user_id = ? AND o.order_status = 'completed'",
    [orderId, userId]
  );
  if (!orders.length) return { allowed: false, reason: 'Đơn hàng chưa hoàn thành hoặc không tồn tại' };

  const [items] = await pool.query(
    'SELECT oi.id FROM order_items oi WHERE oi.order_id = ? AND oi.product_id = ?',
    [orderId, productId]
  );
  if (!items.length) return { allowed: false, reason: 'Sản phẩm không thuộc đơn hàng này' };

  const [products] = await pool.query('SELECT warranty_months FROM products WHERE id = ?', [productId]);
  if (products.length && products[0].warranty_months > 0) {
    const completedAt = new Date(orders[0].created_at);
    const expiresAt = new Date(completedAt.setMonth(completedAt.getMonth() + products[0].warranty_months));
    if (new Date() > expiresAt) {
      return { allowed: false, reason: `Sản phẩm đã hết thời hạn bảo hành (${products[0].warranty_months} tháng)` };
    }
  }

  return { allowed: true };
}

async function createWarrantyRequest(userId, { product_id, order_id, issue_description }) {
  if (!issue_description?.trim()) return { success: false, error: 'Vui lòng mô tả vấn đề' };

  const check = await canSubmitWarranty(userId, product_id, order_id);
  if (!check.allowed) return { success: false, error: check.reason };

  await pool.query(
    'INSERT INTO warranty_requests (user_id, product_id, order_id, issue_description) VALUES (?, ?, ?, ?)',
    [userId, product_id, order_id, issue_description.trim()]
  );
  return { success: true };
}

async function getUserWarrantyRequests(userId) {
  const [rows] = await pool.query(
    `SELECT wr.*, p.name AS product_name, pi.image_url AS product_image, o.order_code
     FROM warranty_requests wr
     JOIN products p ON wr.product_id = p.id
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     JOIN orders o ON wr.order_id = o.id
     WHERE wr.user_id = ? ORDER BY wr.created_at DESC`,
    [userId]
  );
  return rows;
}

async function getAllWarrantyRequests({ status, page = 1 }) {
  const pageSize = 20;
  const offset = (page - 1) * pageSize;
  const where = status ? 'WHERE wr.status = ?' : '';
  const params = status ? [status, pageSize, offset] : [pageSize, offset];

  const [rows] = await pool.query(
    `SELECT wr.*, p.name AS product_name, u.full_name AS customer_name, o.order_code
     FROM warranty_requests wr
     JOIN products p ON wr.product_id = p.id
     JOIN users u ON wr.user_id = u.id
     JOIN orders o ON wr.order_id = o.id
     ${where} ORDER BY wr.created_at DESC LIMIT ? OFFSET ?`,
    params
  );
  return rows;
}

async function updateWarrantyStatus(id, newStatus, adminNote) {
  const [rows] = await pool.query('SELECT status FROM warranty_requests WHERE id = ?', [id]);
  if (!rows.length) return { success: false, error: 'Không tìm thấy yêu cầu bảo hành' };

  const currentStatus = rows[0].status;
  if (!VALID_TRANSITIONS[currentStatus]?.includes(newStatus)) {
    return { success: false, error: `Không thể chuyển từ "${currentStatus}" sang "${newStatus}"` };
  }

  await pool.query(
    'UPDATE warranty_requests SET status = ?, admin_note = ?, updated_at = NOW() WHERE id = ?',
    [newStatus, adminNote || null, id]
  );
  return { success: true };
}

module.exports = { createWarrantyRequest, getUserWarrantyRequests, getAllWarrantyRequests, updateWarrantyStatus };
