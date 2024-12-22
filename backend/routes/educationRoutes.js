const express = require('express');
const { getAllEducations, getEducationByUserId, postEducation, editEducation, deletedEducation } = require('../controllers/educationController');
const router = express.Router();

router.get('', getAllEducations);
router.get('/:id', getEducationByUserId);
router.post('', postEducation);
router.put('/edit/:id', editEducation);
router.delete('/delete/:id', deletedEducation);

module.exports = router;
