const AppliedJob = require('../models/appliedJobModel');

const getAllAppliedJobs = async (req, res) => {
  try {
    const appliedJob = await AppliedJob.find(); // Retrieve all users

    res.status(200).json(appliedJob);
  } catch (error) {
    console.error('Error fetching appliedJobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllAppliedJobs };
