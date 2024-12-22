const express = require('express');
const { getAllAwards, getAwardById, getAwardByUserId, postAward, editAwardById, deleteAwardById } = require('../controllers/awardController');
const router = express.Router();

router.get('', getAllAwards);
router.get('/user', getAwardByUserId);
router.get('/id', getAwardById);
router.post('', postAward);
router.put('/edit/:id', editAwardById);
router.delete('/delete/:id', deleteAwardById);

module.exports = router;
