const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/order.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/checkout', requireAuth, ctrl.getCheckout);
router.post('/orders', requireAuth, ctrl.postOrder);
router.get('/orders', requireAuth, ctrl.getOrders);
router.get('/orders/:code', requireAuth, ctrl.getOrderDetail);
router.post('/orders/:code/cancel', requireAuth, ctrl.cancelOrder);

module.exports = router;
