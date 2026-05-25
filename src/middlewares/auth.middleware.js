function requireAuth(req, res, next) {
  if (!req.session.user) {
    req.flash('error', 'Vui lòng đăng nhập để tiếp tục');
    return res.redirect('/login?returnUrl=' + encodeURIComponent(req.originalUrl));
  }
  next();
}
module.exports = { requireAuth };
