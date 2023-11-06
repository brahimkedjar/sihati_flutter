import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen2 extends StatefulWidget {
  final String doctorAddress;

  const MapScreen2({Key? key, required this.doctorAddress}) : super(key: key);

  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  late GoogleMapController _controller;
  LatLng? _doctorLocation;

  @override
  void initState() {
    super.initState();
    _getDoctorLocation();
  }

  void _getDoctorLocation() async {
    List<Location> locations = await locationFromAddress(widget.doctorAddress);
    setState(() {
      _doctorLocation =
          LatLng(locations.first.latitude, locations.first.longitude);
    });
    _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _doctorLocation!,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(36.5, 4.5),
          zoom: 9,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _doctorLocation == null
            ? Set<Marker>()
            : Set<Marker>.of([
                Marker(
                  markerId: MarkerId('Doctor'),
                  position: _doctorLocation!,
                ),
              ]),
      ),
    );
  }
}
