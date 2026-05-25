const cartService = require('../services/cart.service');

const getCart = async (req, res) => {
  const summary = await cartService.getCartSummary(req.session.user.id);
  res.render('pages/cart', { title: 'Giỏ hàng', ...summary });
};

const addToCart = async (req, res) => {
  const { product_id, quantity } = req.body;
  const result = await cartService.addItem(req.session.user.id, product_id, quantity || 1);

  if (req.headers['content-type']?.includes('application/json') || req.headers['x-requested-with']) {
    return res.json(result);
  }

  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Đã thêm vào giỏ hàng');
  const referer = req.get('Referer') || '/products';
  res.redirect(referer);
};

const updateItem = async (req, res) => {
  const result = await cartService.updateItem(req.session.user.id, req.params.id, req.body.quantity);
  res.json(result);
};

const removeItem = async (req, res) => {
  const result = await cartService.removeItem(req.session.user.id, req.params.id);
  res.json(result);
};

const clearCart = async (req, res) => {
  await cartService.clearCart(req.session.user.id);
  req.flash('success', 'Đã xóa giỏ hàng');
  res.redirect('/cart');
};

const getCartCount = async (req, res) => {
  if (!req.session.user) return res.json({ count: 0 });
  const summary = await cartService.getCartSummary(req.session.user.id);
  res.json({ count: summary.count });
};

module.exports = { getCart, addToCart, updateItem, removeItem, clearCart, getCartCount };
