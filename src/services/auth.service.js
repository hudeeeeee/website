const pool = require('../config/database');
const { hash, compare } = require('../utils/password');
const { validateEmail, validatePhone, validatePassword } = require('../utils/validators');

async function register({ full_name, email, phone, password, confirm_password }) {
  const errors = [];
  if (!full_name || full_name.trim().length < 2) errors.push('Họ tên ít nhất 2 ký tự');
  if (!validateEmail(email)) errors.push('Email không hợp lệ');
  if (phone && !validatePhone(phone)) errors.push('Số điện thoại không hợp lệ');
  if (!validatePassword(password)) errors.push('Mật khẩu ít nhất 8 ký tự');
  if (password !== confirm_password) errors.push('Mật khẩu xác nhận không khớp');
  if (errors.length) return { success: false, errors };

  const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email.toLowerCase()]);
  if (existing.length) return { success: false, errors: ['Email đã được sử dụng'] };

  const password_hash = await hash(password);
  const [result] = await pool.query(
    'INSERT INTO users (full_name, email, phone, password_hash) VALUES (?, ?, ?, ?)',
    [full_name.trim(), email.toLowerCase(), phone || null, password_hash]
  );
  return { success: true, userId: result.insertId };
}

async function login({ email, password }) {
  if (!email || !password) return { success: false, error: 'Vui lòng nhập đầy đủ thông tin' };

  const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email.toLowerCase()]);
  if (!rows.length) return { success: false, error: 'Email hoặc mật khẩu không đúng' };

  const user = rows[0];
  if (user.status === 'blocked') return { success: false, error: 'Tài khoản của bạn đã bị khoá' };

  const match = await compare(password, user.password_hash);
  if (!match) return { success: false, error: 'Email hoặc mật khẩu không đúng' };

  const { password_hash, ...safeUser } = user;
  return { success: true, user: safeUser };
}

async function changePassword(userId, { current_password, new_password, confirm_new_password }) {
  if (!validatePassword(new_password)) return { success: false, error: 'Mật khẩu mới ít nhất 8 ký tự' };
  if (new_password !== confirm_new_password) return { success: false, error: 'Mật khẩu xác nhận không khớp' };

  const [rows] = await pool.query('SELECT password_hash FROM users WHERE id = ?', [userId]);
  if (!rows.length) return { success: false, error: 'Người dùng không tồn tại' };

  const match = await compare(current_password, rows[0].password_hash);
  if (!match) return { success: false, error: 'Mật khẩu hiện tại không đúng' };

  const newHash = await hash(new_password);
  await pool.query('UPDATE users SET password_hash = ? WHERE id = ?', [newHash, userId]);
  return { success: true };
}

async function getProfile(userId) {
  const [rows] = await pool.query('SELECT id, full_name, email, phone, created_at FROM users WHERE id = ?', [userId]);
  return rows[0] || null;
}

async function getAddresses(userId) {
  const [rows] = await pool.query('SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id ASC', [userId]);
  return rows;
}

async function addAddress(userId, { recipient_name, phone, address_line, ward, district, province, is_default }) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    if (is_default) {
      await conn.query('UPDATE addresses SET is_default = 0 WHERE user_id = ?', [userId]);
    }
    const [result] = await conn.query(
      'INSERT INTO addresses (user_id, recipient_name, phone, address_line, ward, district, province, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [userId, recipient_name, phone, address_line, ward, district, province, is_default ? 1 : 0]
    );
    await conn.commit();
    return { success: true, id: result.insertId };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function editAddress(userId, addrId, { recipient_name, phone, address_line, ward, district, province, is_default }) {
  const [check] = await pool.query('SELECT id FROM addresses WHERE id = ? AND user_id = ?', [addrId, userId]);
  if (!check.length) return { success: false, error: 'Không tìm thấy địa chỉ' };

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    if (is_default) {
      await conn.query('UPDATE addresses SET is_default = 0 WHERE user_id = ?', [userId]);
    }
    await conn.query(
      'UPDATE addresses SET recipient_name=?, phone=?, address_line=?, ward=?, district=?, province=?, is_default=? WHERE id = ? AND user_id = ?',
      [recipient_name, phone, address_line, ward, district, province, is_default ? 1 : 0, addrId, userId]
    );
    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function deleteAddress(userId, addrId) {
  const [check] = await pool.query('SELECT is_default FROM addresses WHERE id = ? AND user_id = ?', [addrId, userId]);
  if (!check.length) return { success: false, error: 'Không tìm thấy địa chỉ' };
  if (check[0].is_default) return { success: false, error: 'Không thể xoá địa chỉ mặc định' };
  await pool.query('DELETE FROM addresses WHERE id = ? AND user_id = ?', [addrId, userId]);
  return { success: true };
}

async function setDefaultAddress(userId, addrId) {
  const [check] = await pool.query('SELECT id FROM addresses WHERE id = ? AND user_id = ?', [addrId, userId]);
  if (!check.length) return { success: false, error: 'Không tìm thấy địa chỉ' };
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query('UPDATE addresses SET is_default = 0 WHERE user_id = ?', [userId]);
    await conn.query('UPDATE addresses SET is_default = 1 WHERE id = ? AND user_id = ?', [addrId, userId]);
    await conn.commit();
    return { success: true };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = { register, login, changePassword, getProfile, getAddresses, addAddress, editAddress, deleteAddress, setDefaultAddress };
