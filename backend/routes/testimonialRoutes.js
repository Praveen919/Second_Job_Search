const express = require('express');
const { getAllTestimonials, uploadTestimonialImage, postTestimonial } = require('../controllers/testimonialController');
const router = express.Router();

router.get('', getAllTestimonials);
router.post('/testimonials', uploadTestimonialImage.single('photo'), postTestimonial);

module.exports = router;
