const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/auth.controller');
const { requireAuth } = require('../middlewares/auth.middleware');

router.get('/login', ctrl.getLogin);
router.post('/login', ctrl.postLogin);
router.get('/register', ctrl.getRegister);
router.post('/register', ctrl.postRegister);
router.post('/logout', ctrl.logout);

router.get('/profile', requireAuth, ctrl.getProfile);
router.get('/profile/change-password', requireAuth, ctrl.getChangePassword);
router.post('/profile/change-password', requireAuth, ctrl.postChangePassword);

router.get('/profile/address/add', requireAuth, ctrl.getAddressAdd);
router.post('/profile/address/add', requireAuth, ctrl.postAddressAdd);
router.get('/profile/address/:id/edit', requireAuth, ctrl.getAddressEdit);
router.post('/profile/address/:id/edit', requireAuth, ctrl.postAddressEdit);
router.post('/profile/address/:id/delete', requireAuth, ctrl.postAddressDelete);
router.post('/profile/address/:id/default', requireAuth, ctrl.postAddressDefault);

module.exports = router;
