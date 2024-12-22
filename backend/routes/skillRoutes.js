const express = require('express');
const { getAllSkills, getSkillByUserId, postSkill, editSkill, deletedSkill } = require('../controllers/skillController');
const router = express.Router();

router.get('', getAllSkills);
router.get('/:id', getSkillByUserId);
router.post('', postSkill);
router.put('/edit/:id', editSkill);
router.delete('/delete/:id', deletedSkill)

module.exports = router;
