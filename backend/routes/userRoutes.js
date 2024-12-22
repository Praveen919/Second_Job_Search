const express = require('express');
const { registerUser, loginUser, getAllUsers, getUserById, ChangePassword,
        setDnd, deleteDnd, uploadUserImage, updateUser, uploadResume, 
        uploadUserResume, deleteResume } = require('../controllers/userController');
const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.get('', getAllUsers);
router.get('/:id', getUserById);
router.put('/change-password', ChangePassword);
router.post('/dnd', setDnd);
router.post('delete-dnd', deleteDnd);
router.put('/user/:id', uploadUserImage.single('image'), updateUser);
router.put('/upload/:user_id', uploadResume.single('resume'), uploadUserResume);
router.delete('/delete/:user_id', deleteResume);

module.exports = router;
