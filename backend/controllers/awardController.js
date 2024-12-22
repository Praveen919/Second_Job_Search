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

const postAward = async (req, res) => {
  const { title, organization, year, description } = req.body;
  try {
    const newAward = new Award({
      title,
      organization,
      year,
      description,
      user_id: req.user._id, 
    });
    const savedAward = await newAward.save();
    res.status(201).json(savedAward);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

const getAwardByUserId = async (req, res) => {
  const { id } = req.params;

  try {
    // Fetch the award record by ID and ensure the user owns it
    const award = await Award.findOne({ user_id: id });

    if (award) {
      res.status(200).json(award);
    } else {
      res.status(404).json({ message: "No such award record exists" });
    }
  } catch (error) {
    console.error('Error fetching award record:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const getAwardById = async (req, res) => {
  try {
    const { id } = req.params;
    const awards = await Award.findById(id);
    res.status(200).json(awards);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const editAwardById = async (req, res) => {
  try {
    const updatedAward = await Award.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedAward) return res.status(404).json({ message: 'Award not found' });
    res.status(200).json(updatedAward);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

const deleteAwardById = async (req, res) => {
  try {
    const deletedAward = await Award.findByIdAndDelete(req.params.id);
    if (!deletedAward) return res.status(404).json({ message: 'Award not found' });
    res.status(200).json({ message: 'Award deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { getAllAwards, getAwardById, getAwardByUserId, postAward, editAwardById, deleteAwardById };
