const Education = require('../models/educationModel');

const getAllEducations = async (req, res) => {
  try {
    const educations = await Education.find(); // Retrieve all users

    res.status(200).json(educations);
  } catch (error) {
    console.error('Error fetching educations:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllEducations };
