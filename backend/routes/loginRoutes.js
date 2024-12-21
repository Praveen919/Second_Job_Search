const express = require('express');
const { getAllLogins } = require('../controllers/loginController');
const router = express.Router();

router.get('', getAllLogins);

module.exports = router;
