const express = require('express');
const { getAllJobs, getJobById, getJobByUserId, deleteJob, postJob,
    updateJob } = require('../controllers/jobController');
const router = express.Router();

router.get('', getAllJobs);
router.get('/:id', getJobById);
router.get('/user/:user_id', getJobByUserId);
router.delete('/delete/:id', deleteJob);
router.post('', postJob);
router.put('/update/:id', updateJob);

module.exports = router;
