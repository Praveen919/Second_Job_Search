const FreeJob = require('../models/freeJobModel');

const getAllFreeJobs = async (req, res) => {
  try {
    const freeJobs = await FreeJob.find(); // Retrieve all users

    res.status(200).json(freeJobs);
  } catch (error) {
    console.error('Error fetching freeJobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllFreeJobs };
