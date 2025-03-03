import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyContactScreen extends StatefulWidget {
  const CompanyContactScreen({super.key, required this.userId});
  final String userId;



  @override
  State<CompanyContactScreen> createState() => _CompanyContactScreenState();
}

class _CompanyContactScreenState extends State<CompanyContactScreen> {
  String selectedCountry = "";
  String selectedState = "";
  String selectedCity = "";

  final Map<String, String> contactInfo = {
    'Complete Address': '',
    'Latitude': '',
    'Longitude': '',
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserData();  // 🔥 Ensure latest data is fetched
    });
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("🔹 Fetching Data on Contact Screen:");
    print("Before Fetch - Address: ${prefs.getString("companyAddress")}");
    print("Before Fetch - Latitude: ${prefs.getString("latitude")}");
    print("Before Fetch - Longitude: ${prefs.getString("longitude")}");
    print("Before Fetch - Country: ${prefs.getString("country")}");
    print("Before Fetch - State: ${prefs.getString("state")}");
    print("Before Fetch - City: ${prefs.getString("city")}");

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/users/details/${prefs.getString("userId")}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("🔹 API Response: $data");

        // ✅ Ensure all fields update correctly in SharedPreferences
        await prefs.setString("companyAddress", data["companyAddress"] ?? '');
        await prefs.setString("latitude", data["latitude"] ?? '');
        await prefs.setString("longitude", data["longitude"] ?? '');
        await prefs.setString("country", data["country"] ?? '');
        await prefs.setString("state", data["state"] ?? '');  // ✅ Added state
        await prefs.setString("city", data["city"] ?? '');    // ✅ Added city
        await prefs.setString("email", data["email"] ?? '');
        await prefs.setString("mobileNumber", data["mobileNumber"] ?? '');

        setState(() {
          contactInfo['Complete Address'] = prefs.getString("companyAddress") ?? '';
          contactInfo['Latitude'] = prefs.getString("latitude") ?? '';
          contactInfo['Longitude'] = prefs.getString("longitude") ?? '';
          selectedCountry = prefs.getString("country") ?? '';
          selectedState = prefs.getString("state") ?? '';   // ✅ Ensure state gets updated
          selectedCity = prefs.getString("city") ?? '';     // ✅ Ensure city gets updated
          isLoading = false;
        });

        print("🔹 After Fetch - Address: ${prefs.getString("companyAddress")}");
        print("🔹 After Fetch - Latitude: ${prefs.getString("latitude")}");
        print("🔹 After Fetch - Longitude: ${prefs.getString("longitude")}");
        print("🔹 After Fetch - Country: ${prefs.getString("country")}");
        print("🔹 After Fetch - State: ${prefs.getString("state")}");
        print("🔹 After Fetch - City: ${prefs.getString("city")}");
        print("🔹 After Fetch - Email: ${prefs.getString("email")}");
        print("🔹 After Fetch - MobileNumber: ${prefs.getString("mobileNumber")}");

      } else {
        print('❌ Failed to load company data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load company data');
      }
    } catch (e) {
      print('❌ Error in fetchUserData: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading company data: $e')),
      );
    }
  }



  Future<void> _updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final mobile1 = prefs.getString("mobile1") ?? prefs.getString("mobileNumber");

    print('Email from SharedPreferences: $email');
    print('Mobile1 from SharedPreferences: $mobile1');

    if (email == null || mobile1 == null || email.isEmpty || mobile1.isEmpty) {
      print('❌ Email or mobile1 is missing');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email or mobile number is missing")),
      );
      return;
    }

    // ✅ Ensure selected values are correct before sending API request
    print("🔹 Current Selected Country: $selectedCountry");
    print("🔹 Current Selected State: $selectedState");
    print("🔹 Current Selected City: $selectedCity");

    final apiUrl = '${AppConfig.baseUrl}/api/users/update-data-contact/${prefs.getString("userId")}';

    final body = {
      "companyAddress": contactInfo['Complete Address'],
      "latitude": contactInfo['Latitude'],
      "longitude": contactInfo['Longitude'],
      "country": selectedCountry,  // ✅ Added country
      "state": selectedState,      // ✅ Added state
      "city": selectedCity,        // ✅ Added city
      "email": email,
      "mobileNumber": mobile1,
    };

    print("🔹 Corrected Request Body: $body"); // ✅ Debugging

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ Contact details updated successfully');

        final updatedData = jsonDecode(response.body);

        // ✅ Ensure all fields update in SharedPreferences
        await prefs.setString("companyAddress", updatedData["companyAddress"] ?? '');
        await prefs.setString("latitude", updatedData["latitude"] ?? '');
        await prefs.setString("longitude", updatedData["longitude"] ?? '');
        await prefs.setString("country", updatedData["country"] ?? '');
        await prefs.setString("state", updatedData["state"] ?? '');  // ✅ Update state
        await prefs.setString("city", updatedData["city"] ?? '');    // ✅ Update city
        await prefs.setString("email", updatedData["email"] ?? '');
        await prefs.setString("mobileNumber", updatedData["mobileNumber"] ?? '');

        print("✅ SharedPreferences updated after API call");

        // ✅ Fetch updated data again
        await fetchUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contact details updated successfully")),
        );
      }
      else {
        print('❌ Failed to update contact details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error in _updateUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
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
            onPressed: _updateUserData,
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",
                      countryDropdownLabel: "Country",
                      stateDropdownLabel: "State",
                      cityDropdownLabel: "City",
                      currentCountry: selectedCountry, // Set initial country value
                      currentState: selectedState, // Set initial state value
                      currentCity: selectedCity, // Set initial city value
                      onCountryChanged: (value) {
                        setState(() {
                          selectedCountry = value ?? "";
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
                      width: MediaQuery.of(context).size.width - 40,
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
          width: 150,
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
