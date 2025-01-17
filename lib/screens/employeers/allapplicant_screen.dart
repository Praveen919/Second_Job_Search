import 'package:flutter/material.dart';

class ApplicantsDashboard extends StatefulWidget {
  const ApplicantsDashboard({super.key});

  @override
  _ApplicantsDashboardState createState() => _ApplicantsDashboardState();
}

class _ApplicantsDashboardState extends State<ApplicantsDashboard> {
  int currentPage = 0;
  final int recordsPerPage = 5;
  final List<Map<String, String>> applicants = List.generate(20, (index) {
    return {
      "name": "Applicant ${index + 1}",
      "job": "Job ${index + 1}",
      "type": index % 2 == 0 ? "Full-Time" : "Part-Time",
      "date": "2023-12-${(index % 30) + 1}",
      "status": index % 2 == 0 ? "Pending" : "Reviewed",
    };
  });

  @override
  Widget build(BuildContext context) {
    final startIndex = currentPage * recordsPerPage;
    final endIndex = startIndex + recordsPerPage;
    final currentApplicants = applicants.sublist(
      startIndex,
      endIndex > applicants.length ? applicants.length : endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Applicants!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Applications Card
            _buildTotalApplicationsCard(),
            const SizedBox(height: 20),

            // My Job Listings Section
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderWithSearch(),
                      const SizedBox(height: 20),
                      _buildTableHeader(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentApplicants.length,
                          itemBuilder: (context, index) {
                            final applicant = currentApplicants[index];
                            return _buildApplicantRow(
                              index + 1 + startIndex,
                              applicant,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPaginationControls(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalApplicationsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.folder, color: Colors.green, size: 50),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${applicants.length}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Total Applications",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderWithSearch() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "My Job Listings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by job title...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: const [
          Expanded(child: Text("Applicant Name", style: _tableHeaderStyle)),
          Expanded(child: Text("Applied For", style: _tableHeaderStyle)),
          Expanded(child: Text("Job Type", style: _tableHeaderStyle)),
          Expanded(child: Text("Date Applied", style: _tableHeaderStyle)),
          Expanded(child: Text("Status", style: _tableHeaderStyle)),
          Expanded(child: Text("Resume", style: _tableHeaderStyle)),
        ],
      ),
    );
  }

  Widget _buildApplicantRow(int index, Map<String, String> applicant) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(applicant["name"]!, style: _tableBodyStyle)),
          Expanded(child: Text(applicant["job"]!, style: _tableBodyStyle)),
          Expanded(child: Text(applicant["type"]!, style: _tableBodyStyle)),
          Expanded(child: Text(applicant["date"]!, style: _tableBodyStyle)),
          Expanded(
              child: Text(
            applicant["status"]!,
            style: _tableBodyStyle.copyWith(
              color: applicant["status"] == "Pending"
                  ? Colors.orange
                  : Colors.green,
            ),
          )),
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: const Text("View", style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentPage > 0)
          TextButton(
            onPressed: () {
              setState(() {
                currentPage--;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Load Previous"),
          ),
        if (currentPage + 1 < (applicants.length / recordsPerPage).ceil())
          TextButton(
            onPressed: () {
              setState(() {
                currentPage++;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Load Next"),
          ),
      ],
    );
  }

  static const TextStyle _tableHeaderStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static const TextStyle _tableBodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );
}
