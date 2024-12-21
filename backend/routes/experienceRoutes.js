const express = require('express');
const { getAllExperiences } = require('../controllers/experienceController');
const router = express.Router();

router.get('', getAllExperiences);

module.exports = router;
