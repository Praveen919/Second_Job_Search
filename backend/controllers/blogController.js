const Blog = require('../models/blogModel');

const getAllBlogs = async (req, res) => {
  try {
    const blogs = await Blog.find(); // Retrieve all users

    res.status(200).json(blogs);
  } catch (error) {
    console.error('Error fetching blogs:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllBlogs };
