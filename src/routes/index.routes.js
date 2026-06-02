const express = require('express');
const router = express.Router();

const authRoutes = require('./auth.routes');
const productRoutes = require('./product.routes');
const cartRoutes = require('./cart.routes');
const orderRoutes = require('./order.routes');
const paymentRoutes = require('./payment.routes');
const reviewRoutes = require('./review.routes');
const warrantyRoutes = require('./warranty.routes');
const chatRoutes = require('./chat.routes');

router.use('/', authRoutes);
router.use('/', cartRoutes);
router.use('/', orderRoutes);
router.use('/', paymentRoutes);
router.use('/', reviewRoutes);
router.use('/', warrantyRoutes);
router.use('/', productRoutes);
router.use('/', chatRoutes);

// Home (product controller with featured products)
const productCtrl = require('../controllers/product.controller');
router.get('/', productCtrl.getHome);

module.exports = router;
