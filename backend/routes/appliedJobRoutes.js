const express = require('express');
const { getAllAppliedJobs, getAppliedJobsByUserId, deleteAppliedJob, 
    getJobAndApplicationsByUserid, updateSeen, getApplicationCount } = require('../controllers/appliedJobController');
const router = express.Router();

router.get('', getAllAppliedJobs);
router.get('/:user_id', getAppliedJobsByUserId);
router.delete('/delete/', deleteAppliedJob);
router.get('/job/:user_id', getJobAndApplicationsByUserid);
router.put('/seen', updateSeen);
router.get('/count/:post_id', getApplicationCount);

module.exports = router;
