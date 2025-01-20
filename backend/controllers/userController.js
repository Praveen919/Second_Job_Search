const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');
const geoip = require('geoip-lite');
const rateLimit = require('express-rate-limit');
const { isEmail } = require('validator');
const archivedUser = require('../models/archivedUserModel');  // Replace with correct path to archived model
const Login = require('../models/loginModel');  // Replace with correct path to your login model
const { parseUserAgent } = require('../utils/parseUserAgent'); 

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

// Middleware to limit OTP requests
const otpResendLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // limit each IP to 5 requests per windowMs
  message: 'Too many OTP requests from this IP, please try again after 15 minutes',
});

// Nodemailer transporter setup for sending OTP email
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// Utility function to send OTP email
const sendOTPLog = async (email, otp) => {
  const mailOptions = {
    from: process.env.EMAIL_ADDRESS,
    to: email,
    subject: 'OTP for Login',
    text: `Your OTP for Login is: ${otp}`,
  };

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error('Error sending email:', error);
        reject(error);
      } else {
        console.log('Email sent:', info.response);
        resolve();
      }
    });
  });
};

// Utility function to generate a numeric OTP
const generateNumericOTP = (length) => {
  const digits = '0123456789';
  let otp = '';
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * digits.length);
    otp += digits[randomIndex];
  }
  return otp;
};

// Controller function to request OTP
const requestLoginOTP = async (req, res) => {
  const { email, password } = req.body;

  try {
    let user;

    // First, try finding the user by email
    if (isEmail(email)) {
      user = await User.findOne({ email, active: true });
    } 
    // If it's not an email, check if it's a mobile number (mobile1 or mobile2)
    else if (email && email.length >= 7 && !isNaN(email)) {
      user = await User.findOne({ $or: [{ mobile1: email }, { mobile2: email }], active: true });
    } 
    // Otherwise, treat it as a username
    else {
      user = await User.findOne({ username: email, active: true });
    }

    // If the user is not found, check in the archived users
    if (!user) {
      if (isEmail(email)) {
        user = await archivedUser.findOne({ email, active: true });
      } else if (email && email.length >= 7 && !isNaN(email)) {
        user = await archivedUser.findOne({ $or: [{ mobile1: email }, { mobile2: email }], active: true });
      } else {
        user = await archivedUser.findOne({ username: email, active: true });
      }

      if (user) {
        const restoredUser = new User(user.toObject());
        await restoredUser.save();
        await archivedUser.deleteOne({ _id: user._id });

        user = restoredUser;
      }
    }

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if password is correct
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      console.log("Invalid password");
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate OTP
    const otp = generateNumericOTP(6);
    const salt = await bcrypt.genSalt(10);
    const hashedOtp = await bcrypt.hash(otp, salt);

    user.otp = hashedOtp;
    user.otpExpiration = Date.now() + 3600000; // OTP valid for 1 hour
    await user.save();

    // Send OTP via email
    await sendOTPLog(user.email, otp);

    res.status(200).json({ message: 'OTP sent successfully' });
  } catch (error) {
    console.error("OTP request error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Controller function to login with OTP
const loginWithOTP = async (req, res) => {
  const { email, otp } = req.body;

  try {
    let user;

    // Check if input is an email or a username or mobile number
    if (isEmail(email)) {
      user = await User.findOne({ email });
    } else if (email && email.length >= 7 && !isNaN(email)) {
      user = await User.findOne({ $or: [{ mobile1: email }, { mobile2: email }], active: true });
    } else {
      user = await User.findOne({ username: email });
    }

    // Check if the user is not found
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Check if OTP has expired
    if (user.otpExpiration < Date.now()) {
      return res.status(400).json({ message: 'OTP has expired' });
    }

    // Compare OTP
    const isMatch = await bcrypt.compare(otp, user.otp);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid OTP' });
    }

    // Capture user agent (browser) and IP address
    const userAgent = req.headers['user-agent'];
    const ipAddress = req.headers['x-forwarded-for'] || req.connection.remoteAddress;

    // Get geolocation from IP address
    const geo = geoip.lookup(ipAddress);
    const location = geo ? `${geo.city}, ${geo.region}, ${geo.country}` : 'Unknown';

    // Parse user agent to get browser and operating system
    const { browser, os } = parseUserAgent(userAgent);

    // Clear OTP and expiration
    user.otp = undefined;
    user.otpExpiration = undefined;
    await user.save();

    // Generate JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: '1h', // Token expiration time
    });
    console.log(`User logged in: ${user.username}`);

    // Format date in a readable timestamp format
    const formattedDate = new Date().toLocaleString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric',
      timeZoneName: 'short'
    });

    // Check if there is an existing login record for the user
    let login = await Login.findOne({ userId: user._id });

    if (login) {
      // Add a new loginfo entry to the existing login record
      login.loginfo.push({
        location,
        date: formattedDate,
        browser,
        operatingSystem: os
      });
      await login.save();
    } else {
      // Create a new login record with the first loginfo entry
      login = new Login({
        userId: user._id,
        loginfo: [{
          location,
          date: formattedDate,
          browser,
          operatingSystem: os
        }]
      });
      await login.save();
    }

    // Send token in response
    res.json({ token });
  } catch (error) {
    console.error('OTP verification error:', error);
    res.status(500).json({ message: 'Server error' });
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

module.exports = { registerUser, loginUser, getAllUsers, requestLoginOTP, loginWithOTP };
