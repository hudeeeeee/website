const authService = require('../services/auth.service');

const getLogin = (req, res) => {
  if (req.session.user) return res.redirect('/');
  res.render('auth/login', { title: 'Đăng nhập', returnUrl: req.query.returnUrl || '/' });
};

const postLogin = async (req, res) => {
  const { email, password } = req.body;
  const result = await authService.login({ email, password });

  if (!result.success) {
    req.flash('error', result.error);
    return res.redirect('/login');
  }

  req.session.user = result.user;
  const returnUrl = req.body.returnUrl || '/';

  if (result.user.role === 'admin') return res.redirect('/admin');
  res.redirect(returnUrl);
};

const getRegister = (req, res) => {
  if (req.session.user) return res.redirect('/');
  res.render('auth/register', { title: 'Đăng ký tài khoản' });
};

const postRegister = async (req, res) => {
  const result = await authService.register(req.body);

  if (!result.success) {
    req.flash('error', result.errors.join('. '));
    return res.redirect('/register');
  }

  req.flash('success', 'Đăng ký thành công! Vui lòng đăng nhập.');
  res.redirect('/login');
};

const logout = (req, res) => {
  req.session.destroy(() => res.redirect('/'));
};

const getChangePassword = (req, res) => {
  res.render('pages/profile/change-password', { title: 'Đổi mật khẩu' });
};

const postChangePassword = async (req, res) => {
  const result = await authService.changePassword(req.session.user.id, req.body);
  if (!result.success) {
    req.flash('error', result.error);
    return res.redirect('/profile/change-password');
  }
  req.flash('success', 'Đổi mật khẩu thành công');
  res.redirect('/profile');
};

const getProfile = async (req, res) => {
  const [user, addresses] = await Promise.all([
    authService.getProfile(req.session.user.id),
    authService.getAddresses(req.session.user.id)
  ]);
  res.render('pages/profile/index', { title: 'Tài khoản của tôi', user, addresses });
};

const getAddressAdd = (req, res) => {
  res.render('pages/profile/address-form', { title: 'Thêm địa chỉ', isEdit: false, address: null });
};

const postAddressAdd = async (req, res) => {
  const data = { ...req.body, is_default: !!req.body.is_default };
  await authService.addAddress(req.session.user.id, data);
  req.flash('success', 'Đã thêm địa chỉ');
  res.redirect('/profile');
};

const getAddressEdit = async (req, res) => {
  const addresses = await authService.getAddresses(req.session.user.id);
  const address = addresses.find(a => a.id === parseInt(req.params.id));
  if (!address) { req.flash('error', 'Không tìm thấy địa chỉ'); return res.redirect('/profile'); }
  res.render('pages/profile/address-form', { title: 'Sửa địa chỉ', isEdit: true, address });
};

const postAddressEdit = async (req, res) => {
  const data = { ...req.body, is_default: !!req.body.is_default };
  const result = await authService.editAddress(req.session.user.id, req.params.id, data);
  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Đã cập nhật địa chỉ');
  res.redirect('/profile');
};

const postAddressDelete = async (req, res) => {
  const result = await authService.deleteAddress(req.session.user.id, req.params.id);
  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Đã xoá địa chỉ');
  res.redirect('/profile');
};

const postAddressDefault = async (req, res) => {
  await authService.setDefaultAddress(req.session.user.id, req.params.id);
  req.flash('success', 'Đã đặt địa chỉ mặc định');
  res.redirect('/profile');
};

module.exports = {
  getLogin, postLogin, getRegister, postRegister, logout,
  getChangePassword, postChangePassword,
  getProfile, getAddressAdd, postAddressAdd, getAddressEdit, postAddressEdit,
  postAddressDelete, postAddressDefault
};
