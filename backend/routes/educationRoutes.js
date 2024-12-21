const express = require('express');
const { getAllEducations } = require('../controllers/educationController');
const router = express.Router();

router.get('', getAllEducations);

module.exports = router;
