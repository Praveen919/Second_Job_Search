const Job = require('../models/jobModel');
const FreeJob = require('../models/freeJobModel')
const nodemailer = require('nodemailer');
const Plan = require('../models/planModel');
const User = require('../models/userModel');
const NotficationLog = require('../models/notficationLogModel');
const env = require('dotenv');

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

const getJobByUserId = async (req, res) => {
  const { user_id } = req.params;

  try {
    let job = await Job.find({ user_id }); // Try finding a job in the 'Job' collection

    // If no job found in 'Job' collection, check in 'FreeJob' collection
    if (!job || job.length === 0) {
      job = await FreeJob.find({ user_id });
    }

    // If a job is found, return it, otherwise return 404
    if (job && job.length > 0) {
      res.status(200).json(job);
    } else {
      res.status(404).json({ message: "No job found for this user" });
    }
  } catch (error) {
    console.error('Error fetching job:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const deleteJob = async (req, res) => {
  const { id } = req.params;

  try {
    // Try to find and delete the job from the 'Job' collection
    let deletedJob = await Job.findByIdAndDelete(id);

    if (!deletedJob) {
      // If not found in 'Job', try to delete it from 'FreeJob'
      deletedJob = await FreeJob.findByIdAndDelete(id);

      if (!deletedJob) {
        // If job not found in both collections
        return res.status(404).json({ message: 'Job not found in both Job and FreeJob collections' });
      }
    }

    // If job is found and deleted, return a success response
    res.status(200).json({ message: 'Job deleted successfully', job: deletedJob });
  } catch (error) {
    console.error('Error deleting job:', error.message);
    res.status(500).json({ message: 'Server error' });
  }
};

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: env.EMAIL_USER,
    pass: env.EMAIL_PASS,
  },
});

const postJob = async (req, res) => {
  const jobData = req.body;

  const requiredFields = [
    'jobTitle', 'jobCategory', 'jobDescription', 'email', 'username', 'specialisms',
    'jobType', 'keyResponsibilities', 'skillsAndExperience', 'offeredSalary', 'careerLevel', 
    'experienceYears', 'experienceMonths', 'gender', 'industry', 'qualification', 
    'applicationDeadlineDate', 'country', 'city', 'completeAddress', 'user_id', 
    'plan_id', 'employmentStatus', 'vacancies', 'companyName'
  ];

  for (const field of requiredFields) {
    if (!jobData[field]) {
      return res.status(400).json({ error: `Field ${field} is required` });
    }
  }

  try {
    const plan = await Plan.findById(jobData.plan_id);
    if (!plan) {
      return res.status(400).json({ error: 'Invalid plan_id' });
    }

    if (plan.paid_jobs <= 0) {
      return res.status(400).json({ error: 'No paid jobs available in the selected plan' });
    }

    const job = new Job({
      ...jobData,
      specialisms: jobData.specialisms,
      keyResponsibilities: jobData.keyResponsibilities,
      skillsAndExperience: jobData.skillsAndExperience,
    });

    await job.save();
    plan.paid_jobs -= 1;
    await plan.save();

    const candidates = await User.find({ role: 'candidate', 'dnd.isActive': false });
    if (!candidates || candidates.length === 0) {
      return res.status(400).json({ error: 'No candidates found' });
    }

    const logoPath = path.join(__dirname, '../public/images/logo.png');
    const emailStatusList = [];
    const candidateEmails = [];

    await Promise.all(candidates.map(async (candidate) => {
      const htmlMessage = `
        <div style="font-family: Arial, sans-serif; color: #333;">
          <div style="text-align: center; padding: 10px;">
            <img src="cid:logo" alt="Company Logo" style="width: 150px; height: auto;" />
          </div>
          <h2>Hello ${candidate.username},</h2>
          <p>We are excited to inform you about a new job opportunity:</p>
          <h3>Job Details:</h3>
          <p><strong>Job Title:</strong> ${jobData.jobTitle || 'Not provided'}</p>
          <p><strong>Company:</strong> ${jobData.companyName || 'Not provided'}</p>
          <p><strong>Description:</strong> ${jobData.jobDescription || 'Not provided'}</p>
          <p><strong>Location:</strong> ${jobData.completeAddress || 'Not provided'}</p>
          <p><strong>Apply by:</strong> ${jobData.applicationDeadlineDate || 'Not provided'}</p>
          <br>
          <p>If you have any questions, feel free to reach out to us at any time.</p>
          <p>Best regards,<br>Second Job Team</p>
        </div>
      `;

      const mailOptions = {
        from: env.EMAIL_USER,
        to: candidate.email,
        subject: `New Job Posting: ${jobData.jobTitle}`,
        html: htmlMessage,
        attachments: [
          {
            filename: 'logo.png',
            path: logoPath,
            cid: 'logo',
          },
        ],
      };

      try {
        await transporter.sendMail(mailOptions);
        emailStatusList.push({ email: candidate.email, read: false });
        candidateEmails.push(candidate.email);
      } catch (error) {
        console.error(`Error sending notification to ${candidate.email}:`, error);
      }
    }));

    const newNotificationLog = new NotficationLog({
      userId: candidates.map(candidate => candidate._id),
      jobId: job._id,
      notificationType: 'job_posting',
      email: candidateEmails,
      emailStatus: emailStatusList,
    });

    await newNotificationLog.save();

    res.status(201).json({ message: 'Paid job posted successfully and email notifications sent to candidates', job });
  } catch (error) {
    console.error('Error posting job or sending emails:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

const updateJob = async (req, res) => {
  const { id } = req.params;
  const updatedData = req.body;

  try {
    updatedData.__v = 0; // Reset version if necessary (only if relevant to your use case)

    // Attempt to update the job in the Job collection
    let job = await Job.findByIdAndUpdate(id, updatedData, { new: true });

    if (!job) {
      console.log('Job not found in Job collection. Searching in FreeJob...');
      // If job is not found in Job collection, attempt to find and update in FreeJob
      job = await FreeJob.findByIdAndUpdate(id, updatedData, { new: true });

      if (!job) {
        return res.status(404).json({ message: 'Job not found in both Job and FreeJob collections' });
      }
    }

    console.log('Updated Job:', job);
    res.status(200).json({ message: 'Job updated successfully', job });
  } catch (error) {
    console.error('Error updating job:', error); // Full error log
    res.status(500).json({
      message: 'Something went wrong',
      error: error.message,
      stack: error.stack, // This is very helpful for debugging
    });
  }
};

module.exports = { getAllJobs, getJobById, getJobByUserId, deleteJob, postJob, updateJob };
