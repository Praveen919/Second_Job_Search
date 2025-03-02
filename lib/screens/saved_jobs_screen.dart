import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_job_search/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  List<dynamic> savedJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedJobs();
  }

  Future<void> fetchSavedJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId == null) {
      print("User not logged in!");
      return;
    }

    final apiUrl = '${AppConfig.baseUrl}/api/users/save-jobs/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          savedJobs = responseData['jobs'] ?? [];  // Ensure we get an array
          isLoading = false;
        });
      } else {
        print("Failed to fetch saved jobs: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching saved jobs: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 155, 238),
        elevation: 0,
        title: const Text(
          'Saved Jobs',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Job',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saved Jobs',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : savedJobs.isEmpty
                  ? const Center(child: Text("No saved jobs found"))
                  : ListView.builder(
                itemCount: savedJobs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: JobCard(job: savedJobs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  final dynamic job;
  final bool isSaved; // Add this to check if the job is already saved

  const JobCard({super.key, required this.job, this.isSaved = false});

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved; // Initialize isSaved from widget
  }

  Future<void> _saveJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId == null) {
      Fluttertoast.showToast(
        msg: "User not logged in!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    const apiUrl = '${AppConfig.baseUrl}/api/users/save-job';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'post_id': widget.job['_id'],
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isSaved = responseData['valid']; // Update isSaved based on response
        });

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to save job",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error saving job: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _removeSavedJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId == null) {
      Fluttertoast.showToast(
        msg: "User not logged in!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    const apiUrl = '${AppConfig.baseUrl}/api/users/remove-saved-job';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'post_id': widget.job['_id'],
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isSaved = !responseData['valid']; // Update isSaved based on response
        });

        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to remove job",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error removing job: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        leading: const Icon(
          Icons.work_outline,
          color: Colors.blue,
          size: 30,
        ),
        title: Text(widget.job['jobTitle'] ?? 'Job Title Not Available'),
        subtitle: Text(widget.job['companyName'] ?? 'Company Name Not Available'),
        trailing: IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? Colors.blue : Colors.grey,
          ),
          onPressed: () {
            if (isSaved) {
              _removeSavedJob();
            } else {
              _saveJob();
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDescriptionPage(job: widget.job),
            ),
          );
        },
      ),
    );
  }
}
