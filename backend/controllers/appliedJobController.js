const AppliedJob = require('../models/appliedJobModel');
const Plan = require('../models/planModel');
const Job = require('../models/jobModel');
const FreeJob = require('../models/freeJobModel');
const Skill = require('../models/skillModel');

const getAllAppliedJobs = async (req, res) => {
  try {
    const appliedJob = await AppliedJob.find(); // Retrieve all users

    res.status(200).json(appliedJob);
  } catch (error) {
    console.error('Error fetching appliedJobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const getAppliedJobsByUserId = async (req, res) => {
  const { user_id } = req.params;

  if (!user_id) {
    return res.status(400).send({ message: 'user_id is required' });
  }

  try {
    const applications = await AppliedJob.find({ user_id });

    for (const application of applications) {
      if (application.post_type === 'Job') {
        await application.populate('post_id', 'jobTitle industry city country');
      } else if (application.post_type === 'FreeJobs') {
        await application.populate('post_id', 'jobTitle industry city country');
      }

      // Format the timestamp (or any other date field)
      if (application.timestamp) {
        const timestamp = new Date(application.timestamp);
        application.timestamp = isNaN(timestamp.getTime())
          ? 'Invalid Date'
          : timestamp.toLocaleDateString(); // Format the date
      }
    }

    if (applications.length > 0) {
      return res.status(200).json(applications); // Return the applications with formatted date
    } else {
      return res.status(404).json({ message: 'No applications found for the specified user_id' });
    }
  } catch (error) {
    console.error('Error fetching applications:', error);
    return res.status(500).json({ message: 'Server error' });
  }
};

const deleteAppliedJob = async (req, res) => {
  const { user_id, post_id } = req.body;

  if (!user_id || !post_id) {
    return res.status(400).json({ error: 'user_id and post_id are required' });
  }

  try {
    // Check if the application exists in the AppliedJob collection
    const existingApplication = await AppliedJob.findOne({ user_id, post_id });

    if (!existingApplication) {
      return res.status(400).json({ error: 'No application found for this job' });
    }

    // Get the plan_id associated with this application
    const planId = existingApplication.plan_id;

    // If no plan_id, just delete the application record without adjusting any plan
    if (!planId) {
      await AppliedJob.deleteOne({ user_id, post_id });
      return res.status(200).json({ message: 'Job application withdrawn successfully' });
    }

    // Fetch the plan to adjust available job applications
    const selectedPlan = await Plan.findById(planId);
    if (!selectedPlan) {
      return res.status(404).json({ error: 'Plan not found' });
    }

    const applicationTimestamp = existingApplication.timestamp;
    const currentTimestamp = new Date();
    const timeDifference = currentTimestamp - new Date(applicationTimestamp);

    // Check if the application was submitted within the last 10 minutes (600000 ms)
    const isWithin10Minutes = timeDifference <= 600000;

    // If the application is within the last 10 minutes, adjust the available applications
    if (isWithin10Minutes) {
      // Fetch the job to determine if it's paid or free
      let job = await Job.findById(post_id);
      let isPaidJob = true; // Default to paid job
      if (!job) {
        // If not found in regular jobs, check free jobs
        job = await FreeJob.findById(post_id);
        isPaidJob = false; // It's a free job if it's in the FreeJob collection
      }

      if (!job) {
        return res.status(404).json({ error: 'Job not found' });
      }

      // Adjust the apply_paid_jobs or apply_free_jobs based on job type
      if (isPaidJob && selectedPlan.apply_paid_jobs <= 0) {
        return res.status(400).json({ error: 'Cannot reduce paid job applications further' });
      } else if (!isPaidJob && selectedPlan.apply_free_jobs <= 0) {
        return res.status(400).json({ error: 'Cannot reduce free job applications further' });
      }

      // Increase the available job applications based on job type
      if (isPaidJob) {
        selectedPlan.apply_paid_jobs += 1;
      } else {
        selectedPlan.apply_free_jobs += 1;
      }

      // Save the updated plan
      await selectedPlan.save();
    }

    // After adjusting the plan (if needed), delete the application record from AppliedJob
    await AppliedJob.deleteOne({ user_id, post_id });

    return res.status(200).json({ message: 'Job application withdrawn successfully' });
  } catch (error) {
    console.error('Error withdrawing job application:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

const getJobAndApplicationsByUserid = async (req, res) => {
  const { user_id } = req.params;

  try {
    // Fetch paid jobs first
    let jobs = await Job.find({ user_id }).lean();
    let jobType = "Paid Job";

    // If no paid jobs, fetch free jobs
    if (!jobs || jobs.length === 0) {
      jobs = await FreeJob.find({ user_id }).lean();
      jobType = "Free Job";
    }

    // If still no jobs, return 404
    if (jobs.length === 0) {
      return res.status(404).json({ message: "No jobs found for this user" });
    }

    const flattenedData = [];

    for (const job of jobs) {
      try {
        const applications = await AppliedJob.find({ post_id: job._id });

        if (applications.length > 0) {
          // Process applications
          for (const application of applications) {
            const user = await User.findById(application.user_id).select('name email resume image');

            // Fetch user skills
            const skills = await Skill.find({ userId: user._id });

            // Flatten the skills into an array
            const userSkills = skills.map(skill => ({
              skillName: skill.skillName,
              knowledgeLevel: skill.knowledgeLevel,
              experienceWeeks: skill.experienceWeeks
            }));

            flattenedData.push({
              job_id: job._id,
              job_title: job.jobTitle || null, // Ensure fallback for job title
              job_type: jobType,
              application_id: application._id,
              applied_date: application.timestamp,
              user_id: user ? user._id : null,
              user_name: user ? user.name : null,
              user_email: user ? user.email : null,
              user_resume: user ? user.resume : null, // Resume field
              user_status: application ? application.__v : null,
              user_image: user ? user.image : null,
              user_skills: userSkills, // Add skills here
            });
          }
        } else {
          // Add job without applications
          flattenedData.push({
            job_id: job._id,
            job_title: job.title || null,
            job_type: jobType,
            application_id: null,
            applied_date: null,
            user_id: null,
            user_name: null,
            user_email: null,
            user_resume: null,
            user_status: null,
            user_image: null,
            user_skills: [] // No skills for jobs without applications
          });
        }
      } catch (applicationError) {
        console.error(`Error fetching applications for job ${job._id}:`, applicationError);
      }
    }

    res.status(200).json(flattenedData);
  } catch (error) {
    console.error('Error fetching job and application data:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const updateSeen = async (req, res) => {
  const { post_id } = req.body;

  if (!post_id) {
    return res.status(400).json({ error: 'post_id is required' });
  }

  try {
    const record = await AppliedJob.findOne({ post_id });

    if (record) {
      record.seen = true;
      await record.save();

      return res.status(200).json({ valid: true, message: 'Seen status updated' });
    } else {
      return res.status(404).json({ valid: false, message: 'Record not found' });
    }
  } catch (error) {
    console.error('Error updating seen status:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

const getApplicationCount = async (req, res) => {
  const { post_id } = req.params;

  if (!post_id) {
    return res.status(400).send({ message: 'Post_id is required' });
  }

  try {
    const applications = await AppliedJob.find({ post_id });

    if (applications.length > 0) {
      res.status(200).json(applications);
    } else {
      res.status(404).json({ message: 'No applications found for the specified post_id' });
    }
  } catch (error) {
    console.error('Error fetching applications:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getAllAppliedJobs, getAppliedJobsByUserId, deleteAppliedJob, getJobAndApplicationsByUserid,
                    updateSeen, getApplicationCount };
