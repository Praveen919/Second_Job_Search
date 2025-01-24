const express = require('express');
const { getAllJobs, postJob, getShortlistedJobsById, findJobsByUserId } = require('../controllers/jobController');
const router = express.Router();

router.get('', getAllJobs);
router.post('', postJob);
router.get('/get-shortlisted-job-by-id/:id', getShortlistedJobsById);
router.get('/find-job/:id', findJobsByUserId);

module.exports = router;
