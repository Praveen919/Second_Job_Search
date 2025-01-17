import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To handle JSON
import 'package:second_job_search/Config/config.dart';

// Blog model class
class Blog {
  final String title;
  final String username;
  final String content;
  final String image;

  Blog({
    required this.title,
    required this.username,
    required this.content,
    required this.image,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'] ?? 'No Title', // Fallback value if title is null
      username: json['username'] ?? 'Anonymous', // Fallback value if username is null
      content: json['content'] ?? 'No Content', // Fallback value if content is null
      image: json['image'] ?? 'https://via.placeholder.com/150', // Fallback value for image URL
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
    {
      "content": "My first blog post.",
      "image": "https://via.placeholder.com/150"
    },
    {
      "content": "Another blog I wrote.",
      "image": "https://via.placeholder.com/150"
    },
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
                      backgroundImage: NetworkImage(blogs[index].image),
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
                Image.network(
                  blogs[index].image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
        final TextEditingController controller =
        TextEditingController(text: myBlogs[index]['content']);
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
                    Image.network(
                      myBlogs[index]['image']!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
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

  // Function to add new blog
  void _addNewBlog() {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Blog"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Blog Content"),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
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
              onPressed: () {
                if (contentController.text.isNotEmpty &&
                    imageController.text.isNotEmpty) {
                  setState(() {
                    myBlogs.add({
                      "content": contentController.text,
                      "image": imageController.text,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
