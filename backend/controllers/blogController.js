const Blog = require('../models/blogModel');
const multer = require('multer');
const path = require('path');

// Get all blogs
const getAllBlogs = async (req, res) => {
  try {
    const blogs = await Blog.find(); // Retrieve all users
    res.status(200).json(blogs);
  } catch (error) {
    console.error('Error fetching blogs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

// Get blogs by user ID
const getBlogByUserId = async (req, res) => {
  try {
    const userId = req.params.id;

    if (!userId) {
      return res.status(400).json({ message: "User ID is required" });
    }

    const blogs = await Blog.find({ userId: userId });

    if (blogs.length === 0) {
      return res.status(404).json({ message: "No blogs found for this user" });
    }

    return res.json(blogs);
  } catch (error) {
    console.error('Error fetching blogs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

// Multer storage configuration
const blogImageStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../public/blog/images')); // Adjusted path
  },
  filename: (req, file, cb) => {
    const extension = path.extname(file.originalname);
    const filename = `${Date.now()}${extension}`;
    cb(null, filename);
  }
});

// File filter and upload configuration
const uploadBlogImage = multer({
  storage: blogImageStorage,
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

// Function to handle blog post submission
const createBlogPost = async (req, res) => {
  try {
    if (req.fileValidationError) {
      return res.status(400).json({ error: req.fileValidationError });
    }

    const { title, userId, content } = req.body;
    if (!title || !userId || !content) {
      return res.status(400).json({ error: 'Title, userId, and content are required' });
    }

    const imageUrl = req.file ? `/blog/images/${req.file.filename}` : null;

    const newBlog = new Blog({
      title,
      userId,
      content,
      image: imageUrl
    });

    await newBlog.save();
    res.status(201).json({ message: 'Blog post created successfully', blog: newBlog });
  } catch (error) {
    res.status(500).json({ error: 'An error occurred while creating the blog post' });
  }
};

// Export all functions
module.exports = {  getAllBlogs, getBlogByUserId, createBlogPost, uploadBlogImage };
