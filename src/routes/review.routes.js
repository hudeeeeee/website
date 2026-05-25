const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/review.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/reviews/create', requireAuth, ctrl.getCreateReview);
router.post('/reviews', requireAuth, ctrl.postCreateReview);

module.exports = router;
