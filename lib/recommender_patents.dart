// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart' as mpstk;

class DoctorRecommendationForm extends StatefulWidget {
  @override
  _DoctorRecommendationFormState createState() =>
      _DoctorRecommendationFormState();
}

class _DoctorRecommendationFormState extends State<DoctorRecommendationForm> {
  String userSpeciality = 'Cardiologist';
  bool userUrgent = false;
  int userMaxDate = 29;
  int userMaxDistance = 99;
  double userLatitude = 36.7296512;
  double userLongitude = 3.0862456;
  List<dynamic> doctorsData = []; // List to store the decoded data
  Set<Marker> markers = {};
  Set<Circle> circles = {}; // Add circles set
  GoogleMapController? _mapController;

  void _submitForm() {
    Map<String, dynamic> data = {
      'user_urgent': userUrgent,
      'speciality': userSpeciality,
      'max_date': userMaxDate,
      'max_distance': userMaxDistance,
      'latitude': userLatitude,
      'longitude': userLongitude
    };
    String jsonData = jsonEncode(data);

    Uri url = Uri.parse('http://localhost:5003/filter_doctors');
    http.post(url, body: jsonData).then((response) async {
      print('Response: ${response.body}');
      try {
        Map<String, dynamic> decodedResponse = json.decode(response.body);
        List<dynamic> decodedData = decodedResponse['filtered_doctors'];
        setState(() {
          doctorsData = decodedData;
        });
      } catch (e) {
        print('Error decoding response: $e');
      }
    }).catchError((error) {
      print('Error sending request: $error');
    });
  }

  void _openMaps() async {
    // Get your current location
    Location location = Location();
    LocationData? currentLocation;
    try {
      currentLocation = await location.getLocation();
      userLatitude = currentLocation.latitude!;
      userLongitude = currentLocation.longitude!;
    } catch (e) {
      print('Error getting location: $e');
    }

    String query = doctorsData
        .map((doctor) =>
            "${doctor['latitude']},${doctor['longitude']},${doctor['name']}")
        .join("|");

    markers = doctorsData.map((doctor) {
      double lat = doctor['latitude'];
      double lon = doctor['longitude'];
      String name = doctor['name'];
      LatLng latLng = LatLng(lat, lon);

      // Calculate distance between your position and doctor's position
      double? distanceInMeters = 0.0;
      if (currentLocation != null) {
        mpstk.LatLng startCoords =
            mpstk.LatLng(currentLocation.latitude!, currentLocation.longitude!);
        mpstk.LatLng endCoords = mpstk.LatLng(lat, lon);
        distanceInMeters =
            mpstk.SphericalUtil.computeDistanceBetween(startCoords, endCoords)
                as double?;
      }

      // Add a circle to the circles set
      circles.add(
        Circle(
          circleId: CircleId(name),
          center: latLng,
          radius: 500,
          fillColor: Colors.red.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.red,
        ),
      );

      return Marker(
        markerId: MarkerId(name),
        position: latLng,
        infoWindow: InfoWindow(
          title:
              '$name\nDistance: ${(distanceInMeters! / 1000).toStringAsFixed(2)} km',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();

    if (doctorsData.isNotEmpty) {
      LatLng firstDoctorPosition = LatLng(
        doctorsData[0]['latitude'],
        doctorsData[0]['longitude'],
      );
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
        firstDoctorPosition,
        11.0,
      );
      _mapController?.animateCamera(cameraUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Recommendation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  userSpeciality = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Speciality'),
            ),
            Slider(
              onChanged: (value) {
                setState(() {
                  userMaxDate = value.toInt();
                });
              },
              value: userMaxDate.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: userMaxDate.toString(),
            ),
            Text('Max Date: $userMaxDate days'),
            Slider(
              onChanged: (value) {
                setState(() {
                  userMaxDistance = value.toInt();
                });
              },
              value: userMaxDistance.toDouble(),
              min: 1,
              max: 10000,
              divisions: 99,
              label: userMaxDistance.toString(),
            ),
            Text('Max Distance: $userMaxDistance km'),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: doctorsData.length,
                itemBuilder: (BuildContext context, int index) {
                  return DoctorCard(doctorsData[index]);
                },
              ),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(userLatitude, userLongitude),
                  zoom: 15.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                markers: markers,
                circles: circles, // Add circles to the map
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openMaps,
        child: const Icon(Icons.map),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final dynamic doctorData;

  DoctorCard(this.doctorData);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: [
          Text('Doctor Name: ${doctorData['name']}'),
          Text('Speciality: ${doctorData['speciality']}'),
          Text('distance: ${doctorData['distance']} km'),
          Text('Availability_date: ${doctorData['availability_date']}'),
          // Add more widgets to display other doctor data as needed
        ],
      ),
    );
  }
}
