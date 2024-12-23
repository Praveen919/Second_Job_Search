const NotficationLog = require('../models/notficationLogModel');
const User = require('../models/userModel');
const Message = require('../models/messageModel');
const Job = require('../models/jobModel');
const FreeJob = require('../models/freeJobModel');
const mongoose = require('mongoose');

const getAllNotficationLogs = async (req, res) => {
  try {
    const notficationLogs = await NotficationLog.find(); // Retrieve all users

    res.status(200).json(notficationLogs);
  } catch (error) {
    console.error('Error fetching notficationLogs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const updateReadSeen =  async (req, res) => {
  const { id } = req.params;
  const { email } = req.body; // Get the email from the request body

  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }

  try {
    const notification = await NotificationLog.findOne({ jobId: id })
    if (!notification) {
      return res.status(404).json({ message: 'Notification log not found' });
    }

    // Find the email in the emailStatus array and update its read property
    const emailStatus = notification.emailStatus.find(item => item.email === email);
    if (!emailStatus) {
      return res.status(404).json({ message: 'Email not found in notification log' });
    }

    emailStatus.read = true;

    // Save the updated document
    await notification.save();

    res.status(200).json({ message: 'Email status updated successfully', notification });
  } catch (error) {
    console.error('Error updating email status:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const candidateNotification = async (req, res) => {
  const { id } = req.params;

  // Validate that the ID is a valid ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid receiver ID format' });
  }

  try {
    // 1. Retrieve user data to get the email
    const userresponse = await User.findById(id);
    if (!userresponse) {
      return res.status(404).json({ message: 'User not found' });
    }

    const email = userresponse.email;  // Extract email from user data

    // 2. Retrieve notification logs where the email matches and emailStatus contains read: false
    const notificationLogs = await NotficationLog.find({
      "emailStatus.email": email,  // Find the notifications for this user email
      "emailStatus.read": false  // Only include logs where emailStatus.read is false
    });

    const jobIds = notificationLogs.map(log => log.jobId);
    const jobs = [];

    // Retrieve jobs from both the Job and FreeJob models
    for (const jobId of jobIds) {
      let job = await Job.findById(jobId);
      if (!job) {
        job = await FreeJob.findById(jobId);
      }
      if (job) {
        jobs.push(job);
      }
    }

    // 3. Retrieve messages where senderId or receiverId matches the user ID and are unread
    const messages = await Message.find({
      receiverId: id,
      read: false
    })
      .sort({ createdAt: -1 })  // Sort by the most recent message
      .limit(1);  // Limit to the most recent unread message


    // If there are unread messages, fetch sender data (sender's name)
    if (messages.length > 0) {
      const senderId = messages[0].senderId;

      const senderData = await User.findById(senderId);  // Find sender user data

      // Check if sender data exists and update message
      if (senderData) {
        messages[0].senderName = senderData.username;  // Assuming sender's username is stored in the 'username' field
      } 
    }

    // Store all the data in a JSON object
    const notificationData = {
      jobs,
      messages: messages.map(message => ({
        ...message.toObject(),  // Convert the message to a plain object to include senderName
        senderName: message.senderName || null  // Add senderName to the response if it exists
      })),
    };

    // Send response with aggregated data
    res.status(200).json({
      message: 'Data fetched successfully.',
      data: notificationData,
    });

  } catch (error) {
    console.error('Error retrieving candidate notification data:', error);
    res.status(500).json({ message: 'Server error while fetching notifications' });
  }
};

const employerNotification = async (req, res) => {
  const { id } = req.params;

  // Validate that the ID is a valid ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid employer ID format' });
  }

  try {
    // Retrieve jobs posted by the employer (user ID)
    const jobs = [
      ...(await Job.find({ user_id: id })),
      ...(await FreeJob.find({ user_id: id }))
    ];

    const jobIds = jobs.map(job => job._id); // Get list of job IDs

    // Retrieve applied jobs for these job IDs where seen === false
    const appliedJobs = await AppliedJob.find({
      post_id: { $in: jobIds },
      seen: false
    });

    const notifications = [];
    for (const appliedJob of appliedJobs) {
      const { user_id: appliedUserId, post_id, _id: appliedJobId } = appliedJob;

      // Get user details based on appliedUserId
      const user = await User.findById(appliedUserId);
      if (!user) continue;

      // Retrieve job details using post_id
      let job = await Job.findById(post_id);
      if (!job) {
        job = await FreeJob.findById(post_id);
      }
      if (!job) continue;

      // Use job.title to populate the jobTitle field
      const jobTitle = job.jobTitle || "Job title not available";

      // Push notification details, including appliedJobId and appliedUserId
      notifications.push({
        appliedJobId, // Add AppliedJob ID
        appliedUserId, // Add AppliedJob's user ID
        userName: user.name,
        userEmail: user.email,
        jobTitle, // Add the job title from the job document
        postId: post_id,
      });
    }
    // Retrieve messages where senderId or receiverId matches the employer ID
    const messages = await Message.find({
      receiverId: id,
      read: false
    })
      .sort({ createdAt: -1 })
      .limit(1);

    // Store all the data in a JSON object
    const notificationData = {
      jobs,
      notifications,
      messages,
    };

    // Send response with aggregated data
    res.status(200).json({
      message: 'Employer notifications fetched successfully.',
      data: notificationData,
    });
  } catch (error) {
    console.error('Error retrieving employer notification data:', error);
    res.status(500).json({ message: 'Server error while fetching notifications' });
  }
};

module.exports = { getAllNotficationLogs, updateReadSeen, candidateNotification, employerNotification };
