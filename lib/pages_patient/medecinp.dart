// ignore_for_file: avoid_unnecessary_containers, prefer_if_null_operators, use_build_context_synchronously, avoid_print, sort_child_properties_last, unused_element, unnecessary_null_comparison

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rive/rive.dart';
import 'package:sihati/pages_patient/Patient_status.dart';
import 'package:sihati/pages_patient/profile_docp.dart';
import 'package:sihati/pages_patient/doctors_page.dart';
import 'package:sihati/pages_patient/rendezvous.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/mnbtn.dart';
import '../components/rive_utils.dart';
import '../components/sidemenu.dart';

class Doctor {
  final String name;
  final String speciality;
  final String? imageUrl;
  final String email;
  final String phone;
  final String address;

  int? doctorid;

  Doctor(
      {required this.email,
      required this.phone,
      required this.address,
      required this.name,
      required this.speciality,
      required this.imageUrl,
      required this.doctorid});
}

class PatientMedecin extends StatefulWidget {
  const PatientMedecin({super.key});

  // final List<Map<String, String>> texts;
  //const PatientMedecin({Key? key}) : super(key: key);

  @override
  State<PatientMedecin> createState() => _PatientMedecinState();
}

class _PatientMedecinState extends State<PatientMedecin>
    with SingleTickerProviderStateMixin {
  String _searchText = '';
  //late List<Map<String, String>> _texts;
  late int _selectedButton = 0;
  bool _isFiltering = false;

  late String _selectedSpecialty = "";
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalanimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scalanimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    _fetchDoctors();
    _loadNotifications();

    //_texts = widget.texts;
    _selectedButton = 0;
    _searchText = '';
  }

  late AssetImage _profilePictureAsset =
      const AssetImage('assets/images/tiff4.png');
  List<AssetImage> profilePictureAssets = [
    const AssetImage('assets/images/tiff.png'),
    const AssetImage('assets/images/tiff2.png'),
    const AssetImage('assets/images/tiff3.png'),
    const AssetImage('assets/images/tiff4.png'),
    const AssetImage('assets/images/tiff5.png'),
    const AssetImage('assets/images/tiff6.png'),
    const AssetImage('assets/images/tiff7.png'),
    const AssetImage('assets/images/tiff8.png'),
  ];

  late int _selectedProfilePictureIndex;

  void _selectProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 300,
            child: ListView.builder(
              itemCount: profilePictureAssets.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image(image: profilePictureAssets[index]),
                  onTap: () async {
                    setState(() {
                      _profilePictureAsset = profilePictureAssets[index];
                    });
                    Navigator.of(context).pop();
                    final encodedAsset =
                        json.encode(_profilePictureAsset.assetName);
                    await prefs.setString(
                        'selectedProfilePictureAsset', encodedAsset);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<dynamic> notifications = [];

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int patientId = prefs.getInt('patient_id')!;
      const String apiUrl =
          'http://sihati.univ-setif.dz/api/v1/get_notifications';

      final response =
          await http.get(Uri.parse('$apiUrl?patient_id=$patientId'));

      if (response.statusCode == 200) {
        List<dynamic> notificationMessages = jsonDecode(response.body);
        setState(() {
          notifications = notificationMessages;
        });
      } else {
        print('Failed to fetch notifications');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _showNotifications() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Notifications (${notifications.length})',
            style: const TextStyle(
                fontFamily: 'Source_Sans_pro',
                color: Color.fromRGBO(
                    99, 141, 194, 1.0), // Set the text color to blue
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: Image.asset("assets/images/qwerty.png"),
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromRGBO(243, 246, 255, 1.0),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    notifications[index]['message'],
                                    style: const TextStyle(
                                      fontFamily: 'SourceSansPro',
                                      color: Colors.black87,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the AlertDialog
                          // Navigate to another page and pass the data to display in ListView
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Rndv(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('fermer'),
            ),
          ],
        );
      },
    );
  }

  late String patientName = " ";
  late int patientId = 0;
  bool _loading = false;

  List<Doctor> _doctors = [];
  Future<void> _fetchDoctors() async {
    setState(() {
      _loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    patientName = prefs.getString('patient_name')!;
    patientId = prefs.getInt('patient_id')!;
    final accessToken = prefs.getString('access_token_$patientId') ?? '';
    final url = Uri.parse('http://sihati.univ-setif.dz/api/v1/doctors_list');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Doctor> doctors = [];
      for (var doctorData in data) {
        Doctor doctor = Doctor(
            name: doctorData['name'],
            speciality: doctorData['specialite'] ?? '', // Add null check here
            imageUrl: doctorData['image_url'],
            email: doctorData['email'],
            phone: doctorData['phone_number'],
            address: doctorData['address'],
            doctorid: doctorData['doctorid']);
        doctors.add(doctor);
      }
      setState(() {
        _doctors = doctors;
        _loading = false;
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }
    }

    return true;
  }

  Future<void> _showPermissionDeniedDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text(
              "Location permission has been denied. Please grant permission in the app settings to use this feature."),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  late SMIBool isSideBarClosed;
  bool isSideMenuClosed = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(99, 141, 194, 1.0),
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SingleChildScrollView(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        width: 288,
                        left: isSideMenuClosed ? -288 : 0,
                        height: MediaQuery.of(context).size.height,
                        child: const SideMenu()),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                            animation.value - 30 * animation.value * pi / 180),
                      child: Transform.translate(
                        offset: Offset(animation.value * 265, 0),
                        child: Transform.scale(
                          scale: scalanimation.value,
                          child: ClipRRect(
                            //borderRadius: BorderRadius.all(Radius.circular(20)),

                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 38),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: _selectProfilePicture,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                40, 20, 0, 0),
                                            alignment: Alignment.topLeft,
                                            child: CircleAvatar(
                                              radius: 22,
                                              backgroundImage:
                                                  _profilePictureAsset != null
                                                      ? _profilePictureAsset
                                                      : null, // Use the selected profile picture asset, if available
                                              backgroundColor: Colors.grey[200],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              30, 5, 0, 0),
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Bonjour ',
                                            //textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Pacifico',
                                              color: Color.fromRGBO(
                                                  99,
                                                  141,
                                                  194,
                                                  1.0), // Set the text color to blue
                                              fontSize: 28.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              30, 5, 0, 0),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            //here the name of the user
                                            '$patientName ✌️',

                                            style: const TextStyle(
                                              fontFamily: 'Source_Sans_pro',
                                              color: Color.fromRGBO(30, 27, 27,
                                                  1.0), // Set the text color to blue
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 0, 10, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: const Color.fromRGBO(
                                          243, 246, 255, 1.0),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _searchText = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Chercher un medecin ',
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/gen.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _isFiltering = true;
                                              _selectedSpecialty = "General";
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/heart.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _isFiltering = true;
                                              _selectedSpecialty =
                                                  "Cardiologue";
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/tooth.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _isFiltering = true;
                                              _selectedSpecialty = "Dentiste";
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/reins.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 4;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/gastro.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 5;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/eye.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _isFiltering = true;
                                              _selectedSpecialty = "Dentiste";
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/bones.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedSpecialty =
                                                  "Cardiologue";
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/ear.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 8;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/baby.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 9;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/dm.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 10;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/tt.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 11;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: const Color.fromRGBO(
                                                  230, 235, 255, 1.0),
                                            ),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                //height: 80,
                                                child: Image.asset(
                                                    "assets/images/neuron.png")),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedButton = 12;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Rndv()));
                                          },
                                          child: Container(
                                            height: 140,
                                            margin: const EdgeInsets.fromLTRB(
                                                20, 16, 5, 0),
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color.fromRGBO(
                                                  75, 179, 224, 1),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: const Text(
                                                      'mes \n rendez vous',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SourceSansPro',
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 120,
                                                  width: 69,
                                                  child: Image.asset(
                                                      "assets/images/d4.png"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            double? latitude =
                                                prefs.getDouble('latitude');
                                            double? longitude =
                                                prefs.getDouble('longitude');
                                            print(
                                                'Latitude: $latitude, Longitude: $longitude');
                                            if (latitude != null &&
                                                longitude != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Annonces(
                                                            userId: 0)),
                                              );
                                            } else {
                                              LocationPermission permission =
                                                  await Geolocator
                                                      .checkPermission();
                                              if (permission ==
                                                  LocationPermission.denied) {
                                                await Geolocator
                                                    .requestPermission();
                                                permission = await Geolocator
                                                    .checkPermission();
                                              }
                                              if (permission ==
                                                  LocationPermission
                                                      .deniedForever) {
                                                _showPermissionDeniedDialog();
                                              }
                                              if (permission ==
                                                      LocationPermission
                                                          .whileInUse ||
                                                  permission ==
                                                      LocationPermission
                                                          .always) {
                                                Position position =
                                                    await Geolocator
                                                        .getCurrentPosition(
                                                  desiredAccuracy:
                                                      LocationAccuracy.best,
                                                );
                                                prefs.setDouble('latitude',
                                                    position.latitude);
                                                prefs.setDouble('longitude',
                                                    position.longitude);
                                                print(position);
                                              } else {
                                                _showPermissionDeniedDialog();
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 140,
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 16, 5, 0),
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color.fromRGBO(
                                                  71, 134, 192, 1),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: const Text(
                                                      "annoncer un \n besoin d'un \n medecin",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SourceSansPro',
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 120,
                                                  width: 68,
                                                  child: Image.asset(
                                                      "assets/images/d3.png"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 16, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Liste Des Medecins',
                                            style: TextStyle(
                                              fontFamily: 'Source_Sans_pro',
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _isFiltering = false;
                                                _selectedSpecialty = null ?? "";
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: Text(
                                                'Voir Tous',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.8, // Set maximum height to 80% of screen height
                                    ),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          _getFilteredDoctors().length < 10
                                              ? _getFilteredDoctors().length
                                              : 10,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final doctor =
                                            _getFilteredDoctors()[index];
                                        return Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 16, 10, 0),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            color: const Color.fromRGBO(
                                                243, 246, 255, 1.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade100,
                                                offset: const Offset(-6, -6),
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile(
                                                            doctor: doctor)),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 50,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 20,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          child: doctor
                                                                      .imageUrl !=
                                                                  null
                                                              ? Image.network(
                                                                  doctor
                                                                      .imageUrl!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                )
                                                              : const Icon(
                                                                  Icons.person),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 11),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child: Text(
                                                              doctor.name,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child: Text(
                                                              doctor.speciality,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      right: isSideMenuClosed ? 50 : 110,
                      top: 27,
                      child: MnBtn(
                        riveOnInit: (artboard) {
                          StateMachineController controller =
                              RiveUtils.getRiveController(
                            artboard,
                            stateMachineName: "State Machine",
                          );

                          isSideBarClosed =
                              controller.findSMI("isOpen") as SMIBool;
                          isSideBarClosed.value = true;
                        },
                        press: () {
                          isSideBarClosed.value = !isSideBarClosed.value;
                          if (isSideMenuClosed) {
                            _animationController.forward();
                          } else {
                            _animationController.reverse();
                          }
                          ;
                          setState(() {
                            isSideMenuClosed = isSideBarClosed.value;
                          });
                        },
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      right: isSideMenuClosed ? 0 : 65,
                      top: 60,
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 40,
                              width: 70,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 3),
                                    blurRadius: 8,
                                  )
                                ],
                              ),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/images/not.png',
                                  height: 24.0,
                                  width: 24.0,
                                ),
                                onPressed: () {
                                  _showNotifications();
                                },
                              ),
                            ),
                          ),
                          if (notifications.length > 0)
                            Positioned(
                              right: 11,
                              top: 11,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '${notifications.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
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

  List<Doctor> _getFilteredDoctors() {
    if (_searchText.isEmpty) {
      if (!_isFiltering) {
        return _doctors;
      } else {
        return _doctors
            .where((doctor) => doctor.speciality == _selectedSpecialty)
            .toList();
      }
    } else {
      final filteredList = _doctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      return filteredList;
    }
  }

  /*void _navigateToDoctorsWithSpecialty(BuildContext context, String specialty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorsPage(specialty: specialty),
      ),
    );
  }*/
}
