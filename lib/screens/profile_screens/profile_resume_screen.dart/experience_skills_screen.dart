import 'package:flutter/material.dart';
import 'package:second_job_search/screens/profile_screens/profile_resume_screen.dart/profile_links_screen.dart';

class ProfessionalExperienceSkills extends StatefulWidget {
  const ProfessionalExperienceSkills({super.key});

  @override
  State<ProfessionalExperienceSkills> createState() =>
      _ProfessionalExperienceSkillsState();
}

class _ProfessionalExperienceSkillsState
    extends State<ProfessionalExperienceSkills> {
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String selectedSkill = 'India'; // Default skill
  String selectedSkillRating = 'Beginner'; // Default rating
  final List<String> skillRatings = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Professional experience and skills',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              // Edit button logic
            },
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildEditableField('Experience', experienceController),
              _buildEditableField('Start date', startDateController),
              _buildEditableField('End date', endDateController),
              _buildEditableField('Email', emailController),
              _buildEditableField('Job Role', jobRoleController),
              _buildEditableField('Location', locationController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Skills',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add more skills logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add more'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedSkill,
                items: ['India', 'USA', 'UK']
                    .map((skill) => DropdownMenuItem(
                          value: skill,
                          child: Text(skill),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSkill = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Skills',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedSkillRating,
                items: skillRatings
                    .map((rating) => DropdownMenuItem(
                          value: rating,
                          child: Text(rating),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSkillRating = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Skill rating',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 25,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 25,
                    child: ElevatedButton(
                      onPressed: () {
                        // Next page navigation logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileLinksScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Next page'),
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

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }
}
