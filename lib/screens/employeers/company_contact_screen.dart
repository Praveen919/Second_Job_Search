import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';

class CompanyContactScreen extends StatefulWidget {
  const CompanyContactScreen({super.key});

  @override
  State<CompanyContactScreen> createState() => _CompanyContactScreenState();
}

class _CompanyContactScreenState extends State<CompanyContactScreen> {
  String selectedCountry = "";
  String selectedState = "";
  String selectedCity = "";

  final Map<String, String> contactInfo = {
    'Complete Address': '1234 Street Name, City, Country',
    'Latitude': '40.7128',
    'Longitude': '-74.0060',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFDBFE),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: const Text(
          'Company Contact',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle Done action
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CSCPicker(
                      layout: Layout.vertical,
                      onCountryChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          selectedState = value ?? "";
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          selectedCity = value ?? "";
                        });
                      },
                    ),
                    const Divider(),
                    ...contactInfo.keys.map((key) => Column(
                          children: [
                            _buildEditableRow(
                              label: key,
                              value: contactInfo[key]!,
                              onChanged: (newValue) {
                                setState(() {
                                  contactInfo[key] = newValue;
                                });
                              },
                            ),
                            const Divider(),
                          ],
                        )),
                    const SizedBox(height: 10),
                    const Text(
                      'Complete Address:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${contactInfo['Complete Address']}\n$selectedCity, $selectedState, $selectedCountry',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width -
                          40, // 20px margin on both sides
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic to open map or find location can be added here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Find on Map',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add navigation logic to the next page if required
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _buildEditableRow({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            initialValue: value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }
}
