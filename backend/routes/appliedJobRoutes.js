const express = require('express');
const { getAllAppliedJobs, getAppliedJobsByUserId, deleteAppliedJob } = require('../controllers/appliedJobController');
const router = express.Router();

router.get('', getAllAppliedJobs);
router.get('/:user_id', getAppliedJobsByUserId);
router.delete('/delete/', deleteAppliedJob);

module.exports = router;
