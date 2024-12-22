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

const getPlanByUserId = async (req, res) => {
  try {
    const userId = req.params.user_id; // Extract user_id from URL
    // Query the database for plans that match the user_id
    const plans = await Plan.find({ user_id: userId });

    if (plans.length === 0) {
      return res.status(404).json({ message: 'No plans found for this user' });
    }

    res.status(200).json(plans); // Return the array of plans matching the user_id
  } catch (error) {
    console.error('Error fetching plans:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const purchaseByWalletPoint = async (req, res) => {
  const { user_id, plan_name } = req.body;

  let no_of_days;
  let paid_jobs = 0; // Default value or calculate as needed
  let free_jobs = 0; // Default value or calculate as needed
  let apply_paid_jobs = 0; // Default value or calculate as needed
  let apply_free_jobs = 0; // Default value or calculate as needed
  let plan_price = 0;
  let end_date = new Date(); // Start with today's date

  // Determine the number of days and jobs based on plan_name
  switch (plan_name) {
    case 'Basic':
      no_of_days = 30;
      paid_jobs = 5; // Example value, adjust as necessary
      apply_paid_jobs = 10;
      apply_free_jobs = 5;
      free_jobs = 2; // Example value, adjust as necessary
      plan_price = 100;
      break;
    case 'Standard':
      no_of_days = 30;
      paid_jobs = 20; // Example value, adjust as necessary
      free_jobs = 10; // Example value, adjust as necessary
      apply_paid_jobs = 40;
      apply_free_jobs = 20;
      plan_price = 500;
      break;
    case 'Extended':
      no_of_days = 30;
      paid_jobs = 30; // Example value, adjust as necessary
      free_jobs = 15; // Example value, adjust as necessary
      apply_paid_jobs = 60;
      apply_free_jobs = 30;
      plan_price = 800;
      break;
    default:
      return res.status(400).json({ message: 'Invalid plan name' });
  }

  end_date.setDate(end_date.getDate() + no_of_days); // Add no_of_days to today's date

  try {
      // Fetch the user's wallet points
      const user = await User.findById(user_id); // Adjust according to your User model
      if (!user) {
          return res.status(404).json({ message: 'User not found' });
      }

      const walletPoints = user.walletPoints; // Assuming walletPoints is a field in the User model
      const remainingAmount = plan_price - walletPoints;

      // Update user's wallet points
      user.walletPoints = 0; // Deduct all points
      await user.save(); // Save the user changes

      // If there is any remaining amount, you can handle it here (e.g., process a payment)
      if (remainingAmount > 0) {
          // Handle payment processing for remaining amount here
          // For example, you could integrate with a payment gateway
          return res.status(200).json({
              message: 'Plan purchased successfully, but remaining amount needs to be paid',
              remainingAmount
          });
      }

      // Create a new plan instance
      const newPlan = new Plan({
        user_id,
        plan_name,
        bought_timestamp: new Date(), // Set bought_timestamp to current date and time
        no_of_days,
        start_date: new Date(), // Set start_date to today's date
        end_date, // Assign calculated end_date
        paid_jobs,
        free_jobs, 
        apply_paid_jobs,
        apply_free_jobs,
        plan_price
      });

      // Save the plan record to the database
      await newPlan.save();

      res.status(201).json({ message: 'Plan purchased successfully', plan: newPlan });
  } catch (error) {
      console.error('Error purchasing plan:', error);
      res.status(500).json({ message: 'Failed to purchase plan' });
  }
};

const purchasePlan = async (req, res) => {
  const { user_id, plan_name } = req.body;

  let no_of_days;
  let paid_jobs = 0; // Default value or calculate as needed
  let free_jobs = 0; // Default value or calculate as needed
  let apply_paid_jobs = 0; // Default value or calculate as needed
  let apply_free_jobs = 0; // Default value or calculate as needed
  let plan_price = 0;
  let end_date = new Date(); // Start with today's date

  // Determine the number of days and jobs based on plan_name
  switch (plan_name) {
    case 'Basic':
      no_of_days = 30;
      paid_jobs = 5; // Example value, adjust as necessary
      apply_paid_jobs = 10;
      apply_free_jobs = 5;
      free_jobs = 2; // Example value, adjust as necessary
      plan_price = 100;
      break;
    case 'Standard':
      no_of_days = 30;
      paid_jobs = 20; // Example value, adjust as necessary
      free_jobs = 10; // Example value, adjust as necessary
      apply_paid_jobs = 40;
      apply_free_jobs = 20;
      plan_price = 500;
      break;
    case 'Extended':
      no_of_days = 30;
      paid_jobs = 30; // Example value, adjust as necessary
      free_jobs = 15; // Example value, adjust as necessary
      apply_paid_jobs = 60;
      apply_free_jobs = 30;
      plan_price = 800;
      break;
    default:
      return res.status(400).json({ message: 'Invalid plan name' });
  }

  end_date.setDate(end_date.getDate() + no_of_days); // Add no_of_days to today's date

  try {
    // Create a new plan instance
    const newPlan = new Plan({
      user_id,
      plan_name,
      bought_timestamp: new Date(), // Set bought_timestamp to current date and time
      no_of_days,
      start_date: new Date(), // Set start_date to today's date
      end_date, // Assign calculated end_date
      paid_jobs,
      free_jobs, 
      apply_paid_jobs,
      apply_free_jobs,
      plan_price
    });

    // Save the plan record to the database
    await newPlan.save();

    res.status(201).json({ message: 'Plan purchased successfully', plan: newPlan });
  } catch (error) {
    console.error('Error purchasing plan:', error);
    res.status(500).json({ message: 'Failed to purchase plan' });
  }
};

module.exports = { getAllPlans, getPlanByUserId, purchaseByWalletPoint, purchasePlan };
