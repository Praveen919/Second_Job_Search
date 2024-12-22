const express = require('express');
const { getAllBlogs, getBlogByUserId, createBlogPost, uploadBlogImage } = require('../controllers/blogController');
const router = express.Router();

router.get('', getAllBlogs);
router.get('/user/:id', getBlogByUserId)
router.post('', uploadBlogImage.single('image'), createBlogPost);

module.exports = router;
