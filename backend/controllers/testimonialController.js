const Testimonial = require('../models/testimonialModel');
const multer = require('multer');

const getAllTestimonials = async (req, res) => {
  try {
    const testimonials = await Testimonial.find(); // Retrieve all users

    res.status(200).json(testimonials);
  } catch (error) {
    console.error('Error fetching testimonials:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const testimonialImageStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../public/testimonials/images')); // Adjust path for testimonials
  },
  filename: (req, file, cb) => {
    const extension = path.extname(file.originalname);
    const filename = `${Date.now()}${extension}`;
    cb(null, filename);
  }
});

// File filter to accept only specific types
const uploadTestimonialImage = multer({
  storage: testimonialImageStorage,
  fileFilter: (req, file, cb) => {
    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowedMimeTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Only JPEG, PNG, and GIF files are allowed.'), false);
    }
  },
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB file size limit
});


// Route to handle testimonial submission
const postTestimonial = async (req, res) => {
  try {
    if (req.fileValidationError) {
      return res.status(400).json({ error: req.fileValidationError });
    }

    const { name, message, designation, title } = req.body;

    // Validate required fields
    if (!name || !message) {
      return res.status(400).json({ error: 'Name and message are required' });
    }

    // Check if file was uploaded
    const photoUrl = req.file ? `/testimonials/images/${req.file.filename}` : null;

    // Create a new testimonial
    const newTestimonial = new Testimonial({
      photo: photoUrl,
      name,
      designation: designation || '', // Default to empty string if not provided
      title,
      message
    });

    // Save the testimonial to the database
    await newTestimonial.save();

    // Respond with success
    res.status(201).json({ message: 'Testimonial created successfully', testimonial: newTestimonial });
  } catch (error) {
    console.error('Error creating testimonial:', error); // Log error details
    res.status(500).json({ error: 'An error occurred while creating the testimonial' });
  }
};

module.exports = { getAllTestimonials, testimonialImageStorage, uploadTestimonialImage, postTestimonial };
