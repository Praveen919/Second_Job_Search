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

const getExperienceByUserId = async (req, res) => {
  const { id } = req.params;

  try {
    // Fetch the experience record by ID and ensure the user owns it
    const experience = await Experience.findOne({ user_id: id });

    if (experience) {
      res.status(200).json(experience);
    } else {
      res.status(404).json({ message: "No such experience record exists" });
    }
  } catch (error) {
    console.error('Error fetching experience record:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const postExperience = async (req, res) => {
  const { title, company, year, description } = req.body;
  try {
    // Input validation could be added here
    const newExperience = new Experience({
      title,
      company,
      year,
      description,
      user_id: req.user._id, // Add the user_id
    });
    const savedExperience = await newExperience.save();
    res.status(201).json(savedExperience);
  } catch (error) {
    console.error('Error creating experience:', error);
    res.status(500).json({ error: error.message });
  }
};

const editExperience = async (req, res) => {
  const { title, company, year, description } = req.body;
  try {
    const updatedExperience = await Experience.findOneAndUpdate(
      { _id: req.params.id, user_id: req.user._id }, // Check user_id
      { title, company, year, description },
      { new: true }
    );
    if (!updatedExperience) {
      return res.status(404).json({ error: 'Experience not found or not authorized' });
    }
    res.json(updatedExperience);
  } catch (error) {
    console.error('Error updating experience:', error);
    res.status(500).json({ error: error.message });
  }
};

const deletedExperience = async (req, res) => {
  try {
    const deletedExperience = await Experience.findOneAndDelete({
      _id: req.params.id,
      user_id: req.user._id, // Check user_id
    });
    if (!deletedExperience) {
      return res.status(404).json({ error: 'Experience not found or not authorized' });
    }
    res.json({ message: 'Experience deleted successfully' });
  } catch (error) {
    console.error('Error deleting experience:', error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getAllExperiences, getExperienceByUserId, postExperience, editExperience, deletedExperience };
