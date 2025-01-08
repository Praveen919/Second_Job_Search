import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CompanyContactScreen extends StatefulWidget {
  const CompanyContactScreen({super.key});

  @override
  State<CompanyContactScreen> createState() => _CompanyContactScreenState();
}

class _CompanyContactScreenState extends State<CompanyContactScreen> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  LatLng _currentPosition = const LatLng(20.5937, 78.9629); // Default position
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _findOnMap() async {
    try {
      String address = _addressController.text;
      if (address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an address')),
        );
        return;
      }

      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;

        setState(() {
          _latitudeController.text = location.latitude.toString();
          _longitudeController.text = location.longitude.toString();
          _currentPosition = LatLng(location.latitude, location.longitude);
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition, 14.0),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not find location')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition, 14.0),
    );
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied'),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFDBFE),
        elevation: 0,
        title: const Text(
          'Company Contact',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildEditableRow(
                label: 'Country',
                controller: _countryController,
              ),
              const SizedBox(height: 10),
              _buildEditableRow(
                label: 'City',
                controller: _cityController,
              ),
              const SizedBox(height: 10),
              _buildEditableRow(
                label: 'Complete Address',
                controller: _addressController,
              ),
              const SizedBox(height: 10),
              _buildEditableRow(
                label: 'Latitude (Optional)',
                controller: _latitudeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildEditableRow(
                label: 'Longitude (Optional)',
                controller: _longitudeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _findOnMap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Find on Map'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 5.0,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: _currentPosition,
                    ),
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Use Current Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
            ),
          ),
        ),
      ],
    );
  }
}
