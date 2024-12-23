const express = require('express');
const { getAllNotficationLogs, updateReadSeen, candidateNotification, employerNotification } = require('../controllers/notificationLogController');
const router = express.Router();

router.get('', getAllNotficationLogs);
router.put('/read/:id', updateReadSeen);
router.get('/candidate/:id', candidateNotification);
route.get('/employer/:id', employerNotification)

module.exports = router;
