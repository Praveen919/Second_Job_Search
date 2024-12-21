const express = require('express');
const { getAllNotficationLogs } = require('../controllers/notificationLogController');
const router = express.Router();

router.get('', getAllNotficationLogs);

module.exports = router;
