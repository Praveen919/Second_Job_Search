const express = require('express');
const { getAllJobs, getJobById } = require('../controllers/jobController');
const router = express.Router();

router.get('', getAllJobs);
router.get('/:id', getJobById);

module.exports = router;
