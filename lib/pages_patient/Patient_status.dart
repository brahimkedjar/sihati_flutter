// ignore_for_file: unnecessary_null_comparison, prefer_const_declarations, use_build_context_synchronously

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Annonces extends StatefulWidget {
  final int userId;
  const Annonces({required this.userId});

  @override
  State<Annonces> createState() => _AnnoncesState();
}

class _AnnoncesState extends State<Annonces> {
  final _statusTextController = TextEditingController();
  final double latitude1 = 15.72;
  final double longitude1 = 16.83;
  List<Map<String, dynamic>> _patientsData = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientsData();
    // getStatuses();
    //determinePosition();
  }

  void _fetchPatientsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final patientId = prefs.getInt('patient_id') ?? 0;
    Uri railsUrl = Uri.parse('http://sihati.univ-setif.dz/get_patients');
    try {
      final response =
          await http.post(railsUrl, body: {'patient_id': patientId.toString()});
      if (response.statusCode == 200) {
        setState(() {
          _patientsData = List.from(jsonDecode(response.body));
        });
      } else {
        print('Rails Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Rails Error: $error');
    }
  }

  List<Map<String, dynamic>> _statuses = [];
  String location = '';

  List<int> items = List<int>.generate(100, (int index) => index);

  /*Future<String> determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Show error message or redirect to settings screen
      return '';
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Save latitude and longitude values into the respective controllers
    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();

    location = jsonEncode(
        {'latitude': position.latitude, 'longitude': position.longitude});
    return location;
  }*/

  /*Future<void> getStatuses() async {
    setState(() {
      _loading = true;
    });
    final userId = widget.userId;

    var url =
        Uri.parse('http://192.168.76.170:3000/api/v1/index?userId=$userId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token_$userId') ?? '';

    var headers = {'Authorization': 'Bearer $accessToken'};
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _statuses = List<Map<String, dynamic>>.from(responseData['statuses']);
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }*/

  final TextEditingController _illnessTextController = TextEditingController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(112, 165, 215, 1.0),
      appBar: AppBar(
        title: const Text(
          'Mes Annonces',
          style: TextStyle(
            fontFamily: 'Source_Sans_Pro',
            color: Colors.white, // Set the text color to blue
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0.0, // Set the elevation to 0.0
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: 235,
                    width: 250,
                    child: Image.asset("assets/images/d5.png"),
                  ),
                  Container(
                    decoration: const BoxDecoration(
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
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, right: 15, left: 15),
                      child: ListView.builder(
                        itemCount: _patientsData.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(_patientsData[index]['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                _patientsData.removeAt(index);
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    "besoin d'un ${_patientsData[index]['speciality']}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "dans ${_patientsData[index]['baladia']}",
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18.0,
                                    color: Colors.grey,
                                  ),
                                  onTap: () {
                                    // Do something when tapping on the list tile
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateStatusDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String checkboxText = '';
  void _showCreateStatusDialog(BuildContext context) {
    List<String> _selectedSpeciality = []; // Set default value
    List<String> _selectedcommune = [];
    List<String> _specialities = [
      'Anesthésiologiste',
      'Cardiologue',
      'Chirurgien',
      'Dermatologue',
      'Endocrinologue',
      'Gastro-entérologue',
      'Gynécologue',
      'Hématologue',
      'Infectiologue',
      'Médecin généraliste',
      'Néphrologue',
      'Neurologue',
      'Oncologue',
      'Ophtalmologue',
      'Oto-rhino-laryngologiste (ORL)',
      'Pédiatre',
      'Psychiatre',
      'Radiologue',
      'Rhumatologue'
          'Urologue',
    ];
    List<String> _commune = [
      'Aïn Abessa',
      'Aïn Arnat',
      'Aïn Azel',
      'Aïn El Kebira',
      'Aïn Lahdjar',
      'Aïn Legradj',
      'Aïn Oulmene',
      'Aïn Roua',
      'Aïn Sebt',
      'Aït Naoual Mezada',
      'Aït Tizi',
      'Beni Ouartilene',
      'Amoucha',
      'Babor',
      'Bazer Sakhra',
      'Beidha Bordj',
      'Belaa',
      'Beni Aziz',
      'Beni Chebana',
      'Beni Fouda',
      'Beni Hocine',
      'Beni Mouhli',
      'Bir El Arch',
      'Bir Haddada',
      'Bouandas',
      'Bougaa',
      'Bousselam',
      'Boutaleb',
      'Dehamcha',
      'Djemila',
      'Draa Kebila',
      'El Eulma',
      'El Ouldja',
      'El Ouricia',
      'Guellal',
      'Guelta Zerka',
      'sites archéologiques de Aïn El Ahnech et Aïn Boucherit',
      'Guenzet',
      'Guidjel',
      'Hamma',
      'Hammam Guergour',
      'Hammam Soukhna',
      'Harbil',
      'Ksar El Abtal',
      'Maaouia',
      'Maoklane',
      'Mezloug',
      'Oued El Barad',
      'Ouled Addouane',
      'Ouled Sabor',
      'Ouled Si Ahmed',
      'Ouled Tebben',
      'Rasfa',
      'Salah Bey',
      'Serdj El Ghoul',
      'Sétif',
      'Tachouda',
      'Talaifacene',
      'Taya',
      'Tella',
      "Tizi N'Bechar",
    ];
    List<DropdownMenuItem<String>> _specialityDropdownItems = _specialities
        .map((String speciality) => DropdownMenuItem<String>(
              value: speciality,
              child: Text(speciality),
            ))
        .toList();
    List<DropdownMenuItem<String>> _communeDropdownItems = _commune
        .map((String commune) => DropdownMenuItem<String>(
              value: commune,
              child: Text(commune),
            ))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Annoncer votre besoin',
                style: TextStyle(
                    fontFamily: 'Source_Sans_pro',
                    color: Color.fromRGBO(
                        99, 141, 194, 1.0), // Set the text color to blue
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: DropdownButtonFormField<String>(
                        value: _selectedcommune.isNotEmpty
                            ? _selectedcommune[0]
                            : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          hintText: 'commune',
                        ),
                        dropdownColor: const Color.fromRGBO(243, 246, 255, 1.0),
                        isExpanded: true,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        items: _communeDropdownItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedcommune = [value!];
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedSpeciality.isNotEmpty
                            ? _selectedSpeciality[0]
                            : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          hintText: 'spécialiste',
                        ),
                        isExpanded: true,
                        items: _specialityDropdownItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedSpeciality = [value!];
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  height: 40,
                  width: 130,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Set the border radius
                      ),
                      backgroundColor: const Color.fromRGBO(
                          99, 141, 194, 1.0), // Set the background color
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Soumettre')),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final latitude = prefs.getDouble('latitude');
                      final longitude = prefs.getDouble('longitude');

                      final patientId = prefs.getInt('patient_id');

                      // Create a JSON object with the data to be sent
                      Map<String, dynamic> data = {
                        'patient_id': patientId,
                        'speciality': _selectedSpeciality.isNotEmpty
                            ? _selectedSpeciality[0]
                            : null, // convert list to string,
                        'baladia': _selectedcommune.isNotEmpty
                            ? _selectedcommune[0]
                            : null, // convert list to string,,
                        'latitude': latitude,
                        'longitude': longitude
                      };

                      // Convert the data to JSON string
                      String jsonData = jsonEncode(data);

                      // Convert the string URL to a Uri object
                      Uri url = Uri.parse(
                          'https://recommendersystem.onrender.com/assign_group');

                      // Make an HTTP POST request to the Flask app
                      http.post(url, body: jsonData).then((response) async {
                        Navigator.of(context).pop();

                        // Handle the response from Flask, if needed
                        print('Response: ${response.body}');

                        // Extract group ID from the response
                        String groupId =
                            jsonDecode(response.body)['group_id'].toString();
                        await prefs.setString('group_id', groupId);

                        final snackBar = const SnackBar(
                          content: Text(
                              'Nous avons reçu votre annonce et nous allons vous fournirons un médecin dès que possible'),
                          duration: Duration(seconds: 8),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }).catchError((error) {
                        // Handle any error that occurs during the request to Flask app
                        print('Error: $error');
                      });
                    },
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      color: Color.fromRGBO(99, 141, 194, 1.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _commune.clear();
                    _specialities.clear();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
