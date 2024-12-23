const FreeJob = require('../models/freeJobModel');
const nodemailer = require('nodemailer');
const Plan = require('../models/planModel');
const User = require('../models/userModel');
const NotficationLog = require('../models/notficationLogModel');
const env = require('dotenv');

const getAllFreeJobs = async (req, res) => {
  try {
    const freeJobs = await FreeJob.find(); // Retrieve all users

    res.status(200).json(freeJobs);
  } catch (error) {
    console.error('Error fetching freeJobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: env.EMAIL_USER,
    pass: env.EMAIL_PASS,
  },
});

const postFreeJob = async (req, res) => {
  const jobData = req.body;

  // Validate the incoming data
  const requiredFields = [
    'jobTitle', 'jobCategory', 'jobDescription', 'email', 'username', 'specialisms',
    'jobType', 'keyResponsibilities', 'skillsAndExperience', 'offeredSalary', 'careerLevel', 'experienceYears', 'experienceMonths',
    'gender', 'industry', 'qualification', 'applicationDeadlineDate', 'country', 'city',
    'completeAddress', 'user_id', 'plan_id', 'employmentStatus', 'vacancies', 'companyName'
  ];

  for (const field of requiredFields) {
    if (!jobData[field]) {
      return res.status(400).json({ error: `Field ${field} is required` });
    }
  }

  try {
    // Find the plan based on the plan_id
    const plan = await Plan.findById(jobData.plan_id);
    if (!plan) {
      return res.status(400).json({ error: 'Invalid plan_id' });
    }

    // Check if the plan has any free jobs remaining
    if (plan.free_jobs <= 0) {
      return res.status(400).json({ error: 'No free jobs available in the selected plan' });
    }

    // Create a new job instance with jobData
    const job = new FreeJob({ ...jobData, specialisms: jobData.specialisms });
    
    // Save the job to the database
    await job.save();

    // Decrement the free_jobs count in the plan
    plan.free_jobs -= 1;
    await plan.save();

    // Fetch all users with role 'candidate'
    const candidates = await User.find({ role: 'candidate', 'dnd.isActive': false });
    if (!candidates || candidates.length === 0) {
      return res.status(400).json({ error: 'No candidates found' });
    }
     
    // Path to the logo image (adjust the path as necessary)
    const logoPath = path.join(__dirname, '../public/images/logo.png');

    // Array to store all candidate emails
    const candidateEmails = [];
    const emailStatusList = [];
    
    // Array to store all candidate user IDs
    const candidateUserIds = candidates.map(candidate => candidate._id); // Store user IDs of candidates

    // Send email notifications to candidates
    await Promise.all(candidates.map(async (candidate) => {
      try {
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

            <!-- DND Button -->
            <p style="text-align: center;">New job posted! Click the button below to set your Do Not Disturb (DND) mode.</p>
            <a href="http://localhost:5173/candidates-dashboard/my-profile"
              style="display: inline-block; 
                      padding: 12px 20px; 
                      background-color: #007bff; 
                      color: white; 
                      text-decoration: none; 
                      border-radius: 5px; 
                      font-weight: bold; 
                      transition: background-color 0.3s;">
              Set DND
            </a>

            <hr style="border: none; border-top: 1px solid #ccc;">
            <p style="text-align: center; color: #777;">© ${new Date().getFullYear()} Your Company. All rights reserved.</p>
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
              cid: 'logo', // This is the CID that will be referenced in the HTML img tag
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
      } catch (error) {
        console.error(`Error sending notification to ${candidate.email}:`, error);
      }
    }));

    // Log the notification in NotificationLog with all candidate emails and user IDs
    const newNotificationLog = new NotficationLog({
      userId: candidateUserIds, // Store user IDs of candidates in an array
      jobId: job._id,
      notificationType: 'job_posting',
      email: candidateEmails, 
      emailStatus: emailStatusList,
    });

    await newNotificationLog.save(); // Save the notification log to the database

    // Send success response
    res.status(201).json({ message: 'Free job posted successfully and email notifications sent to candidates', job });
  } catch (error) {
    console.error('Error posting job or sending emails:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

module.exports = { getAllFreeJobs, postFreeJob };
