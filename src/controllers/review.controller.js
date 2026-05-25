const reviewService = require('../services/review.service');
const pool = require('../config/database');

const getCreateReview = async (req, res) => {
  const { product_id, order_id } = req.query;
  const [products] = await pool.query('SELECT name, slug FROM products WHERE id = ?', [product_id]);
  if (!products.length) return res.status(404).render('errors/404', { title: 'Sản phẩm không tìm thấy' });

  const check = await reviewService.canReview(req.session.user.id, product_id, order_id);
  if (!check.allowed) {
    req.flash('error', check.reason);
    return res.redirect('back');
  }

  res.render('pages/reviews/create', {
    title: 'Đánh giá sản phẩm',
    product: products[0],
    product_id,
    order_id
  });
};

const postCreateReview = async (req, res) => {
  const result = await reviewService.createReview(req.session.user.id, req.body);
  if (!result.success) {
    req.flash('error', result.error);
    return res.redirect('back');
  }
  req.flash('success', 'Cảm ơn bạn đã đánh giá sản phẩm!');
  const orderId = req.body.order_id;
  const [orderRows] = await pool.query('SELECT order_code FROM orders WHERE id = ?', [orderId]);
  const redirectTo = orderRows.length ? `/orders/${orderRows[0].order_code}` : '/orders';
  res.redirect(redirectTo);
};

module.exports = { getCreateReview, postCreateReview };
