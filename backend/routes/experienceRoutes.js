const express = require('express');
const { getAllExperiences, getExperienceByUserId, postExperience, editExperience, deletedExperience } = require('../controllers/experienceController');
const router = express.Router();

router.get('', getAllExperiences);
router.get('/:id', getExperienceByUserId);
router.post('', postExperience);
router.put('/edit/:id', editExperience);
router.delete('/delete/:id', deletedExperience);

module.exports = router;
