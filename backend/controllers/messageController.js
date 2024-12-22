const Message = require('../models/messageModel');
const User = require('../models/userModel');

const getAllMessages = async (req, res) => {
  try {
    const messages = await Message.find(); // Retrieve all users

    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ message: "Server error" });
  }
};

const getMessages = async (req, res) => {
  const { senderId, receiverId } = req.query;

  if (!senderId || !receiverId) {
      return res.status(400).json({ message: 'Sender ID and Receiver ID are required' });
  }

  try {
      // Find messages where senderId and receiverId match
      const messages = await Message.find({
          $or: [
              { senderId, receiverId },
              { senderId: receiverId, receiverId: senderId }
          ]
      }).sort({ createdAt: 1 }); // Sort messages by creation date (ascending)

      res.status(200).json(messages);
  } catch (error) {
      console.error('Error retrieving messages:', error);
      res.status(500).json({ message: 'Server error' });
  }
};

const postMessages = async (req, res) => {
  const { chatId, senderId, receiverId, text } = req.body;

  try {
      const newMessage = new Message({ chatId, senderId, receiverId, text });
      await newMessage.save();
      res.status(201).json(newMessage);
  } catch (error) {
      console.error('Error creating message:', error);
      res.status(500).json({ message: 'Server error' });
  }
};

const getMessagesById = async (req, res) => {
  const { id } = req.params;

  // Validate that the ID is a valid ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid receiver ID format' });
  }

  try {
      // Find messages where senderId and receiverId match
      const messages = await Message.find({$or: [
        { senderId: id },
        { receiverId: id }
      ]}).sort({ createdAt: 1 }); // Sort messages by creation date (ascending)

      res.status(200).json(messages);
  } catch (error) {
      console.error('Error retrieving messages:', error);
      res.status(500).json({ message: 'Server error' });
  }
};

const readMessages = async (req, res) => {
  const { id } = req.params;

  // Validate that the ID is a valid ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid receiver ID format' });
  }

  try {
    // Update messages that are unread and sent to the specified receiver
    const result = await Message.updateMany(
      { receiverId: id, read: false },
      { $set: { read: true } }
    );

    // Respond with the count of modified documents
    res.status(200).json({
      message: 'Messages updated successfully',
      modifiedCount: result.nModified // `result.nModified` indicates the number of documents modified
    });
  } catch (error) {
    console.error('Error updating messages:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

const notifyMessages = async (req, res) => {
  const { id } = req.params;

  // Validate that the ID is a valid ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid receiver ID format' });
  }

  try {
    // Count the number of notifications where `receiverId` matches `id` and `isRead` is true
    const readCount = await Message.countDocuments({
      receiverId: id,
      read: false
    });

    // Send the count as a response
    res.json({ readCount });
  } catch (error) {
    // Handle any errors that occur during the database operation
    console.error(error);
    res.status(500).json({ message: 'An error occurred while retrieving notification count' });
  }
};

const editMessage = async (req, res) => {
  const { id } = req.params; // Message ID from the URL parameter
  const { senderId, newText } = req.body; // Extract senderId and new text from request body

  if (!senderId || !newText) {
      return res.status(400).json({ message: 'Sender ID and new text are required' });
  }

  try {
      // Find the message by ID and check if it matches the senderId
      const message = await Message.findOne({ _id: id, senderId });

      if (!message) {
          return res.status(404).json({ message: 'Message not found or sender ID does not match' });
      }

      // Update the message text
      message.text = newText;
      await message.save();

      res.status(200).json(message);
  } catch (error) {
      console.error('Error updating message:', error);
      res.status(500).json({ message: 'Server error' });
  }
};

const getUserListMessage = async (req, res) => {
  const { id } = req.params;

  if (!id) {
    return res.status(400).json({ message: 'ID is required' });
  }

  try {
    // Find messages where the senderId or receiverId matches the provided ID
    const messages = await Message.find({
      $or: [
        { senderId: id },
        { receiverId: id }
      ]
    }).exec();

    // Extract unique user IDs from the messages
    const userIds = new Set();
    messages.forEach(message => {
      if (message.senderId.toString() !== id) userIds.add(message.senderId);
      if (message.receiverId.toString() !== id) userIds.add(message.receiverId);
    });

    // Fetch user details based on extracted user IDs
    const users = await User.find({ _id: { $in: Array.from(userIds) } }).exec();

    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

const deleteMessage = async (req, res) => {
  const { id } = req.params; // Message ID from the URL parameter
  const { senderId } = req.body; // Extract senderId from request body

  if (!senderId) {
      return res.status(400).json({ message: 'Sender ID is required' });
  }

  try {
      // Find the message by ID and check if it matches the senderId
      const message = await Message.findOne({ _id: id, senderId });

      if (!message) {
          return res.status(404).json({ message: 'Message not found or sender ID does not match' });
      }

      // Delete the message
      await Message.deleteOne({ _id: id });

      res.status(200).json({ message: 'Message deleted successfully' });
  } catch (error) {
      console.error('Error deleting message:', error);
      res.status(500).json({ message: 'Server error' });
  }
};

module.exports = { getAllMessages, getMessages, postMessages, getMessagesById, readMessages,
                    notifyMessages, editMessage, getUserListMessage, deleteMessage };
