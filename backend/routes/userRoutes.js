const express = require('express');
const { registerUser, loginUser, getAllUsers, requestLoginOTP, loginWithOTP } = require('../controllers/userController');
const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/request-login', requestLoginOTP);
router.post('/login-otp', loginWithOTP)
router.get('', getAllUsers);

module.exports = router;
