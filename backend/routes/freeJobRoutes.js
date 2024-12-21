const express = require('express');
const { getAllFreeJobs } = require('../controllers/freeJobController');
const router = express.Router();

router.get('', getAllFreeJobs);

module.exports = router;
