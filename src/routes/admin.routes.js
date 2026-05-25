const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../middlewares/admin.middleware');
const upload = require('../middlewares/upload.middleware');
const pool = require('../config/database');
const adminService = require('../services/admin.service');
const reviewService = require('../services/review.service');
const warrantyCtrl = require('../controllers/warranty.controller');

router.use(requireAdmin);

// Redirect /admin → /admin/dashboard
router.get('/', (req, res) => res.redirect('/admin/dashboard'));

// Dashboard
router.get('/dashboard', async (req, res) => {
  const stats = await adminService.getDashboardStats();
  res.render('admin/dashboard', { title: 'Dashboard', activePage: 'dashboard', ...stats });
});

// Products
router.get('/products', async (req, res) => {
  const data = await adminService.getAdminProducts(req.query);
  const [cats] = await pool.query("SELECT * FROM categories WHERE status = 'active'");
  res.render('admin/products/index', { title: 'Quản lý sản phẩm', activePage: 'products', ...data, categories: cats });
});

router.get('/products/create', async (req, res) => {
  const [cats] = await pool.query("SELECT * FROM categories WHERE status = 'active'");
  res.render('admin/products/form', { title: 'Thêm sản phẩm', activePage: 'products', product: null, categories: cats, images: [] });
});

router.post('/products', upload.array('images', 10), async (req, res) => {
  const result = await adminService.createProduct(req.body, req.files || []);
  if (!result.success) { req.flash('error', result.error); return res.redirect('/admin/products/create'); }
  req.flash('success', 'Đã thêm sản phẩm thành công');
  res.redirect('/admin/products');
});

router.get('/products/:id/edit', async (req, res) => {
  const [[product]] = await pool.query('SELECT * FROM products WHERE id = ?', [req.params.id]);
  if (!product) return res.status(404).render('errors/404', { title: 'Không tìm thấy' });
  const [cats] = await pool.query("SELECT * FROM categories WHERE status = 'active'");
  const [images] = await pool.query('SELECT * FROM product_images WHERE product_id = ? ORDER BY is_main DESC, sort_order', [req.params.id]);
  res.render('admin/products/form', { title: 'Sửa sản phẩm', activePage: 'products', product, categories: cats, images });
});

router.post('/products/:id', upload.array('images', 10), async (req, res) => {
  const { name, category_id, brand, price, sale_price, stock_quantity, description, specifications, warranty_months, status } = req.body;
  await pool.query(
    'UPDATE products SET name=?, category_id=?, brand=?, price=?, sale_price=?, stock_quantity=?, description=?, specifications=?, warranty_months=?, status=?, updated_at=NOW() WHERE id=?',
    [name, category_id, brand||null, price, sale_price||null, stock_quantity, description||null, specifications||null, warranty_months||0, status||'active', req.params.id]
  );
  if (req.files?.length) {
    for (const file of req.files) {
      await pool.query('INSERT INTO product_images (product_id, image_url, is_main) VALUES (?, ?, 0)', [req.params.id, '/uploads/' + file.filename]);
    }
  }
  req.flash('success', 'Đã cập nhật sản phẩm');
  res.redirect('/admin/products');
});

router.post('/products/:id/delete', async (req, res) => {
  const [[{ cnt }]] = await pool.query('SELECT COUNT(*) AS cnt FROM order_items WHERE product_id = ?', [req.params.id]);
  if (cnt > 0) {
    await pool.query("UPDATE products SET status = 'inactive' WHERE id = ?", [req.params.id]);
    req.flash('success', 'Đã ẩn sản phẩm (đã có đơn hàng liên quan)');
  } else {
    await pool.query('DELETE FROM product_images WHERE product_id = ?', [req.params.id]);
    await pool.query('DELETE FROM products WHERE id = ?', [req.params.id]);
    req.flash('success', 'Đã xóa sản phẩm');
  }
  res.redirect('/admin/products');
});

// Categories
router.get('/categories', async (req, res) => {
  const [categories] = await pool.query('SELECT * FROM categories ORDER BY sort_order');
  res.render('admin/categories/index', { title: 'Quản lý danh mục', activePage: 'categories', categories });
});

router.post('/categories', async (req, res) => {
  const slugify = require('slugify');
  const { name, description, sort_order } = req.body;
  const slug = slugify(name, { lower: true, locale: 'vi', strict: true });
  await pool.query('INSERT INTO categories (name, slug, description, sort_order) VALUES (?, ?, ?, ?)',
    [name, slug, description || null, sort_order || 0]);
  req.flash('success', 'Đã thêm danh mục');
  res.redirect('/admin/categories');
});

// Orders
router.get('/orders', async (req, res) => {
  const data = await adminService.getAdminOrders(req.query);
  res.render('admin/orders/index', { title: 'Quản lý đơn hàng', activePage: 'orders', ...data, filters: req.query });
});

router.get('/orders/:id', async (req, res) => {
  const [[order]] = await pool.query('SELECT o.*, u.full_name, u.email FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?', [req.params.id]);
  if (!order) return res.status(404).render('errors/404', { title: 'Không tìm thấy' });
  const [items] = await pool.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
  const [[payment]] = await pool.query('SELECT * FROM payments WHERE order_id = ?', [order.id]);
  res.render('admin/orders/detail', { title: `Đơn ${order.order_code}`, activePage: 'orders', order, items, payment: payment || null });
});

router.post('/orders/:id/status', async (req, res) => {
  const result = await adminService.updateOrderStatus(req.params.id, req.body.order_status);
  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Cập nhật trạng thái thành công');
  res.redirect(`/admin/orders/${req.params.id}`);
});

router.post('/orders/:id/confirm-payment', async (req, res) => {
  const paymentService = require('../services/payment.service');
  const result = await paymentService.confirmBankPayment(req.params.id, req.body.transaction_code);
  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Đã xác nhận thanh toán');
  res.redirect(`/admin/orders/${req.params.id}`);
});

// Users
router.get('/users', async (req, res) => {
  const keyword = req.query.keyword || '';
  const page = parseInt(req.query.page) || 1;
  const offset = (page - 1) * 20;
  const where = keyword ? 'WHERE full_name LIKE ? OR email LIKE ?' : '';
  const params = keyword ? [`%${keyword}%`, `%${keyword}%`] : [];
  const [users] = await pool.query(
    `SELECT id,full_name,email,phone,role,status,created_at FROM users ${where} ORDER BY created_at DESC LIMIT 20 OFFSET ?`,
    [...params, offset]
  );
  res.render('admin/users/index', { title: 'Quản lý người dùng', activePage: 'users', users, keyword });
});

router.post('/users/:id/status', async (req, res) => {
  const { status } = req.body;
  if (!['active', 'blocked'].includes(status)) { req.flash('error', 'Trạng thái không hợp lệ'); return res.redirect('/admin/users'); }
  await pool.query('UPDATE users SET status = ? WHERE id = ? AND role = "customer"', [status, req.params.id]);
  req.flash('success', status === 'blocked' ? 'Đã khoá tài khoản' : 'Đã mở khoá tài khoản');
  res.redirect('/admin/users');
});

// Reviews
router.get('/reviews', async (req, res) => {
  const [reviews] = await pool.query(
    'SELECT r.*, u.full_name, p.name AS product_name FROM reviews r JOIN users u ON r.user_id = u.id JOIN products p ON r.product_id = p.id ORDER BY r.created_at DESC LIMIT 50'
  );
  res.render('admin/reviews/index', { title: 'Quản lý đánh giá', activePage: 'reviews', reviews });
});

router.post('/reviews/:id/status', async (req, res) => {
  await reviewService.setReviewStatus(req.params.id, req.body.status);
  req.flash('success', 'Đã cập nhật trạng thái đánh giá');
  res.redirect('/admin/reviews');
});

// Warranty
router.get('/warranty', warrantyCtrl.adminListWarranty);
router.post('/warranty/:id/status', warrantyCtrl.adminUpdateWarranty);

module.exports = router;
