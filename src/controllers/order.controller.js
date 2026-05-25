const orderService = require('../services/order.service');
const cartService = require('../services/cart.service');
const pool = require('../config/database');

const getCheckout = async (req, res) => {
  const { items, subtotal, shipping_fee, total } = await cartService.getCartSummary(req.session.user.id);
  if (!items.length) {
    req.flash('error', 'Giỏ hàng trống, không thể thanh toán');
    return res.redirect('/cart');
  }
  const [addresses] = await pool.query(
    'SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC', [req.session.user.id]
  );
  res.render('pages/checkout', { title: 'Đặt hàng', items, subtotal, shipping_fee, total, addresses });
};

const postOrder = async (req, res) => {
  const result = await orderService.createOrder(req.session.user.id, req.body);
  if (!result.success) {
    req.flash('error', result.error);
    return res.redirect('/checkout');
  }
  if (result.payment_method === 'bank_transfer') {
    return res.redirect(`/payment/bank-info/${result.orderCode}`);
  }
  if (result.payment_method === 'vnpay') {
    return res.redirect(`/payment/vnpay/create?orderCode=${result.orderCode}`);
  }
  req.flash('success', 'Đặt hàng thành công! Cảm ơn bạn đã mua hàng.');
  res.redirect(`/orders/${result.orderCode}`);
};

const getOrders = async (req, res) => {
  const data = await orderService.getOrdersByUser(req.session.user.id, parseInt(req.query.page) || 1);
  res.render('pages/orders/index', { title: 'Đơn hàng của tôi', ...data });
};

const getOrderDetail = async (req, res) => {
  const order = await orderService.getOrderDetail(req.params.code, req.session.user.id);
  if (!order) return res.status(404).render('errors/404', { title: 'Không tìm thấy đơn hàng' });
  res.render('pages/orders/detail', { title: `Đơn hàng ${order.order_code}`, order });
};

const cancelOrder = async (req, res) => {
  const result = await orderService.cancelOrder(req.params.code, req.session.user.id, req.body.reason);
  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Đã hủy đơn hàng thành công');
  res.redirect(`/orders/${req.params.code}`);
};

module.exports = { getCheckout, postOrder, getOrders, getOrderDetail, cancelOrder };
