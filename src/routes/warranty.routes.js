const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/warranty.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/warranty', requireAuth, ctrl.getMyWarranty);
router.get('/warranty/create', requireAuth, ctrl.getWarrantyForm);
router.post('/warranty', requireAuth, ctrl.postWarrantyRequest);

module.exports = router;
