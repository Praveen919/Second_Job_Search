const express = require('express');
const { getAllBlogs } = require('../controllers/blogController');
const router = express.Router();

router.get('', getAllBlogs);

module.exports = router;
