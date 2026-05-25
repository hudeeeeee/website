const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/payment.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/payment/bank-info/:orderCode', requireAuth, ctrl.getBankInfo);
router.get('/payment/vnpay/create', requireAuth, ctrl.createVNPayUrl);
router.get('/payment/vnpay/return', ctrl.vnpayReturn);
router.get('/payment/vnpay/ipn', ctrl.vnpayIPN);

module.exports = router;
