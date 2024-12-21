const Plan = require('../models/planModel');

const getAllPlans = async (req, res) => {
  try {
    const plans = await Plan.find(); // Retrieve all users

    res.status(200).json(plans);
  } catch (error) {
    console.error('Error fetching plans:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllPlans };
