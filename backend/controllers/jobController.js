const Job = require('../models/jobModel');

const getAllJobs = async (req, res) => {
  try {
    const jobs = await Job.find(); // Retrieve all users

    res.status(200).json(jobs);
  } catch (error) {
    console.error('Error fetching jobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllJobs };
