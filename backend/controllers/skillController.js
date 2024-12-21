const Skill = require('../models/skillModel');

const getAllSkills = async (req, res) => {
  try {
    const skills = await Skill.find(); // Retrieve all users

    res.status(200).json(skills);
  } catch (error) {
    console.error('Error fetching skills:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllSkills };
