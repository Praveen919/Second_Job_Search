const Job = require('../models/jobModel');
const FreeJob = require('../models/freeJobModel')

const getAllJobs = async (req, res) => {
  try {
    const jobs = await Job.find(); // Retrieve all users

    res.status(200).json(jobs);
  } catch (error) {
    console.error('Error fetching jobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const getJobById = async (req,res) => {
  const { id } = req.params;

  try {
    // Attempt to find the job in the regular jobs collection
    let job = await Job.findById(id);
    
    // If not found, attempt to find in the free jobs collection
    if (!job) {
      job = await FreeJob.findById(id);
    }

    if (job) {// Exclude password from response
      res.status(200).json(job);
    } else {
      res.status(404).json({ message: "No such job exists" });
    }
  } catch (error) {
    console.error('Error fetching job:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllJobs, getJobById };
