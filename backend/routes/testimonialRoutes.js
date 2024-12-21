const express = require('express');
const { getAllTestimonials } = require('../controllers/testimonialController');
const router = express.Router();

router.get('', getAllTestimonials);

module.exports = router;
