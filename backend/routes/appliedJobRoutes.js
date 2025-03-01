const express = require('express');
const { getAllAppliedJobs, validateIds,getAppliedJobsCount, getAllAppliedJobsWithDetails, updateSeenStatus, deleteAppliedJob, applyForJob } = require('../controllers/appliedJobController');
const router = express.Router();

router.get('', getAllAppliedJobs);
router.get('/validate', validateIds);
router.get('/appliedJobs/details', getAllAppliedJobsWithDetails);
router.put('/appliedJob/seen', updateSeenStatus);
router.delete('/appliedJob', deleteAppliedJob);
router.post('/applyJob', applyForJob);
router.get('/:user_id',getAppliedJobsCount)

module.exports = router;
