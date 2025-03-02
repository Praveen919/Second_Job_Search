const express = require('express');
const { getAllAppliedJobs, validateIds,getAppliedJobsCount, getAllAppliedJobsWithDetails, updateSeenStatus, 
       deleteAppliedJob, applyForJob, getApplicationUsingPostId, getApplicationUsingUserId } = require('../controllers/appliedJobController');
const router = express.Router();

router.get('', getAllAppliedJobs);
router.get('/validate', validateIds);
router.get('/appliedJobs/details', getAllAppliedJobsWithDetails);
router.put('/appliedJob/seen', updateSeenStatus);
router.delete('/appliedJob', deleteAppliedJob);
router.post('/applyJob', applyForJob);
router.get('/:user_id',getAppliedJobsCount);
router.get('/user/:user_id', getApplicationUsingUserId);
router.get('/post/:post_id', getApplicationUsingPostId);


module.exports = router;
