// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  Future<void> _onSearchSubmitted(String query) async {
    try {
      final locations = await locationFromAddress(query);
      final location = locations.first;
      final marker = Marker(
        markerId: MarkerId(location.toString()),
        position: LatLng(location.latitude, location.longitude),
      );
      setState(() {
        _selectedLocation = LatLng(location.latitude, location.longitude);
        _markers.clear();
        _markers.add(marker);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(marker.position));
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Could not find a location matching your search.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _onMapTap(LatLng location) {
    final marker = Marker(
      markerId: MarkerId(location.toString()),
      position: LatLng(location.latitude, location.longitude),
    );
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(marker);
      // Set the text of the search controller to the address of the tapped location
      _searchController.text = location.toString();
    });
  }

  Future<void> _selectLocation(BuildContext context) async {
    if (_selectedLocation == null) {
      // No location selected, show an error message.
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select a location on the map.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }

    // Return the selected location to the previous screen using Navigator.pop
    Navigator.pop(context, _selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'chercher ici votre cabinet',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
          ),
          onSubmitted: _onSearchSubmitted,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _selectLocation(context),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onMapTap,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }
}
