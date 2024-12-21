const express = require('express');
const { getAllAwards } = require('../controllers/awardController');
const router = express.Router();

router.get('', getAllAwards);

module.exports = router;
