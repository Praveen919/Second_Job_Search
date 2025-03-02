import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_job_search/Config/config.dart';

class ManageCandidatesScreen extends StatelessWidget {
  const ManageCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        elevation: 0,
        title: const Text(
          'Candidates',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pie Chart Section
              Text(
                'Skillset Analysis',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: showingSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                  ),
                ),
              ),
              // Candidate List Section
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CandidateList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 30,
        title: 'Flutter\n30%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: 'Dart\n20%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 25,
        title: 'JavaScript\n25%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 15,
        title: 'Java\n15%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 10,
        title: 'Python\n10%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}

class CandidateList extends StatefulWidget {
  const CandidateList({super.key});

  @override
  _CandidateListState createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  List<Map<String, dynamic>> candidates = [];
  bool isLoading = true;
  int currentPage = 0;
  final int recordsPerPage = 5;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchJobsAndCandidates();
  }

  Future<void> fetchJobsAndCandidates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("Fetched userId: $userId");
    if (userId == null) {
      print("Error: User ID is null or empty");
      return;
    }
    try {
      final jobResponse = await http.get(Uri.parse('${AppConfig.baseUrl}/api/applied-jobs/get-job-by-userid/$userId'));
      print("API Response Status: ${jobResponse.statusCode}");
      print("API Response Body: ${jobResponse.body}");
      if (jobResponse.statusCode == 200) {
        List<dynamic> jobs = json.decode(jobResponse.body);
        if (jobs.isNotEmpty) {
          for (var job in jobs) {
            String postId = job['_id']?.toString() ?? '';
            if (postId.isEmpty) continue;

            await fetchCandidates(postId);
          }
        }
      }
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  Future<void> fetchCandidates(String postId) async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/applied-jobs/post/$postId'));
      if (response.statusCode == 200) {
        setState(() {
          candidates.addAll(List<Map<String, dynamic>>.from(json.decode(response.body)));
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching candidates: $error');
    }
  }

  void loadMoreCandidates() {
    setState(() {
      if (currentPage + 1 < (candidates.length / recordsPerPage).ceil()) {
        currentPage++;
      }
    });
  }

  Future<void> shortlistCandidate(String candidateId) async {
    if (candidateId.length != 24) { // ✅ MongoDB ObjectId check
      print("Invalid Candidate ID: $candidateId");
      return;
    }

    try {
      print("Shortlisting candidate: $candidateId");
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/applied-jobs/update-job-status/$candidateId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "approve"}), // ✅ Backend expects "approve"
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          candidates = candidates.map((candidate) {
            if (candidate['_id'] == candidateId) {
              candidate['status'] = 'shortlisted';
              print("Candidate ${candidate['_id']} marked as shortlisted!"); // ✅ Debugging
            }
            return candidate;
          }).toList();
        });
        print("Candidate successfully shortlisted!");
      } else {
        print("Error shortlisting candidate: ${response.body}");
      }

    } catch (error) {
      print("Exception while shortlisting candidate: $error");
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter candidates based on search query
    final filteredCandidates = candidates.where((candidate) {
      return candidate['name']?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          candidate['jobTitle']?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          candidate['jobType']?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          candidate['timestamp']?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
    }).toList();

    final startIndex = currentPage * recordsPerPage;
    final endIndex = startIndex + recordsPerPage;
    final candidatesToShow = filteredCandidates.sublist(
      startIndex,
      endIndex > filteredCandidates.length ? filteredCandidates.length : endIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "All Candidates" Header
        Text(
          'All Candidates',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for a candidate...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Candidate Listings
        isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: candidatesToShow.length,
          itemBuilder: (context, index) {
            final candidate = candidatesToShow[index];
            return GestureDetector(
              onTap: () {
                // Navigate to candidate details page
              },
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Candidate Name and Avatar
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/logo.png'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            candidate['name'] ?? 'No Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Job Title and Type
                    Text(
                      'Applied for: ${candidate['jobTitle'] ?? 'No Job Title'}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Job Type: ${candidate['jobType'] ?? 'No Job Type'}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Date Applied and Status
                    Text(
                      'Date Applied: ${candidate['timestamp'] ?? 'No Date'}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${candidate['status'] == 0 ? 'Pending' : 'Reviewed'}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: candidate['status'] == 0 ? Colors.orange : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // View Resume Button
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality to view resume
                      },
                      child: const Text("View Resume", style: TextStyle(color: Colors.blue)),
                    ),
                    const SizedBox(height: 10),
                    // View Resume Button
                    ElevatedButton(
                      onPressed: () => shortlistCandidate(candidate['_id']),
                      child: Text(candidate['status'] == 'shortlisted' ? "Shortlisted" : "Shortlist"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: candidate['status'] == 'shortlisted' ? Colors.green : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 5),

        // Load More Button Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentPage > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage--;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Load Previous',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04, color: Colors.white),
                ),
              ),
            if (currentPage + 1 < (filteredCandidates.length / recordsPerPage).ceil())
              ElevatedButton(
                onPressed: loadMoreCandidates,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Load More',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04, color: Colors.white),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
