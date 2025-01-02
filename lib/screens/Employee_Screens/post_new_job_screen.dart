import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:second_job_search/screens/notifications_screen.dart';

class EmplpoyeerNewJob extends StatelessWidget {
  const EmplpoyeerNewJob({super.key});

  // Reusable Container Widget for Job Info
  Widget _buildInfoContainer({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
    required double containerWidth,
    required Color backgroundColor,
  }) {
    return Container(
      width: containerWidth,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: iconColor,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Plan Detail Widget
  Widget _buildPlanDetails({
    required String planName,
    required String remainingJobs,
    required String remainingFreeJobs,
    required String remainingDays,
    required String expiryDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Expires on: $expiryDate',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleWithLabel(remainingJobs, 'Paid Jobs'),
              _buildCircleWithLabel(remainingFreeJobs, 'Free Jobs'),
              _buildCircleWithLabel(remainingDays, 'Days Left'),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable circle with number and label widget
  Widget _buildCircleWithLabel(String number, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Job Posting',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Text(
                'Post a New Job!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 5, 64, 146),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.work_outline_rounded,
                      count: '1',
                      label: 'Paid Jobs',
                      iconColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 169, 210, 230),
                      containerWidth: screenWidth * 0.45,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.work_outline_rounded,
                      count: '0',
                      label: 'Free Jobs',
                      iconColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 179, 233, 182),
                      containerWidth: screenWidth * 0.45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.work_outline_rounded,
                      count: '0',
                      label: 'Jobs Posted',
                      iconColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 224, 189, 137),
                      containerWidth: screenWidth * 0.45,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.bookmark_outline,
                      count: '0',
                      label: 'Shortlist',
                      iconColor: Colors.black,
                      backgroundColor: Colors.pink[200]!,
                      containerWidth: screenWidth * 0.45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Plan Details Section
              _buildPlanDetails(
                planName: 'Premium Plan',
                remainingJobs: '5',
                remainingFreeJobs: '10',
                remainingDays: '20',
                expiryDate: '2025-01-31', // Example expiry date
              ),
              const SizedBox(height: 20),
              // Navigate to PostNewJobScreen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostNewJobScreen()),
                  );
                },
                child: const Text('Post New Job'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostNewJobScreen extends StatefulWidget {
  const PostNewJobScreen({super.key});

  @override
  _PostNewJobScreenState createState() => _PostNewJobScreenState();
}

class _PostNewJobScreenState extends State<PostNewJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String _jobTitle = '';
  String _jobDescription = '';
  String _salary = '';
  String _jobType = 'Paid'; // Default to Paid Job

  // Function to handle form submission
  void _submitJob() {
    if (_formKey.currentState?.validate() ?? false) {
      // Here, you can perform your job post action (e.g., API call)
      print('Job Title: $_jobTitle');
      print('Description: $_jobDescription');
      print('Salary: $_salary');
      print('Job Type: $_jobType');
      // Clear the form after submitting
      _formKey.currentState?.reset();
    }
  }

  // Job Type Dropdown
  Widget _buildJobTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _jobType,
      onChanged: (String? newValue) {
        setState(() {
          _jobType = newValue!;
        });
      },
      items: ['Paid', 'Free'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Job Type',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Post a New Job',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post a New Job!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              // Job Title Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _jobTitle = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Job Description Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _jobDescription = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job description';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Salary Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Salary (in \$)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _salary = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a salary';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Job Type Dropdown
              _buildJobTypeDropdown(),
              const SizedBox(height: 20),

              // Buttons for posting the job
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Post Free Job
                          setState(() {
                            _jobType = 'Free';
                          });
                          _submitJob();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Post Free Job'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Post Paid Job
                          setState(() {
                            _jobType = 'Paid';
                          });
                          _submitJob();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text('Post Paid Job'),
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
