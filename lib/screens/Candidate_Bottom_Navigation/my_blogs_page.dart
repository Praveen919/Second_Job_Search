import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To handle JSON
import 'package:second_job_search/Config/config.dart'; // Replace with your config file

// Blog model class
class Blog {
  final String title;
  final String username;
  final String content;

  Blog({
    required this.title,
    required this.username,
    required this.content,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'] ?? 'No Title', // Fallback value if title is null
      username: json['username'] ?? 'Anonymous', // Fallback value if username is null
      content: json['content'] ?? 'No Content', // Fallback value if content is null
    );
  }
}

class MyBlogsPageScreen extends StatefulWidget {
  const MyBlogsPageScreen({super.key});

  @override
  State<MyBlogsPageScreen> createState() => _MyBlogsPageScreenState();
}

class _MyBlogsPageScreenState extends State<MyBlogsPageScreen> {
  // List of blogs fetched from backend
  List<Blog> blogs = [];

  // My Blogs data
  List<Map<String, String>> myBlogs = [
    {"content": "My first blog post."},
    {"content": "Another blog I wrote."},
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch blogs from the backend when the screen is loaded
    fetchBlogs();
  }

  // Function to fetch blogs from backend API
  Future<void> fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/blogs'));

      if (response.statusCode == 200) {
        // If the server returns a successful response, parse the JSON
        List<dynamic> blogJson = json.decode(response.body);
        setState(() {
          blogs = blogJson.map((json) => Blog.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load blogs');
      }
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Tabs for Blogs and My Blogs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 0;
                }),
                child: Column(
                  children: [
                    Text(
                      "BLOGS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (selectedIndex == 0)
                      Container(
                        height: 8,
                        width: 60,
                        color: Colors.blue,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 1;
                }),
                child: Column(
                  children: [
                    Text(
                      "My BLOGS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (selectedIndex == 1)
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.blue,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          // Content based on selected tab
          Expanded(
            child: selectedIndex == 0 ? _buildBlogsSection() : _buildMyBlogsSection(),
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _addNewBlog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // Display the Blogs section from the backend
  Widget _buildBlogsSection() {
  return ListView.builder(
    itemCount: blogs.length,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        elevation: 6, // Slightly higher elevation for shadow effect
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author info with avatar and name
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent, // Placeholder color for the avatar
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white), // Add icon in the avatar
                  ),
                  const SizedBox(width: 12),
                  Text(
                    blogs[index].username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87, // Darker color for text
                    ),
                  ),
                  const Spacer(),
                  // A small indicator of blog post date, you can adjust if you want
                  Text(
                    "1 hour ago", // Replace with actual time info if needed
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Blog title with more visual emphasis
              Text(
                blogs[index].title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Title color
                ),
              ),
              const SizedBox(height: 8),

              // Blog content with a content widget (collapsed to 5 lines initially)
              BlogContentWidget(content: blogs[index].content),
              const SizedBox(height: 10),

              // Footer with interactive icons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildIconWithCount(Icons.favorite_border, 12), // Replace 12 with dynamic count
                  const SizedBox(width: 16),
                  _buildIconWithCount(Icons.comment_outlined, 5), // Replace 5 with dynamic count
                  const SizedBox(width: 16),
                  _buildIconWithCount(Icons.share, 3), // Replace 3 with dynamic count
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Custom widget to build icon buttons with counts
Widget _buildIconWithCount(IconData icon, int count) {
  return Row(
    children: [
      Icon(icon, color: Colors.grey),
      const SizedBox(width: 4),
      Text(
        '$count',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ],
  );
}


  // My Blogs section
  Widget _buildMyBlogsSection() {
  return ListView.builder(
    itemCount: myBlogs.length,
    itemBuilder: (context, index) {
      final TextEditingController controller = TextEditingController(text: myBlogs[index]['content']);
      bool isEditing = false;
      bool isExpanded = false; // Track whether the blog content is expanded

      return StatefulBuilder(
        builder: (context, setInnerState) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            shadowColor: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog Title
                  Text(
                    "My Blog Title", // Placeholder, you can customize it as per your data
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Show only 5 lines initially, and expand if needed
                  isEditing
                      ? TextField(
                          controller: controller,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Edit your blog content...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              myBlogs[index]['content'] = value;
                            });
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpanded
                                  ? myBlogs[index]['content']!
                                  : (myBlogs[index]['content']!.length > 100
                                      ? myBlogs[index]['content']!.substring(0, 100) + "..."
                                      : myBlogs[index]['content']!),
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            if (myBlogs[index]['content']!.length > 100)
                              GestureDetector(
                                onTap: () {
                                  setInnerState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? "View Less" : "View More",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),

                  const SizedBox(height: 15),
                  
                  // Action Buttons (Edit, Delete)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(isEditing ? Icons.check_circle : Icons.edit, color: Colors.green),
                        onPressed: () {
                          setInnerState(() {
                            isEditing = !isEditing;
                            if (!isEditing) {
                              setState(() {
                                myBlogs[index]['content'] = controller.text;
                              });
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            myBlogs.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  // Function to add a new blog and upload it to the backend
  void _addNewBlog() {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add New Blog", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Blog Title Field
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Blog Title",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Blog Content Field
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: "Blog Content",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.red)),
          ),

          // Add Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Button color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                // Call the function to upload the blog to the backend
                await _uploadBlogToBackend(
                  title: titleController.text,
                  content: contentController.text,
                );

                // Refresh the blogs list after uploading
                fetchBlogs();

                // Close the dialog
                Navigator.pop(context);
              } else {
                // Show error message if validation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill in both title and content")),
                );
              }
            },
            child: const Text("Add Blog", style: TextStyle(fontSize: 16,color: Colors.white)),
          ),
        ],
      );
    },
  );
}


  // Function to upload the blog to the backend
  Future<void> _uploadBlogToBackend({
    required String title,
    required String content,
  }) async {
    try {
      // Replace 'userId' with the actual user ID (you can get it from your auth system)
      const String userId = "current_user_id"; // Replace with dynamic user ID

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'title': title,
        'userId': userId,
        'content': content,
      };

      // Make the POST request to the backend
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/blogs'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Check the response status
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload blog: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading blog: $e')),
      );
    }
  }
}

// BlogContentWidget that handles truncating and expanding the content
class BlogContentWidget extends StatefulWidget {
  final String content;

  const BlogContentWidget({super.key, required this.content});

  @override
  _BlogContentWidgetState createState() => _BlogContentWidgetState();
}

class _BlogContentWidgetState extends State<BlogContentWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final contentText = widget.content;
    final displayText = _isExpanded ? contentText : contentText.length > 100 ? contentText.substring(0, 100) + '...' : contentText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayText),
        if (contentText.length > 100)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'View Less' : 'View More',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
