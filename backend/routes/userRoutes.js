const express = require('express');
const { 
  registerUser, 
  loginUser, 
  getAllUsers, 
  getUser,
  requestLoginOTP, 
  loginWithOTP,
  uploadResume,
  deleteResume,
  updateUserImage,
  changePassword,
  updateUserData,
  updateCompanyData,
  updateNotificationSettings,
  saveJob,
  getUserByEmail,
  getSavedJobsCount,
  removeSavedJob,
  getUserDetails,
  editUserProfile
} = require('../controllers/userController'); // Importing all necessary controllers

const router = express.Router();

// Routes for user operations
router.post('/register', registerUser);              // Register a new user
router.post('/login', loginUser);                    // Login with email and password
router.post('/request-login', requestLoginOTP);      // Request OTP for login
router.post('/login-otp', loginWithOTP);             // Login with OTP
router.get('', getAllUsers);                         // Get all users (no authentication needed)
router.get('/:id', getUser);                        // Get single user
router.post('/upload-resume/:user_id', uploadResume);        // Upload resume
router.delete('/delete-resume/:user_id', deleteResume);      // Delete resume
router.put('/update-image/:id', updateUserImage);           // Update user image
router.put('/change-password/:id', changePassword);         // Change user password
router.put('/update-data/:id', updateUserData);             // Update user data
router.put('/update-companyData/:id', updateCompanyData);    //Update Company data
router.put('/update-notifications', updateNotificationSettings); // Update notification settings
router.put('/save-jobs', saveJob);
router.get('/email/:email', getUserByEmail);
router.get('/save-jobs/:userId', getSavedJobsCount);
router.put('/remove-save-job', removeSavedJob);
router.get('/details/:id', getUserDetails);
router.put('/edit/:user_id', editUserProfile);

module.exports = router;  