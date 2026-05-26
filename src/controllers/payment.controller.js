const paymentService = require('../services/payment.service');
const pool = require('../config/database');

const getBankInfo = async (req, res) => {
  const data = await paymentService.getBankInfo(req.params.orderCode, req.session.user.id);
  if (!data) return res.status(404).render('errors/404', { title: 'Không tìm thấy đơn hàng' });
  res.render('pages/payment/bank-info', { title: 'Hướng dẫn chuyển khoản', ...data });
};

const createVNPayUrl = async (req, res) => {
  const { orderCode } = req.query;
  const [rows] = await pool.query(
    'SELECT total_amount FROM orders WHERE order_code = ? AND user_id = ?',
    [orderCode, req.session.user.id]
  );
  if (!rows.length) return res.redirect('/orders');

  const ipAddr = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
  const url = await paymentService.createVNPayUrl(orderCode, rows[0].total_amount, ipAddr);
  res.redirect(url);
};

const vnpayReturn = async (req, res) => {
  const { valid, responseCode } = paymentService.verifyVNPayReturn(req.query);
  const orderCode = req.query.vnp_TxnRef;
  const txnCode = req.query.vnp_TransactionNo;

  if (!valid) {
    req.flash('error', 'Phản hồi thanh toán không hợp lệ');
    return res.redirect('/orders');
  }

  if (responseCode === '00') {
    await paymentService.handleVNPaySuccess(orderCode, txnCode);
    req.flash('success', 'Thanh toán VNPay thành công!');
    return res.redirect(`/orders/${orderCode}`);
  } else {
    await paymentService.handleVNPayFailed(orderCode);
    req.flash('error', 'Thanh toán thất bại. Vui lòng thử lại hoặc chọn phương thức khác.');
    return res.redirect(`/orders/${orderCode}`);
  }
};

const vnpayIPN = async (req, res) => {
  const { valid, responseCode } = paymentService.verifyVNPayReturn(req.query);
  if (!valid) return res.json({ RspCode: '97', Message: 'Invalid Checksum' });

  const orderCode = req.query.vnp_TxnRef;
  const txnCode = req.query.vnp_TransactionNo;

  if (responseCode === '00') {
    const result = await paymentService.handleVNPaySuccess(orderCode, txnCode);
    if (result.success) return res.json({ RspCode: '00', Message: 'Confirm Success' });
    return res.json({ RspCode: '99', Message: result.error });
  } else {
    await paymentService.handleVNPayFailed(orderCode);
    return res.json({ RspCode: '00', Message: 'Confirm Success' });
  }
};

module.exports = { getBankInfo, createVNPayUrl, vnpayReturn, vnpayIPN };
