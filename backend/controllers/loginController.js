const Login = require('../models/loginModel');

const getAllLogins = async (req, res) => {
  try {
    const logins = await Login.find(); // Retrieve all users

    res.status(200).json(logins);
  } catch (error) {
    console.error('Error fetching logins:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllLogins };
