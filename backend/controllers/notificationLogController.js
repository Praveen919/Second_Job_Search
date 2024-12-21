const NotficationLog = require('../models/notficationLogModel');

const getAllNotficationLogs = async (req, res) => {
  try {
    const notficationLogs = await NotficationLog.find(); // Retrieve all users

    res.status(200).json(notficationLogs);
  } catch (error) {
    console.error('Error fetching notficationLogs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllNotficationLogs };
