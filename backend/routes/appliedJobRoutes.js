const express = require('express');
const { getAllAppliedJobs } = require('../controllers/appliedJobController');
const router = express.Router();

router.get('', getAllAppliedJobs);

module.exports = router;
