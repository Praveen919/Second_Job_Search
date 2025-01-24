const Plan = require('../models/planModel');
const User = require('../models/userModel');  // Assuming you have a User model to find users by ID

// Fetch all plans
const getAllPlans = async (req, res) => {
  try {
    const plans = await Plan.find();
    res.status(200).json(plans);
  } catch (error) {
    console.error('Error fetching plans:', error);
    res.status(500).json({ message: "Server error" });
  }
};

// Purchase a plan using wallet points
const purchaseByWalletpoint = async (req, res) => {
  const { user_id, plan_name } = req.body;
  let no_of_days, paid_jobs = 0, free_jobs = 0, apply_paid_jobs = 0, apply_free_jobs = 0, plan_price = 0;
  let end_date = new Date();

  // Determine plan details
  switch (plan_name) {
    case 'Basic':
      no_of_days = 30;
      paid_jobs = 5;
      apply_paid_jobs = 10;
      apply_free_jobs = 5;
      free_jobs = 2;
      plan_price = 100;
      break;
    case 'Standard':
      no_of_days = 30;
      paid_jobs = 20;
      free_jobs = 10;
      apply_paid_jobs = 40;
      apply_free_jobs = 20;
      plan_price = 500;
      break;
    case 'Extended':
      no_of_days = 30;
      paid_jobs = 30;
      free_jobs = 15;
      apply_paid_jobs = 60;
      apply_free_jobs = 30;
      plan_price = 800;
      break;
    default:
      return res.status(400).json({ message: 'Invalid plan name' });
  }

  end_date.setDate(end_date.getDate() + no_of_days);  // Add days to current date

  try {
    const user = await User.findById(user_id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const walletPoints = user.walletPoints;
    const remainingAmount = plan_price - walletPoints;

    if (remainingAmount > 0) {
      return res.status(200).json({ message: 'Plan purchased successfully, but remaining amount needs to be paid', remainingAmount });
    }

    // Check if the user already has the same plan
    const existingPlan = await Plan.findOne({ user_id, plan_name });

    if (existingPlan) {
      // Update the existing plan
      existingPlan.paid_jobs += paid_jobs;
      existingPlan.free_jobs += free_jobs;
      existingPlan.apply_paid_jobs += apply_paid_jobs;
      existingPlan.apply_free_jobs += apply_free_jobs;
      existingPlan.end_date = end_date;

      user.walletPoints = 0;  // Deduct wallet points
      await user.save();
      await existingPlan.save();

      return res.status(200).json({ message: 'Plan updated successfully', plan: existingPlan });
    }

    // If no existing plan, create a new plan
    const newPlan = new Plan({
      user_id,
      plan_name,
      bought_timestamp: new Date(),
      no_of_days,
      start_date: new Date(),
      end_date,
      paid_jobs,
      free_jobs,
      apply_paid_jobs,
      apply_free_jobs,
      plan_price
    });

    user.walletPoints = 0;  // Deduct wallet points
    await user.save();
    await newPlan.save();

    res.status(201).json({ message: 'Plan purchased successfully', plan: newPlan });
  } catch (error) {
    console.error('Error purchasing plan:', error);
    res.status(500).json({ message: 'Failed to purchase plan' });
  }
};

// Purchase a plan without wallet points (if applicable)
const purchase = async (req, res) => {
  const { user_id, plan_name } = req.body;
  let no_of_days, paid_jobs = 0, free_jobs = 0, apply_paid_jobs = 0, apply_free_jobs = 0, plan_price = 0;
  let end_date = new Date();

  switch (plan_name) {
    case 'Basic':
      no_of_days = 30;
      paid_jobs = 5;
      apply_paid_jobs = 10;
      apply_free_jobs = 5;
      free_jobs = 2;
      plan_price = 100;
      break;
    case 'Standard':
      no_of_days = 30;
      paid_jobs = 20;
      free_jobs = 10;
      apply_paid_jobs = 40;
      apply_free_jobs = 20;
      plan_price = 500;
      break;
    case 'Extended':
      no_of_days = 30;
      paid_jobs = 30;
      free_jobs = 15;
      apply_paid_jobs = 60;
      apply_free_jobs = 30;
      plan_price = 800;
      break;
    default:
      return res.status(400).json({ message: 'Invalid plan name' });
  }

  end_date.setDate(end_date.getDate() + no_of_days);  // Add days to current date

  try {
    const existingPlan = await Plan.findOne({ user_id, plan_name });

    if (existingPlan) {
      // Update the existing plan
      existingPlan.paid_jobs += paid_jobs;
      existingPlan.free_jobs += free_jobs;
      existingPlan.apply_paid_jobs += apply_paid_jobs;
      existingPlan.apply_free_jobs += apply_free_jobs;
      existingPlan.end_date = end_date;

      await existingPlan.save();
      return res.status(200).json({ message: 'Plan updated successfully', plan: existingPlan });
    }

    const newPlan = new Plan({
      user_id,
      plan_name,
      bought_timestamp: new Date(),
      no_of_days,
      start_date: new Date(),
      end_date,
      paid_jobs,
      free_jobs,
      apply_paid_jobs,
      apply_free_jobs,
      plan_price
    });

    await newPlan.save();
    res.status(201).json({ message: 'Plan purchased successfully', plan: newPlan });
  } catch (error) {
    console.error('Error purchasing plan:', error);
    res.status(500).json({ message: 'Failed to purchase plan' });
  }
};

// Get all plans by user_id
const getPlansByUserId = async (req, res) => {
  const { user_id } = req.params;

  try {
    const userPlans = await Plan.find({ user_id });
    res.status(200).json({ plans: userPlans });
  } catch (error) {
    console.error('Error fetching user plans:', error);
    res.status(500).json({ message: 'Failed to fetch user plans' });
  }
};

// Get a plan by its ID
const getPlanById = async (req, res) => {
  const { id } = req.params;

  try {
    const plan = await Plan.findById(id);
    if (!plan) return res.status(404).json({ message: 'Plan not found' });

    res.status(200).json({ plan });
  } catch (error) {
    console.error('Error fetching plan:', error);
    res.status(500).json({ message: 'Failed to fetch plan' });
  }
};

// Get plans with discount logic for a user
const getPlansForDiscount = async (req, res) => {
  const { userId } = req.params;

  try {
    const planCount = await Plan.countDocuments({ user_id: userId });
    const plans = await Plan.find({ user_id: userId });

    if (plans.length === 0) return res.status(404).json({ message: 'No plans found for this user.' });

    const updatedPlans = plans.map(plan => {
      const price = parseFloat(plan.plan_price); // Assuming price is stored as a string
      let discountedPrice = price;

      if (planCount > 4) {
        discountedPrice = price * 0.95; // Apply a 5% discount
      }

      return { ...plan.toObject(), discountedPrice: discountedPrice.toFixed(2) };
    });

    res.status(200).json({ plans: updatedPlans });
  } catch (error) {
    console.error('Error fetching plans:', error);
    res.status(500).json({ message: 'Failed to fetch plans' });
  }
};

// Get all plans with user email and role
const getAllPlansWithUserInfo = async (req, res) => {
  try {
    const allPlans = await Plan.find();

    const plansWithEmailAndRole = [];
    
    for (let plan of allPlans) {
      const user = await User.findById(plan.user_id);
      if (user) {
        plansWithEmailAndRole.push({
          ...plan.toObject(),
          email: user.email,
          role: user.role || 'User',
        });
      } else {
        plansWithEmailAndRole.push(plan.toObject());
      }
    }

    res.status(200).json({ plans: plansWithEmailAndRole });
  } catch (error) {
    console.error('Error fetching all plans:', error);
    res.status(500).json({ message: 'Failed to fetch all plans' });
  }
};

module.exports = {
  getAllPlans,
  purchaseByWalletpoint,
  purchase,
  getPlansByUserId,
  getPlanById,
  getPlansForDiscount,
  getAllPlansWithUserInfo,
};
