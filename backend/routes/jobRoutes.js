const express = require('express');
const { getAllJobs, postJob, getShortlistedJobsById, getAllJobsCount,getJobCountByUserId,getEmployerJobCounts,updateJob,
deleteJob,  findJobsByUserId } = require('../controllers/jobController');
const router = express.Router();

router.get('', getAllJobs);
router.get('/jobCount', getAllJobsCount);
router.post('', postJob);
router.get('/get-shortlisted-job-by-id/:id', getShortlistedJobsById);
router.get('/find-job/:id', findJobsByUserId);
router.get('/posted-jobs/:id', getJobCountByUserId);
router.put('/update/:id', updateJob);
router.delete('/delete/:id', deleteJob);
router.get('/counts/:id', getEmployerJobCounts);

module.exports = router;
