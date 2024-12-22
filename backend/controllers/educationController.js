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

const getEducationByUserId = async (req, res) => {
  const { id } = req.params;

  try {
    // Fetch the education record by ID and ensure the user owns it
    const education = await Education.findOne({ user_id: id });

    if (education) {
      res.status(200).json(education);
    } else {
      res.status(404).json({ message: "No such education record exists" });
    }
  } catch (error) {
    console.error('Error fetching education record:', error);
    res.status(500).json({ message: "Server error" });
  }
};


const postEducation = async (req, res) => {
  const { course, institution, startDate, endDate, user_id } = req.body;
  try {
    
    // Create a new education document with user_id
    const education = new Education({ course, institution, startDate, endDate, user_id: req.user._id });
    await education.save();
    res.status(201).json(education);
  } catch (error) {
    console.error('Error saving education:', error);
    res.status(400).json({ message: 'Failed to add education. Please try again.' });
  }
};

const editEducation = async (req, res) => {
 
  const { course, institution, startDate, endDate} = req.body;
  try {
    // Find and update the education document
    const updatedEducation = await Education.findOneAndUpdate(
      { _id: req.params.id, user_id: req.user._id }, // Check user_id
      { course, institution, startDate, endDate }, // Update with user_id if needed
      { new: true }
    );
    if (!updatedEducation) {
      return res.status(404).json({ message: 'Education not found or not authorized' });
    }
    res.json(updatedEducation);
  } catch (error) {
    console.error('Error updating experience:', error);
    res.status(400).json({ message: error.message });
  }
};


const deletedEducation = async (req, res) => {
  try {
    const deletedEducation = await Education.findOneAndDelete({
      _id: req.params.id,
      user_id: req.user._id, // Check user_id
    });
    if (!deletedEducation) {
      return res.status(404).json({ message: 'Education not found or not authorized' });
    }
    res.json({ message: 'Education deleted successfully' });
  } catch (error) {
    console.error('Error deleting experience:', error);
    res.status(400).json({ message: error.message });
  }
};

module.exports = { getAllEducations, getEducationByUserId, postEducation, editEducation, deletedEducation };
