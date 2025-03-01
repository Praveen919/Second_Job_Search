require('dotenv').config();
const Interview = require('../models/interviewModel');
const Job = require('../models/jobModel');
const FreeJob = require('../models/freeJobModel');
const User = require('../models/userModel'); // Import the User model
const nodemailer = require('nodemailer');

// Nodemailer setup
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// Function to send emails
const sendEmail = async (to, subject, text) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to,
    subject,
    text,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Email sent to ${to}`);
  } catch (error) {
    console.error(`Failed to send email to ${to}:`, error);
  }
};

// Create an interview
const createInterview = async (req, res) => {
  try {
    const { postId, userId, employeeId, meetDetails, interviewTimestamp } = req.body;

    // Find job title
    let job = await Job.findById(postId) || await FreeJob.findById(postId);
    if (!job) return res.status(404).json({ message: 'Job not found' });

    // Find user and employee
    const user = await User.findById(userId);
    const employee = await User.findById(employeeId);

    if (!user || !employee) {
      return res.status(404).json({ message: 'User or Employee not found' });
    }

    const interview = new Interview({ postId, userId, employeeId, meetDetails, interviewTimestamp });
    await interview.save();

    // Format interview date and time
    const formattedTime = new Date(interviewTimestamp).toLocaleString();

    // Email text
    const emailText = `
      An interview has been scheduled for the job title: ${job.jobTitle}
      Meet Details: ${meetDetails}
      Interview Timing: ${formattedTime}
    `;

    await sendEmail(user.email, 'Interview Scheduled', emailText);
    await sendEmail(employee.email, 'Interview Scheduled', emailText);

    res.status(201).json({ message: 'Interview created successfully', interview });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update an interview
const updateInterview = async (req, res) => {
  try {
    const { interviewId } = req.params;
    const { meetDetails, interviewTimestamp } = req.body;

    const interview = await Interview.findByIdAndUpdate(
      interviewId,
      { meetDetails, interviewTimestamp },
      { new: true }
    );

    if (!interview) return res.status(404).json({ message: 'Interview not found' });

    // Find user and employee
    const user = await User.findById(interview.userId);
    const employee = await User.findById(interview.employeeId);

    if (user && employee) {
      const formattedTime = new Date(interview.interviewTimestamp).toLocaleString();
      const emailText = `
        The interview details have been updated.
        New Meet Details: ${meetDetails}
        New Interview Timing: ${formattedTime}
      `;

      await sendEmail(user.email, 'Interview Updated', emailText);
      await sendEmail(employee.email, 'Interview Updated', emailText);
    }

    res.json({ message: 'Interview updated successfully', interview });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete an interview
const deleteInterview = async (req, res) => {
  try {
    const { interviewId } = req.params;

    const interview = await Interview.findByIdAndDelete(interviewId);
    if (!interview) return res.status(404).json({ message: 'Interview not found' });

    // Find user and employee
    const user = await User.findById(interview.userId);
    const employee = await User.findById(interview.employeeId);

    if (user && employee) {
      const emailText = `
        The interview scheduled for the job has been cancelled.
        Previous Interview Timing: ${new Date(interview.interviewTimestamp).toLocaleString()}
      `;

      await sendEmail(user.email, 'Interview Cancelled', emailText);
      await sendEmail(employee.email, 'Interview Cancelled', emailText);
    }

    res.json({ message: 'Interview deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get interview by ID
const getInterviewById = async (req, res) => {
    try {
      const { interviewId } = req.params;
      const interview = await Interview.findById(interviewId);
      if (!interview) return res.status(404).json({ message: 'Interview not found' });
      res.json(interview);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
};
  
  // Get interviews by userId
const getInterviewsByUserId = async (req, res) => {
    try {
      const { userId } = req.params;
      const interviews = await Interview.find({ userId });
      res.json(interviews);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
};
  
  // Get interviews by employeeId
const getInterviewsByEmployeeId = async (req, res) => {
    try {
        const { employeeId } = req.params;
        const interviews = await Interview.find({ employeeId });
        res.json(interviews);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    createInterview,
    updateInterview,
    deleteInterview,
    getInterviewById,
    getInterviewsByUserId,
    getInterviewsByEmployeeId,
};