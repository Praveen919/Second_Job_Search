const Testimonial = require('../models/testimonialModel');

const getAllTestimonials = async (req, res) => {
  try {
    const testimonials = await Testimonial.find(); // Retrieve all users

    res.status(200).json(testimonials);
  } catch (error) {
    console.error('Error fetching testimonials:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllTestimonials };
