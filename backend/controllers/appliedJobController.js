const AppliedJob = require('../models/appliedJobModel');
const Plan = require('../models/planModel');
const Job = require('../models/jobModel');
const FreeJob = require('../models/freeJobModel');

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

module.exports = { getAllAppliedJobs, getAppliedJobsByUserId, deleteAppliedJob };
