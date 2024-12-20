import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFBFDBFE),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Hello Shakir, Good Day 👋",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Search & Land on your dream job",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.1),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recommendation",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle "See all" tap
                                },
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.work,
                                      color: Colors.blue.shade400,
                                    ),
                                    title: Text("Job Title ${index + 1}"),
                                    subtitle: const Text("Company Name"),
                                    trailing: const Icon(Icons.arrow_forward),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JobDescriptionPage(
                                            jobTitle: "Job Title ${index + 1}",
                                            companyName: "Company Name",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              iconColor: Colors.lightBlueAccent,
                              labelText: "Search Job",
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 7),
                          const TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.room_outlined),
                              iconColor: Colors.lightBlueAccent,
                              labelText: "Location",
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobDescriptionPage extends StatelessWidget {
  final String jobTitle;
  final String companyName;

  const JobDescriptionPage({
    super.key,
    required this.jobTitle,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.work, size: 50),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      companyName,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildSection("Job Description",
                      "We need a UI Designer who can work for us."),
                  buildSection("Responsibilities",
                      "Work with developers, meet deadlines."),
                  buildSection("Qualifications", "Degree in Design."),
                  buildSection("About the Company",
                      "Soul Tech, an innovative tech company."),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle Apply button tap
              },
              child: const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.grey.shade100,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: title == "Job Description"
                  ? Colors.blue
                  : title == "Responsibilities"
                      ? Colors.green
                      : title == "Qualifications"
                          ? Colors.orange
                          : Colors.black,
            ),
          ),
          subtitle: Text(content),
        ),
      ),
    );
  }
}
