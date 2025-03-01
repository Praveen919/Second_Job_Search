import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To handle JSON
import 'package:shared_preferences/shared_preferences.dart'; // For userId
import 'package:second_job_search/Config/config.dart'; // Replace with your config file
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


// Function to format the timestamp
String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}

// Blog model class
class Blog {
  final String id;
  final String title;
  final String username;
  final String content;
  final DateTime timestamp;

  Blog({
    required this.id,
    required this.title,
    required this.username,
    required this.content,
    required this.timestamp,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'] ?? '', // Add this line to handle the blog ID
      title: json['title'] ?? 'No Title',
      username: json['username'] ?? 'Anonymous',
      content: json['content'] ?? 'No Content',
      timestamp: DateTime.parse(json['timestamp']), // Parse the timestamp
    );
  }

  // Add a method to create a new Blog instance with updated content
  Blog copyWith({String? title, String? username, String? content, DateTime? timestamp}) {
    return Blog(
      id: this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
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
  List<Blog> myBlogs = [];

  int selectedIndex = 0;

  // Logged-in user's ID
  String? userId;

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load userId from SharedPreferences
  }

  // Load userId from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });

    print("📢 Loaded userId: $userId");

    if (userId != null) {
      fetchBlogs(); // Fetch all blogs
      fetchMyBlogs(); // Fetch user-specific blogs
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'User ID not found. Please log in again.';
      });
    }
  }

  // Function to fetch all blogs (for "Blogs" section)
  Future<void> fetchBlogs() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/blogs'));

      if (response.statusCode == 200) {
        List<dynamic> blogJson = json.decode(response.body);
        setState(() {
          blogs = blogJson.map((json) => Blog.fromJson(json)).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load blogs. Error Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error fetching blogs: $e');
      setState(() {
        errorMessage = 'An error occurred while fetching blogs.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to fetch user-specific blogs (for "My Blogs" section)
  Future<void> fetchMyBlogs() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/blogs/user/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> myBlogsJson = json.decode(response.body);
        setState(() {
          myBlogs = myBlogsJson.map((json) => Blog.fromJson(json)).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load my blogs. Error Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error fetching my blogs: $e');
      setState(() {
        errorMessage = 'An error occurred while fetching your blogs.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to delete a blog
  Future<void> deleteBlog(String blogId) async {
    try {
      final response = await http.delete(Uri.parse('${AppConfig.baseUrl}/api/blogs/$blogId'));

      if (response.statusCode == 200) {
        setState(() {
          myBlogs.removeWhere((blog) => blog.id == blogId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog deleted successfully!')),
        );
      } else {
        throw Exception('Failed to delete blog');
      }
    } catch (e) {
      print('Error deleting blog: $e');
    }
  }

  // Function to update a blog
  // Function to update a blog
  Future<void> updateBlog(String blogId, String updatedContent) async {
    try {
      // Log the blogId and updated content
      print("📢 Updating blog with ID: $blogId");
      print("📢 Updated content: $updatedContent");

      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/api/blogs/$blogId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'content': updatedContent}),
      );

      // Log the response
      print("📢 Response Status Code: ${response.statusCode}");
      print("📢 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          // Find the blog in the list and replace it with a new instance
          final index = myBlogs.indexWhere((blog) => blog.id == blogId);
          if (index != -1) {
            myBlogs[index] = myBlogs[index].copyWith(content: updatedContent);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog updated successfully!')),
        );
      } else {
        throw Exception('Failed to update blog: ${response.body}');
      }
    } catch (e) {
      print('❌ Error updating blog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating blog: $e')),
      );
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (blogs.isEmpty) {
      return const Center(child: Text("No blogs available."));
    }

    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        final formattedTimestamp = formatTimestamp(blog.timestamp); // Format the timestamp

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
                      blog.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87, // Darker color for text
                      ),
                    ),
                    const Spacer(),
                    // Display the formatted timestamp
                    Text(
                      formattedTimestamp, // Use the formatted timestamp
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
                  blog.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Title color
                  ),
                ),
                const SizedBox(height: 8),

                // Blog content with a content widget (collapsed to 5 lines initially)
                BlogContentWidget(content: blog.content),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (myBlogs.isEmpty) {
      return const Center(child: Text("You haven't posted any blogs yet."));
    }

    return ListView.builder(
      itemCount: myBlogs.length,
      itemBuilder: (context, index) {
        final blog = myBlogs[index];
        final formattedTimestamp = formatTimestamp(blog.timestamp); // Format the timestamp
        final TextEditingController controller = TextEditingController(text: blog.content);
        bool isEditing = false;
        bool isExpanded = false;

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
                      blog.title,
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
                        // No need to update the state here
                      },
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpanded
                              ? blog.content
                              : (blog.content.length > 100
                              ? blog.content.substring(0, 100) + "..."
                              : blog.content),
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        if (blog.content.length > 100)
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

                    // Display the formatted timestamp
                    Text(
                      formattedTimestamp, // Use the formatted timestamp
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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
                                // Use copyWith to create a new Blog instance with updated content
                                final updatedBlog = blog.copyWith(content: controller.text);
                                setState(() {
                                  myBlogs[index] = updatedBlog;
                                });
                                updateBlog(blog.id, controller.text);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteBlog(blog.id);
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
                  fetchMyBlogs();

                  // Close the dialog
                  Navigator.pop(context);
                } else {
                  // Show error message if validation fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in both title and content")),
                  );
                }
              },
              child: const Text("Add Blog", style: TextStyle(fontSize: 16, color: Colors.white)),
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
