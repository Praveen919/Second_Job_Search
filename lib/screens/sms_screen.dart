import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // To format the date

class SmsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> contacts = [
    {'name': 'Alok', 'lastActive': DateTime.now().subtract(Duration(days: 1))},
    {'name': 'Vinay', 'lastActive': DateTime.now().subtract(Duration(days: 3))},
    {
      'name': 'Praveen',
      'lastActive': DateTime.now().subtract(Duration(days: 5))
    },
    {'name': 'Ajay', 'lastActive': DateTime.now().subtract(Duration(days: 2))},
    {'name': 'Sam', 'lastActive': DateTime.now().subtract(Duration(days: 7))},
  ];

  // Format the date to show the last active date with month and day
  String _getLastActiveDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date); // Month day, Year format
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Color(0xFFBFDBFE), // Keeping the original header color
        elevation: 4.0,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    contacts[index]['name'][0],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                title: Text(
                  contacts[index]['name'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Last active: ${_getLastActiveDate(contacts[index]['lastActive'])}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Colors.green),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(contactName: contacts[index]['name']),
                    ),
                  );
                },
              ),
              const Divider(), // Line separating the contacts, similar to LinkedIn messages
            ],
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;

  const ChatScreen({super.key, required this.contactName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add({
          'message': message,
          'isMe': true, // Sender's message
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();
    }
  }

  // Method to handle Enter key press
  void _onEnterPressed(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _sendMessage();
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData) {
    final isMe = messageData['isMe'];
    final message = messageData['message'];
    final timestamp = messageData['timestamp'];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *
                0.8), // Max width 80% of screen
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.green[400]
                : Colors.grey[300], // Color for sender vs receiver
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white70 : Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        backgroundColor: Color(0xFFBFDBFE), // Keeping the original header color
        elevation: 4.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        // Close the keyboard when tapping outside
                      }
                    },
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: _onEnterPressed, // Listen for the Enter key press
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blueGrey),
                  tooltip: 'Send',
                  color: Colors.green,
                ),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
