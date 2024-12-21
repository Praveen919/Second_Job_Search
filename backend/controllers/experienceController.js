const Experience = require('../models/experienceModel');

const getAllExperiences = async (req, res) => {
  try {
    const experiences = await Experience.find(); // Retrieve all users

    res.status(200).json(experiences);
  } catch (error) {
    console.error('Error fetching experiences:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllExperiences };
