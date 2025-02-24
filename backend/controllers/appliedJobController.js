const AppliedJob = require('../models/appliedJobModel');
const User = require('../models/userModel');
const Job = require('../models/jobModel');
const mongoose = require('mongoose');
const FreeJob = require('../models/freeJobModel');
const Plan = require('../models/planModel');
const { sendEmail } = require('../utils/sendEmail'); // Importing sendEmail
console.log('sendEmail function:', sendEmail);

// Controller function to get all applied jobs
const getAllAppliedJobs = async (req, res) => {
  try {
    const appliedJob = await AppliedJob.find(); // Retrieve all applied jobs
    res.status(200).json(appliedJob);
  } catch (error) {
    console.error('Error fetching appliedJobs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

// Controller function to validate user and post IDs
const validateIds = async (req, res) => {
  const { user_id, post_id } = req.body;

  if (!user_id || !post_id) {
    return res.status(400).json({ error: 'user_id and post_id are required' });
  }

  try {
    // Check if there is a record with the given user_id and post_id
    const record = await AppliedJob.findOne({ user_id, post_id });

    if (record) {
      return res.status(200).json({ valid: true });
    } else {
      return res.status(404).json({ valid: false });
    }
  } catch (error) {
    console.error('Error checking IDs:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

// Endpoint to get all applied jobs with additional information
const getAllAppliedJobsWithDetails = async (req, res) => {
  try {
    const appliedJobs = await AppliedJob.find();
    const userIds = appliedJobs.map(job => job.user_id);
    const postIds = appliedJobs.map(job => job.post_id);

    const [users, jobs, freeJobs] = await Promise.all([
      User.find({ '_id': { $in: userIds } }),
      Job.find({ '_id': { $in: postIds } }),
      FreeJob.find({ '_id': { $in: postIds } })
    ]);

    const jobPosterIds = jobs.map(job => job.user_id);
    const jobPosters = await User.find({ '_id': { $in: jobPosterIds } });

    const usersMap = users.reduce((map, user) => {
      map[user._id] = user;
      return map;
    }, {});

    const jobsMap = jobs.reduce((map, job) => {
      map[job._id] = job;
      return map;
    }, {});

    const freeJobsMap = freeJobs.reduce((map, freeJob) => {
      map[freeJob._id] = freeJob;
      return map;
    }, {});

    const jobPostersMap = jobPosters.reduce((map, poster) => {
      map[poster._id] = poster;
      return map;
    }, {});

    const consolidatedData = appliedJobs.map(appliedJob => {
      const user = usersMap[appliedJob.user_id];
      let job = jobsMap[appliedJob.post_id] || freeJobsMap[appliedJob.post_id];
      let posterDetails = null;

      if (job && jobsMap[appliedJob.post_id]) {
        const poster = jobPostersMap[jobsMap[appliedJob.post_id].user_id];
        if (poster) {
          posterDetails = {
            email: poster.email,
            name: poster.name,
          };
        }
      }

      return {
        appliedJobId: appliedJob._id,
        seen: appliedJob.seen,
        timestamp: appliedJob.timestamp,
        status: appliedJob.__v,
        applicant: {
          id: user?._id,
          name: user?.name,
          email: user?.email,
        },
        job: job
          ? {
              id: job._id,
              title: job.jobTitle,
              description: job.jobDescription,
              salary: job.offeredSalary,
              companyName: job.companyName,
              location: {
                city: job.city,
                country: job.country,
              },
              poster: posterDetails,
            }
          : null,
      };
    });

    res.status(200).json(consolidatedData);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Endpoint to update the seen/unseen status for applied jobs
const updateSeenStatus = async (req, res) => {
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

// Endpoint to delete an applied job
const deleteAppliedJob = async (req, res) => {
  const { user_id, post_id } = req.body;

  if (!user_id || !post_id) {
    return res.status(400).json({ error: 'user_id and post_id are required' });
  }

  try {
    const existingApplication = await AppliedJob.findOne({ user_id, post_id });

    if (!existingApplication) {
      return res.status(400).json({ error: 'No application found for this job' });
    }

    const planId = existingApplication.plan_id;

    if (!planId) {
      await AppliedJob.deleteOne({ user_id, post_id });
      return res.status(200).json({ message: 'Job application withdrawn successfully' });
    }

    const selectedPlan = await Plan.findById(planId);
    if (!selectedPlan) {
      return res.status(404).json({ error: 'Plan not found' });
    }

    const applicationTimestamp = existingApplication.timestamp;
    const currentTimestamp = new Date();
    const timeDifference = currentTimestamp - new Date(applicationTimestamp);

    const isWithin10Minutes = timeDifference <= 600000;

    if (isWithin10Minutes) {
      let job = await Job.findById(post_id);
      let isPaidJob = true;
      if (!job) {
        job = await FreeJob.findById(post_id);
        isPaidJob = false;
      }

      if (!job) {
        return res.status(404).json({ error: 'Job not found' });
      }

      if (isPaidJob && selectedPlan.apply_paid_jobs <= 0) {
        return res.status(400).json({ error: 'Cannot reduce paid job applications further' });
      } else if (!isPaidJob && selectedPlan.apply_free_jobs <= 0) {
        return res.status(400).json({ error: 'Cannot reduce free job applications further' });
      }

      if (isPaidJob) {
        selectedPlan.apply_paid_jobs += 1;
      } else {
        selectedPlan.apply_free_jobs += 1;
      }

      await selectedPlan.save();
    }

    await AppliedJob.deleteOne({ user_id, post_id });
    return res.status(200).json({ message: 'Job application withdrawn successfully' });
  } catch (error) {
    console.error('Error withdrawing job application:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

// Endpoint to apply for a job
// Inside the applyForJob function
const applyForJob = async (req, res) => {
  const { user_id, post_id } = req.body;

  if (!user_id || !post_id) {
    return res.status(400).json({ error: 'user_id and post_id are required' });
  }

  const userId = user_id;

  try {
    if (!mongoose.Types.ObjectId.isValid(userId) || !mongoose.Types.ObjectId.isValid(post_id)) {
      return res.status(400).json({ error: 'Invalid user_id or post_id' });
    }

    const userPlans = await Plan.find({ user_id: userId });

    if (!userPlans || userPlans.length === 0) {
      return res.status(400).json({ error: 'User does not have any active plans' });
    }

    let job = await Job.findById(post_id);
    let isPaidJob = true;
    if (!job) {
      job = await FreeJob.findById(post_id);
      isPaidJob = false;
    }

    if (!job) {
      return res.status(404).json({ error: 'Job not found' });
    }

    let selectedPlan = null;
    let applyPaidJobs = 0;
    let applyFreeJobs = 0;

    for (let plan of userPlans) {
      const currentDate = new Date();
      if (plan.start_date <= currentDate && plan.end_date >= currentDate) {
        applyPaidJobs = plan.apply_paid_jobs || 0;
        applyFreeJobs = plan.apply_free_jobs || 0;

        if (isPaidJob && applyPaidJobs > 0) {
          selectedPlan = plan;
          break;
        } else if (!isPaidJob && applyFreeJobs > 0) {
          selectedPlan = plan;
          break;
        }
      }
    }

    if (!selectedPlan) {
      return res.status(400).json({ error: 'User does not have sufficient plan balance' });
    }

    await AppliedJob.create({ user_id: userId, post_id });

    if (isPaidJob) {
      selectedPlan.apply_paid_jobs -= 1;
    } else {
      selectedPlan.apply_free_jobs -= 1;
    }

    await selectedPlan.save();

    // Send a confirmation email to the applicant
    const applicant = await User.findById(userId);
    if (applicant) {
     console.log('Sending email to:', applicant.email);
      await sendEmail(applicant.email, 'Job Application Confirmation', 'Your application was successful!');
    }

    res.status(200).json({ message: 'Job application successful' });
  } catch (error) {
    console.error('Error applying for job:', error);
    res.status(500).json({ message: 'Error applying for job', error: error.message });
  }
};

// Exporting the functions to be used in your routes
module.exports = {
  getAllAppliedJobs,
  validateIds,
  getAllAppliedJobsWithDetails,
  updateSeenStatus,
  deleteAppliedJob,
  applyForJob,
};
