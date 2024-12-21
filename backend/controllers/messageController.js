const Message = require('../models/messageModel');

const getAllMessages = async (req, res) => {
  try {
    const messages = await Message.find(); // Retrieve all users

    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { getAllMessages };
