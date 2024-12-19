import 'package:flutter/material.dart';

class MyBlogsPageScreen extends StatefulWidget {
  const MyBlogsPageScreen({super.key});

  @override
  State<MyBlogsPageScreen> createState() => _MyBlogsPageScreenState();
}

class _MyBlogsPageScreenState extends State<MyBlogsPageScreen> {
  final List<Map<String, String>> blogs = [
    {
      "username": "Ruffles",
      "content": "This is a blog post from another user.",
      "image": "https://via.placeholder.com/150"
    },
    {
      "username": "John",
      "content": "Another user's blog content here.",
      "image": "https://via.placeholder.com/150"
    },
  ];

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
                      backgroundImage: NetworkImage(blogs[index]['image']!),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      blogs[index]['username']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(blogs[index]['content']!),
                const SizedBox(height: 10),
                Image.network(
                  blogs[index]['image']!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
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

  Widget _buildMyBlogsSection() {
    return ListView.builder(
      itemCount: myBlogs.length,
      itemBuilder: (context, index) {
        final TextEditingController _controller =
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
                      controller: _controller,
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
                                  myBlogs[index]['content'] = _controller.text;
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
