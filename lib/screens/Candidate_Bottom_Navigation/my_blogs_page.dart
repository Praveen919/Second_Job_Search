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
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue, // Placeholder color
                    ),
                    const SizedBox(width: 10),
                    Text(
                      blogs[index].username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(blogs[index].content),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.favorite_border),
                    SizedBox(width: 10),
                    Icon(Icons.comment_outlined),
                    SizedBox(width: 10),
                    Icon(Icons.share),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // My Blogs section
  Widget _buildMyBlogsSection() {
    return ListView.builder(
      itemCount: myBlogs.length,
      itemBuilder: (context, index) {
        final TextEditingController controller = TextEditingController(text: myBlogs[index]['content']);
        bool isEditing = false;

        return StatefulBuilder(
          builder: (context, setInnerState) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isEditing
                        ? TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          myBlogs[index]['content'] = value;
                        });
                      },
                    )
                        : Text(
                      myBlogs[index]['content']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.favorite_border),
                        SizedBox(width: 10),
                        Icon(Icons.comment_outlined),
                        SizedBox(width: 10),
                        Icon(Icons.share),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(isEditing ? Icons.check : Icons.edit),
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
                          icon: const Icon(Icons.delete),
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Blog"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Blog Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Blog Content"),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill in both title and content"),
                    ),
                  );
                }
              },
              child: const Text("Add"),
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
