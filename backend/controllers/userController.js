const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const multer = require('multer');
const path = require('path');

// Generate JWT token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '1h' });
};

// Register user
const registerUser = async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const user = await User.create({ name, email, password });
    if (user) {
      res.status(201).json({
        id: user._id,
        name: user.name,
        email: user.email,
        token: generateToken(user._id),
      });
    } else {
      res.status(400).json({ message: 'Invalid user data' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Login user
const loginUser = async (req, res) => {
  const { email, password } = req.body;
  console.log('Entered password:', password);

  try {
    const user = await User.findOne({ email });
    if (user) {
      const match = await user.matchPassword(password);
      console.log('Password match:', match); // Log the result of password comparison
      if (match) {
        res.status(200).json({
          id: user._id,
          name: user.name,
          email: user.email,
          token: generateToken(user._id),
        });
      } else {
        res.status(401).json({ message: 'Invalid email or password' });
      }
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getAllUsers = async (req, res) => {
  try {
    const users = await User.find(); // Retrieve all users

    // Exclude passwords from all users
    const usersWithoutPasswords = users.map(user => {
      const { password, ...otherDetails } = user._doc;
      return otherDetails;
    });

    res.status(200).json(usersWithoutPasswords);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const getUserById = async (req, res) => {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid user ID' });
  }

  try {
    const user = await User.findById(id); // Find user by ObjectId

    if (user) {
      const { password, ...otherDetails } = user._doc; // Exclude password from response
      res.status(200).json(otherDetails);
    } else {
      res.status(404).json({ message: "No such user exists" });
    }
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const ChangePassword = async (req, res) => {
  const { userId, oldPassword, newPassword, confirmPassword } = req.body;

  // Validate input
  if (!userId || !oldPassword || !newPassword || !confirmPassword) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  if (newPassword !== confirmPassword) {
    return res.status(400).json({ message: 'New password and confirmation do not match' });
  }

  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Check if the old password is correct
    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Old password is incorrect' });
    }

    // Set the new password directly (NOT recommended for security)
    user.password = newPassword; // Update with the new password directly

    await user.save(); // Save the user document

    res.status(200).json({ message: 'Password changed successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

const setDnd = async (req, res) => {
  console.log('Received request:', req.body);
  const { userId, dndDuration } = req.body;

  try {
    const user = await User.findById(userId);
    
    // Check if the user exists
    if (!user) {
      return res.status(400).json({ error: 'User not found' });
    }

    // Check if the user is a candidate
    if (user.role !== 'candidate') {
      return res.status(400).json({ error: 'User is not a candidate' });
    }

    
    // Calculate the DND end date based on the dndDuration value
    let endDate;
    if (dndDuration === '1_week') {
      endDate = new Date();
      endDate.setDate(endDate.getDate() + 7);
    } else if (dndDuration === '2_weeks') {
      endDate = new Date();
      endDate.setDate(endDate.getDate() + 14);
    } else if (dndDuration.endsWith('_days')) {
      const days = parseInt(dndDuration.split('_')[0]);
      endDate = new Date();
      endDate.setDate(endDate.getDate() + days);
    }

     // Set or initialize DND fields
     user.dnd = user.dnd || {}; // Initialize if not present
     user.dnd.isActive = true;
     user.dnd.startDate = new Date();
     user.dnd.endDate = endDate;
 

    // Save the updated user
    await user.save();

     // Schedule to set isActive to false after endDate
     const timeUntilEnd = endDate.getTime() - new Date().getTime();
     if (timeUntilEnd > 0) {
       setTimeout(async () => {
         user.dnd.isActive = false;
         await user.save();
         console.log(`User ${userId} is now inactive.`);
       }, timeUntilEnd);
     }

    res.status(200).json({ message: 'DND settings updated successfully', dnd: user.dnd });
  } catch (error) {
    console.error('Error updating DND settings:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

const deleteDnd = async (req, res) => {
  const { userId } = req.body;

  try {
      // Find the user by ID and update their DND settings
      const updatedUser = await User.findByIdAndUpdate(
          userId,
          {
              'dnd.isActive': false,
              'dnd.startDate': null,
              'dnd.endDate': null,
          },
          { new: true } // Return the updated document
      );

      if (!updatedUser) {
          return res.status(404).json({ error: 'User not found' });
      }

      res.status(200).json({ message: 'DND settings deleted successfully', user: updatedUser });
  } catch (error) {
      console.error('Error deleting DND settings:', error);
      res.status(500).json({ error: 'Internal server error' });
  }
};

const userImageStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../public/users/images')); // Adjust path as needed
  },
  filename: (req, file, cb) => {
    const extension = path.extname(file.originalname);
    const filename = `${Date.now()}${extension}`; // Unique filename based on timestamp
    cb(null, filename);
  }
});

// Define multer upload settings
const uploadUserImage = multer({
  storage: userImageStorage, // Correct variable name here
  fileFilter: (req, file, cb) => {
    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowedMimeTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Only JPEG, PNG, and GIF files are allowed.'), false);
    }
  },
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB file size limit
});

const updateUser = async (req, res) => {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ error: 'Invalid user ID' });
  }

  try {
    const updateData = { ...req.body };

    if (req.file) {
      updateData.image = `/users/images/${req.file.filename}`;
    }

    const updatedUser = await User.findByIdAndUpdate(id, updateData, { new: true });

    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json(updatedUser);
  } catch (error) {
    console.error('Error updating user:', error);
    return res.status(500).json({ error: 'Server error' });
  }
};

// Setup multer storage for resumes
const resumeStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, publicResumeDir); // Save files to the public/resume directory
  },
  filename: (req, file, cb) => {
    const extension = path.extname(file.originalname);
    cb(null, `resume_${Date.now()}${extension}`); // Ensure unique filenames
  }
});

// Multer setup for resumes
const uploadResume = multer({
  storage: resumeStorage,
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB file size limit
});

const uploadUserResume = async (req, res) => {
  const { user_id } = req.params;
  const { resumeType } = req.body;
  const file = req.file;

  console.log('User ID:', user_id);
  console.log('Uploaded file:', file);
  console.log('Resume Type:', resumeType);

  if (!user_id) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  if (!file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  if (!resumeType) {
    return res.status(400).json({ error: 'Resume type is required' });
  }

  try {
    const user = await User.findById(user_id);
    if (!user) {
      fs.unlink(path.join(publicResumeDir, file.filename), (err) => {
        if (err) console.error('Error deleting file:', err);
      });
      return res.status(404).json({ error: 'User not found' });
    }

    user.resume = `/resume/${file.filename}`;
    user.resumeType = resumeType;
    console.log('Resume path to save:', user.resume);
    console.log('Resume type to save:', user.resumeType);
    await user.save();
    console.log('User updated successfully');

    res.status(200).json({ user_id, resume: user.resume ,resumeType: user.resumeType});

  } catch (error) {
    console.error('Error uploading resume:', error);

    if (file) {
      fs.unlink(path.join(publicResumeDir, file.filename), (err) => {
        if (err) console.error('Error deleting file:', err);
      });
    }

    res.status(500).json({ error: 'An error occurred while uploading the resume' });
  }
};

const deleteResume = async (req, res) => {
  const { user_id } = req.params;

  if (!user_id) {
    return res.status(400).json({ error: 'User ID is required' });
  }

  try {
    // Find the user by user_id
    const user = await User.findById(user_id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Check if there is a resume to delete
    if (user.resume) {
      // Extract the file name from the resume path
      const fileName = path.basename(user.resume); // Extracts "resume_123456" from "/resume/resume_123456"
      const filePath = path.join(publicResumeDir, fileName); // Constructs the absolute path to the file

      console.log('File path for deletion:', filePath);

      // Delete the file from the server
      fs.unlink(filePath, (err) => {
        if (err) {
          console.error('Error deleting file:', err);
          return res.status(500).json({ error: 'An error occurred while deleting the resume file' });
        }
        console.log('File deleted successfully');
      });

      // Clear the resume field in the user's document
      user.resume = '';
      await user.save();
      console.log('User resume cleared successfully');

      res.status(200).json({ user_id, resume: user.resume });
    } else {
      res.status(404).json({ error: 'No resume found for this user' });
    }
  } catch (error) {
    console.error('Error deleting resume:', error);
    res.status(500).json({ error: 'An error occurred while deleting the resume' });
  }
};

module.exports = { registerUser, loginUser, getAllUsers, getUserById, ChangePassword, setDnd,
                    deleteDnd, uploadUserImage, updateUser, resumeStorage, uploadResume, 
                    uploadUserResume, deleteResume };