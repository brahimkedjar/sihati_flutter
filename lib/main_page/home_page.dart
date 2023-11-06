// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../login_users/login_doctor.dart';
import '../login_users/login_patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  bool _locationPermissionGranted = false;

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.best);

      setState(() {
        _locationPermissionGranted = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', position.latitude);
      prefs.setDouble('longitude', position.longitude);
      print(position);
    } catch (e) {
      if (e is PermissionDeniedException) {
        _showPermissionDialog();
      } else {
        print('Error getting location: $e');
      }
    }
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Request"),
          content:
              Text("Please grant location permission to use this feature."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Open Settings"),
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 246, 255, 1.0),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Container(
              height: 300,
              width: 300,
              padding:
                  EdgeInsets.all(16.0), // add 16 pixels of padding on all sides
              //margin: EdgeInsets.symmetric(vertical: 5.0),

              child: Image.asset("assets/images/samy.png"),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.6,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      "Continuer comme un : ",
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Color.fromRGBO(99, 141, 194, 1.0),
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            margin: EdgeInsets.fromLTRB(0, 16, 8, 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: const Color.fromRGBO(101, 207, 253, 1.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 10, 0, 2),
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Image.asset("assets/images/p1.png"),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Patient',
                                  style: TextStyle(
                                    fontFamily: 'SourceSansPro',
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginForm()),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.42,
                            margin: EdgeInsets.fromLTRB(8, 16, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: const Color.fromRGBO(112, 165, 215, 1.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Image.asset("assets/images/p8.png"),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Medecin',
                                  style: TextStyle(
                                    fontFamily: 'SourceSansPro',
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
