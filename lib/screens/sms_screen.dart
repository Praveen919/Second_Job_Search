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
        backgroundColor: Color(0xFFBFDBFE),
        elevation: 4.0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                          trailing: const Icon(Icons.arrow_forward,
                              color: Colors.green),
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
                        ),
                        const Divider(),
                      ],
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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: GestureDetector(
          onTap: () {
            setState(() {
              messageData['expanded'] = !expanded;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.green[400] : Colors.grey[300],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  expanded || messageLines.length <= 15
                      ? message
                      : "${messageLines.take(15).join("\n")}...\nRead More",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        backgroundColor: Color(0xFFBFDBFE),
        elevation: 4.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(messages[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onSubmitted: (_) =>
                        _sendMessage(widget.senderId, widget.receiverId),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () =>
                        _sendMessage(widget.senderId, widget.receiverId),
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
