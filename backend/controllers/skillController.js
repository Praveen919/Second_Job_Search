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

const getSkillByUserId = async (req, res) => {
  try {
    const { id } = req.params;
    const skills = await Skill.find({ userId: id });
    res.json(skills);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const postSkill = async (req, res) => {
  try {
    const { skillName, knowledgeLevel, experienceWeeks, userId } = req.body;

    // Validate required fields
    if (!skillName || !knowledgeLevel || !experienceWeeks || !userId) {
      return res.status(400).json({ message: 'All fields are required.' });
    }

    // Validate knowledgeLevel against enum
    const validKnowledgeLevels = ['basic', 'intermediate', 'advanced'];
    if (!validKnowledgeLevels.includes(knowledgeLevel.toLowerCase())) {
      return res.status(400).json({ message: 'Invalid knowledge level.' });
    }

    // Insert into database
    const newSkill = new Skill({
      skillName,
      knowledgeLevel: knowledgeLevel.toLowerCase(), // Ensure consistent case
      experienceWeeks,
      userId
    });

    const savedSkill = await newSkill.save();
    res.status(201).json(savedSkill);
  } catch (error) {
    console.error('Server error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

const editSkill = async (req, res) => {
  const { id } = req.params; // Get the skill ID from the request parameters
  const { skillName, knowledgeLevel, experienceWeeks } = req.body;

  if (!skillName || !knowledgeLevel || !experienceWeeks) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Find and update the skill
    const updatedSkill = await Skill.findByIdAndUpdate(
      id, // Use the ID from request params
      { skillName, knowledgeLevel, experienceWeeks },
      { new: true } // Return the updated document
    );

    if (!updatedSkill) {
      return res.status(404).json({ message: 'Skill not found' });
    }

    res.json(updatedSkill);
  } catch (error) {
    console.error('Error updating skill:', error);
    res.status(500).json({ message: 'Error updating skill' });
  }
};

const deletedSkill = async (req, res) => {
  const { id } = req.params; // Extract id from req.params

  try {
    const deletedSkill = await Skill.findByIdAndDelete(id);

    if (deletedSkill) {
      res.status(200).json({ message: "Skill deleted successfully" });
    } else {
      res.status(404).json({ message: "Skill not found" });
    }
  } catch (error) {
    console.error('Error deleting skill:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllSkills, getSkillByUserId, postSkill, editSkill, deletedSkill };