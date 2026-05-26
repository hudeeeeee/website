const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/payment.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/payment/bank-info/:orderCode', requireAuth, ctrl.getBankInfo);
router.get('/payment/vnpay/create', requireAuth, ctrl.createVNPayUrl);
router.get('/payment/vnpay/return', ctrl.vnpayReturn);
router.get('/payment/vnpay/ipn', ctrl.vnpayIPN);

module.exports = router;

// TEST ONLY - simulate VNPay success
router.get('/payment/test-vnpay-success/:orderCode', requireAuth, async (req, res) => {
  const paymentService = require('../services/payment.service');
  const result = await paymentService.handleVNPaySuccess(req.params.orderCode, 'TEST_TXN_' + Date.now());
  if (result.success) {
    req.flash('success', 'TEST: Thanh toán thành công!');
  } else {
    req.flash('error', result.error);
  }
  res.redirect(`/orders/${req.params.orderCode}`);
});
