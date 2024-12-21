const Award = require('../models/awardModel');

const getAllAwards = async (req, res) => {
  try {
    const awards = await Award.find(); // Retrieve all users

    res.status(200).json(awards);
  } catch (error) {
    console.error('Error fetching awards:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllAwards };
