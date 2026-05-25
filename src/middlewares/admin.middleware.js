function requireAdmin(req, res, next) {
  if (!req.session.user) return res.redirect('/login');
  if (req.session.user.role !== 'admin') {
    return res.status(403).render('errors/403', { title: 'Không có quyền truy cập' });
  }
  next();
}
module.exports = { requireAdmin };
