const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/cart.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/cart/count', ctrl.getCartCount);
router.get('/cart', requireAuth, ctrl.getCart);
router.post('/cart/add', requireAuth, ctrl.addToCart);
router.patch('/cart/items/:id', requireAuth, ctrl.updateItem);
router.delete('/cart/items/:id', requireAuth, ctrl.removeItem);
router.post('/cart/clear', requireAuth, ctrl.clearCart);

module.exports = router;
