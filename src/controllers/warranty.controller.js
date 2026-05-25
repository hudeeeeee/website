const warrantyService = require('../services/warranty.service');
const pool = require('../config/database');

const getWarrantyForm = async (req, res) => {
  res.render('pages/warranty/form', { title: 'Yêu cầu bảo hành',
    product_id: req.query.product_id, order_id: req.query.order_id });
};

const postWarrantyRequest = async (req, res) => {
  const result = await warrantyService.createWarrantyRequest(req.session.user.id, req.body);
  if (!result.success) {
    req.flash('error', result.error);
    return res.redirect('back');
  }
  req.flash('success', 'Yêu cầu bảo hành đã được gửi. Chúng tôi sẽ liên hệ với bạn sớm nhất.');
  res.redirect('/warranty');
};

const getMyWarranty = async (req, res) => {
  const requests = await warrantyService.getUserWarrantyRequests(req.session.user.id);
  res.render('pages/warranty/list', { title: 'Yêu cầu bảo hành của tôi', requests });
};

const adminListWarranty = async (req, res) => {
  const requests = await warrantyService.getAllWarrantyRequests(req.query);
  res.render('admin/warranty/index', { title: 'Quản lý bảo hành', activePage: 'warranty', requests, filters: req.query });
};

const adminUpdateWarranty = async (req, res) => {
  const result = await warrantyService.updateWarrantyStatus(req.params.id, req.body.status, req.body.admin_note);
  if (!result.success) req.flash('error', result.error);
  else req.flash('success', 'Đã cập nhật trạng thái bảo hành');
  res.redirect('/admin/warranty');
};

module.exports = { getWarrantyForm, postWarrantyRequest, getMyWarranty, adminListWarranty, adminUpdateWarranty };
