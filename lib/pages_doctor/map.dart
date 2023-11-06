// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleMapPage extends StatefulWidget {
  final Set<Marker> markers;

  const GoogleMapPage({super.key, required this.markers});

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng centerPoint = const LatLng(
      0.0, 0.0); // Variable to store the center point of all patients
  double radius = 0.0; // Variable to store the radius of the circle
  LatLng currentUserLocation =
      const LatLng(0.0, 0.0); // Variable to store current user location
  final Set<Marker> _patientMarkers = {}; // Set to store patient markers
// Variable to store selected patient's location
  String _distanceToPatient =
      ''; // Variable to store distance to selected patient
  MarkerId? _selectedMarkerId; // Variable to store the selected marker's ID
  final Map<String, List<LatLng>> _groupedPatients = {};
  final Set<Circle> _circles = {};

  set _circlesSet(Set<Circle> circlesSet) {}
  set _markersSet(Set<Marker> markersSet) {} // Set to store circles

  @override
  void initState() {
    super.initState();
    _calculateCenterPointAndRadius(); // Calculate center point and radius when the widget is initialized
    _getCurrentUserLocation(); // Get current user location from SharedPreferences
    _createPatientMarkers(); // Create patient markers from the given markers
  }

// Helper method to get color for each group

// Helper method to calculate distance between two coordinates
  double calculateDistancegroup(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Helper method to calculate distance between two points using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radiusOfEarth = 6371.0; // Radius of Earth in km
    double lat1Rad = math.pi * lat1 / 180.0;
    double lon1Rad = math.pi * lon1 / 180.0;
    double lat2Rad = math.pi * lat2 / 180.0;
    double lon2Rad = math.pi * lon2 / 180.0;

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) * math.pow(math.sin(dLon / 2), 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = radiusOfEarth * c;
    return distance;
  }

  // Helper method to get the current user location from SharedPreferences
  void _getCurrentUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    if (latitude != null && longitude != null) {
      setState(() {
        currentUserLocation = LatLng(latitude, longitude);
        _patientMarkers.add(
          Marker(
            markerId: const MarkerId('currentUser'),
            position: currentUserLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(
              title: 'Current User Location',
            ),
          ),
        );
      });
    }
  }

  // Helper method to create patient markers from the given markers
  void _createPatientMarkers() {
    for (var marker in widget.markers) {
      String groupId = marker.infoWindow.snippet!;
      LatLng location = marker.position;
      _patientMarkers.add(Marker(
        markerId: marker.markerId,
        position: location,
        infoWindow: InfoWindow(
          title: marker.infoWindow.title,
          snippet: 'Group : $groupId',
        ),
        onTap: () {
          _setSelectedPatient(marker);
        },
      ));
      if (_groupedPatients.containsKey(groupId)) {
        _groupedPatients[groupId]!.add(location);
      } else {
        _groupedPatients[groupId] = [location];
      }
    }
  }

  // Helper method to set the selected patient and update distance
  void _setSelectedPatient(Marker marker) {
    setState(() {
      _selectedMarkerId = marker.markerId;
      _distanceToPatient = calculateDistance(
        currentUserLocation.latitude,
        currentUserLocation.longitude,
        marker.position.latitude,
        marker.position.longitude,
      ).toStringAsFixed(2);
    });
  }

  double? userLatitude = 36.9419141;
  double? userLongitude = 4.2474758;

  void _calculateCenterPointAndRadius() {
    double sumLatitude = 0.0;
    double sumLongitude = 0.0;
    double maxDistance = 0.0;
    Map<int, List<LatLng>> groupPositions = {};

    // Define a list of colors to use for the circles
    List<Color> circleColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.grey,
    ];

    // Define a set to hold the markers
    Set<Marker> markers = {};

    // Loop through all the markers to calculate the center point, max distance, and group positions
    for (var marker in widget.markers) {
      sumLatitude += marker.position.latitude;
      sumLongitude += marker.position.longitude;

      double distance = calculateDistance(
        currentUserLocation.latitude,
        currentUserLocation.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance > maxDistance) {
        maxDistance = distance;
      }

      int groupId = int.parse(marker.infoWindow.snippet.toString());
      if (!groupPositions.containsKey(groupId)) {
        groupPositions[groupId] = [];
      }
      groupPositions[groupId]?.add(marker.position);

      // Add the marker to the set
      markers.add(marker);
    }

    double avgLatitude = sumLatitude / widget.markers.length;
    double avgLongitude = sumLongitude / widget.markers.length;
    centerPoint = LatLng(avgLatitude, avgLongitude);

    // Calculate the mean distance between patients in each group
    double totalGroupDistance = 0.0;
    int numGroups = 0;
    int colorIndex = 0; // Track the index of the current color in the list
    for (var groupId in groupPositions.keys) {
      List<LatLng> groupPositionsList = groupPositions[groupId]!;
      if (groupPositionsList.length > 1) {
        double groupSumDistance = 0.0;
        int numPatients = groupPositionsList.length;
        for (int i = 0; i < numPatients; i++) {
          LatLng patient1 = groupPositionsList[i];
          for (int j = i + 1; j < numPatients; j++) {
            LatLng patient2 = groupPositionsList[j];
            double distance = calculateDistance(
              patient1.latitude,
              patient1.longitude,
              patient2.latitude,
              patient2.longitude,
            );
            groupSumDistance += distance;
          }
        }
        double meanGroupDistance =
            groupSumDistance / (numPatients * (numPatients - 1) / 2);
        totalGroupDistance += meanGroupDistance;
        numGroups++;

        // Add the circle for this group with a unique color
        _circles.add(Circle(
          circleId: CircleId('group$groupId'),
          center: groupPositionsList[0],
          radius: meanGroupDistance * 1000, // Convert km to meters
          fillColor: circleColors[colorIndex].withOpacity(0.5),
          strokeColor: circleColors[colorIndex],
          strokeWidth: 2,
        ));

        // Add a marker for this group with the same color as the circle
        markers.add(Marker(
          markerId: MarkerId('group$groupId'),
          position: groupPositionsList[0],
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          infoWindow: InfoWindow(
            title: 'Group $groupId',
            snippet: '${groupPositionsList.length} patients',
          ),
        ));
        colorIndex = (colorIndex + 1) %
            circleColors.length; // Move to the next color in the list
      }
    }

// Calculate the mean distance between all patients
    double meanDistance = totalGroupDistance / numGroups;

// Calculate the radius of the circle for all patients
    radius = maxDistance + meanDistance;

// Add a marker for the user's current location
    markers.add(Marker(
      markerId: const MarkerId('currentUser'),
      position: currentUserLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(
        title: 'Current Location',
        snippet: 'You are here',
      ),
    ));

// Set the state to rebuild the map with the new markers and circles
    setState(() {
      _markersSet = markers;
      _circlesSet = _circles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Page'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            circles: _circles,
            markers: _patientMarkers,
            initialCameraPosition: CameraPosition(
              target: centerPoint,
              zoom: 6,
            ),
            onMapCreated: (GoogleMapController controller) {},
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      (_selectedMarkerId != null &&
                              _patientMarkers.any((marker) =>
                                  marker.markerId == _selectedMarkerId))
                          ? _patientMarkers
                              .firstWhere((marker) =>
                                  marker.markerId == _selectedMarkerId)
                              .infoWindow
                              .title!
                          : '',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'éloignement de malde : $_distanceToPatient km',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
