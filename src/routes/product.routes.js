const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/product.controller');

router.get('/products', ctrl.getProducts);
router.get('/products/:slug', ctrl.getProductDetail);
router.get('/categories/:slug', ctrl.getByCategory);
router.get('/search', (req, res) => res.redirect('/products?' + new URLSearchParams(req.query)));

module.exports = router;
