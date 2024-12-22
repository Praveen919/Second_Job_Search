const express = require('express');
const { getAllMessages, getMessages, postMessages, getMessagesById, readMessages,
    notifyMessages, editMessage, getUserListMessage, deleteMessage } = require('../controllers/messageController');
const router = express.Router();

router.get('', getAllMessages);
router.get('/user-message', getMessages);
router.post('', postMessages);
router.get('/:id', getMessagesById);
router.put('/read/:id', readMessages);
router.get('/message-notify/:id', notifyMessages);
router.put('/edit/:id', editMessage);
router.get('/user-list/:id', getUserListMessage);
router.delete('', deleteMessage)

module.exports = router;
