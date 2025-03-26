import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/Config/config.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SmsScreen extends StatefulWidget {
  @override
  _SmsScreenState createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  List<Map<String, dynamic>> contacts = [];
  bool isLoading = true;
  String? senderId = '';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    fetchContacts();
  }

  Future<void> fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString("userId");
    print(senderId);
    try {
      final response = await http.get(
          Uri.parse('${AppConfig.baseUrl}/api/messages/user-list/$senderId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          contacts = data
              .map((user) => {
                    'name': "Admin",
                    'receiverId': user['_id'],
                    'lastActive': DateTime.parse(user['registeredTimeStamp'])
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load contacts';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching contacts: $e';
        isLoading = false;
      });
    }
  }

  String _getLastActiveDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor:
            const Color.fromARGB(255, 100, 176, 238), // Clean solid color
        elevation: 3.0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                senderId: senderId ?? "",
                                receiverId: contacts[index]['receiverId'],
                                contactName: contacts[index]['name']),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.green,
                              child: Text(
                                contacts[index]['name'][0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contacts[index]['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Last active: ${_getLastActiveDate(contacts[index]['lastActive'])}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.grey.shade400, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String senderId;
  final String receiverId;

  const ChatScreen(
      {super.key,
      required this.senderId,
      required this.receiverId,
      required this.contactName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    // Set up a listener to fetch messages every 3 seconds
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      fetchMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchMessages() async {
    if (!mounted) return; // Ensure the widget is still in the tree

    try {
      final response = await http.get(Uri.parse(
          '${AppConfig.baseUrl}/api/messages/users?senderId=${widget.senderId}&receiverId=${widget.receiverId}'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Map<String, dynamic>> newMessages = data
            .map((msg) => {
                  'text': msg['text'],
                  'isMe': msg['senderId'] == widget.senderId,
                  'timestamp': DateTime.parse(msg['createdAt']),
                  'expanded': false,
                })
            .toList();

        if (mounted) {
          setState(() {
            messages = newMessages;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _sendMessage(String senderId, String receiverId) async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      Map<String, dynamic> messageData = {
        "senderId": senderId,
        "receiverId": receiverId,
        "text": message,
      };
      print(messageData);

      try {
        final response = await http.post(
          Uri.parse(
              '${AppConfig.baseUrl}/api/messages'), // Adjust URL if needed
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(messageData),
        );

        if (response.statusCode == 201) {
          setState(() {
            fetchMessages();
          });
          _messageController.clear();
        } else {
          print("Failed to send message: ${response.body}");
        }
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData) {
    final isMe = messageData['isMe'];
    final message = messageData['text'];
    final timestamp = messageData['timestamp'];
    final expanded = messageData['expanded'];

    List<String> messageLines = message.split("\n");
    bool isLongMessage = messageLines.length > 15;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: isMe
                  ? LinearGradient(
                      colors: [
                        Color(0xFF00B4DB), // Light Teal
                        Color(0xFF0083B0), // Royal Blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Color(0xFF64B0EE), Color(0xFF007AFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: isMe ? Radius.circular(18) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expanded || !isLongMessage
                            ? message
                            : "${messageLines.take(15).join("\n")}...",
                        style: TextStyle(
                          fontSize: 16,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (isLongMessage)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              messageData['expanded'] = !expanded;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              expanded ? "Read Less" : "Read More",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.white70 : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('hh:mm a').format(timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
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
        backgroundColor:
            const Color.fromARGB(255, 100, 176, 238), // Single solid color
        elevation: 4.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(messages[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) =>
                          _sendMessage(widget.senderId, widget.receiverId),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF64B0EE), Color(0xFF007AFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () =>
                          _sendMessage(widget.senderId, widget.receiverId),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
