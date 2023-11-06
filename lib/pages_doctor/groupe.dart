// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sihati/pages_doctor/doctor_rendezvous.dart';
import '../components/mnbtn.dart';
import '../components/rive_utils.dart';
import '../components/sidemenu.dart';
import '../pages_doctor/profile_doctor.dart';
import '../pages_patient/profile_docp.dart';
import 'package:http/http.dart' as http;

import 'map.dart';

class groupe extends StatefulWidget {
  const groupe({Key? key}) : super(key: key);
  @override
  _groupefState createState() => _groupefState();
}

class _groupefState extends State<groupe> with SingleTickerProviderStateMixin {
  List<String> dropdownOptions = ['0-5', '5-10', '10-15', '15-20'];
  int max_members = 0;
  String? selectedOption;
  final _distanceController = TextEditingController();
  GoogleMapController? _controller; // Define the GoogleMapController
  Set<Marker> _markers = Set<Marker>(); // Define the Set to hold the markers
  List<Map<dynamic, DateTime>> appointements = [];
  TextEditingController textController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var groupeid;
  late int doctor_id = 0;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalanimation;
  int userMaxDistance = 10;
  late int doctorId = 0;
  List<dynamic> recomendedGroups = [];
  late String doctorName = "";
  late String doctorSpeciality = "";
  late String _imageurl = "";
  String? _imageUrl = null;
  bool _loading = false;

  void initState() {
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
    super.initState();
    getData();
    _loadImageFromBackend().then((imageUrl) {
      setState(() {
        _imageUrl = imageUrl;
      });
    });
    fetchRecommendations(100, 5);
  }

  Future<String?> _loadImageFromBackend() async {
    setState(() {
      _loading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    doctorId = prefs.getInt('doctor_id')!;

    final userId = doctorId;

    final url = Uri.parse(
        'http://sihati.univ-setif.dz/api/v1/users/$userId/images/url');
    final headers = {
      'Authorization': 'Bearer ${prefs.getString('access_token_$userId')}',
      'Accept': 'application/json'
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final imageUrl = responseBody['image_url'];
      setState(() {
        _loading = false;
      });
      return imageUrl;
    } else {
      setState(() {
        _loading = false;
      });
      return 'https://via.placeholder.com/150?text=No+Image';
    }
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    doctor_id = prefs.getInt("doctor_id") ?? 0;
    doctorName = prefs.getString('doctor_name') ?? "";

    _imageurl = prefs.getString('doctor_image_$doctor_id') ?? "";
  }

  Future<void> fetchRecommendations(int maxdistance, int maxmembers) async {
    final prefs = await SharedPreferences.getInstance();

    doctorId = prefs.getInt('doctor_id')!;
    final url = Uri.parse(
        'https://recommender-system-9lr3.onrender.com/recommender_patients');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'doctor_id': doctorId,
      'max_distance': maxdistance,
      'max_members': maxmembers,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Parse the response body as a Map<String, dynamic>
      final responseData = json.decode(response.body);

      // Access the 'recomended_groups' key in the response data
      recomendedGroups = responseData['recomended_groups'];
      setState(() {});
      // Call setState if you're using a StatefulWidget to trigger a UI update
    } else {
      print('Failed to connect to the server. Error: ${response.statusCode}');
    }
  }

  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late SMIBool isSideBarClosed;
  bool isSideMenuClosed = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(99, 141, 194, 1.0),
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
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
                ..rotateY(animation.value - 30 * animation.value * pi / 180),
              child: Transform.translate(
                offset: Offset(animation.value * 265, 0),
                child: Transform.scale(
                  scale: scalanimation.value,
                  child: ClipRRect(
                    //borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context)
                          .size
                          .width, // make the container take up all available width
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 29),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Profiledoctor() /*RndvMdcn()*/));
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(40, 20, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: _imageUrl != null
                                            ? Image.network(
                                                _imageUrl!,
                                                fit: BoxFit.cover,
                                                width: 40.0,
                                                height: 40.0,
                                              )
                                            : const Icon(Icons.person,
                                                color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(30, 5, 0, 0),
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    'Bonjour ',
                                    style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      color: Color.fromRGBO(99, 141, 194,
                                          1.0), // Set the text color to blue
                                      fontSize: 28.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                //name of user
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(30, 5, 0, 0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    //here the name of the user
                                    '$doctorName ✌️ ',

                                    style: const TextStyle(
                                      fontFamily: 'Source_Sans_pro',
                                      color: Color.fromRGBO(30, 27, 27,
                                          1.0), // Set the text color to blue
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                            alignment: Alignment.topLeft,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RndvMdcn() /*RndvMdcn()*/));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      margin: EdgeInsets.fromLTRB(20, 16, 5, 0),
                                      padding: EdgeInsets.only(left: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: const Color.fromRGBO(
                                            112, 165, 215, 1.0),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                              child: const Text(
                                                'mes \n rendez vous',
                                                style: TextStyle(
                                                  fontFamily: 'SourceSansPro',
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              height: 120,
                                              width: 61,
                                              child: Image.asset(
                                                  "assets/images/d3.png"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Create a Set to hold all markers
                                      Set<Marker> markers = Set<Marker>();

                                      // Loop through all recommended groups
                                      for (var groupData in recomendedGroups) {
                                        int groupId = groupData[0];
                                        String groupName = groupData[1];
                                        List<dynamic> patients = groupData[2];

                                        // Loop through the patients in the group
                                        for (var patient in patients) {
                                          String patientName =
                                              patient[0].toString();
                                          dynamic latitude = patient[1];
                                          dynamic longitude = patient[2];

                                          // Check if the latitude and longitude values are valid doubles
                                          if (latitude is double &&
                                              longitude is double) {
                                            // Create a LatLng object for the patient's position
                                            LatLng patientPosition =
                                                LatLng(latitude, longitude);

                                            // Create a Marker object for the patient
                                            Marker patientMarker = Marker(
                                              markerId: MarkerId(patientName),
                                              position: patientPosition,
                                              infoWindow: InfoWindow(
                                                title: patientName,
                                                snippet: groupId.toString(),
                                              ),
                                            );

                                            // Add the marker to the Set
                                            markers.add(patientMarker);
                                          }
                                        }
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GoogleMapPage(
                                            markers: markers,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 16, 5, 0),
                                      padding: const EdgeInsets.only(left: 8),
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/xm.png'),
                                          fit: BoxFit
                                              .cover, // specify the fit type
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color:
                                            Color.fromRGBO(112, 165, 215, 1.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 80, 20, 10),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          color: Color.fromRGBO(
                                              112, 165, 215, 1.0),
                                        ),
                                        child: const Text(
                                          "voir sur la carte",
                                          style: TextStyle(
                                            fontFamily: 'Source_Sans_pro',
                                            color: Colors.white,
                                            fontSize: 15.0,

                                            //fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              //here the name of the user
                              'Groupes des patients ',

                              style: TextStyle(
                                fontFamily: 'Source_Sans_pro',
                                color: Colors.black,
                                fontSize: 18.0,
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 16, 0, 0),
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    'voulez vous spécifier votre liste des groupes ?',
                                    style: TextStyle(
                                      fontFamily: 'Source_Sans_pro',
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: const Text(
                                              'Spécifier votre liste des groupes ',
                                              style: TextStyle(
                                                fontFamily: 'Source_Sans_pro',
                                                color: Color.fromRGBO(
                                                    99, 141, 194, 1.0),
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SizedBox(
                                              height: 200,
                                              width: 230,
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 20),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      color:
                                                          const Color.fromRGBO(
                                                              243,
                                                              246,
                                                              255,
                                                              1.0),
                                                    ),
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 10.0),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: selectedOption,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedOption =
                                                              value!;
                                                          // Parse the selected value to get the maximum members value
                                                          // which is the second part of the selected option (e.g., '10-15' -> '15')
                                                          max_members =
                                                              int.parse(value!
                                                                  .split(
                                                                      '-')[1]);
                                                        });
                                                      },
                                                      items: dropdownOptions
                                                          .map((option) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: option,
                                                          child: Text(option),
                                                        );
                                                      }).toList(),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        10.0),
                                                        hintText:
                                                            'Nombre des patients',
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  Text(
                                                    'Distance Maximale: ${userMaxDistance.toInt()} km',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  Slider(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        userMaxDistance =
                                                            value.round();
                                                      });
                                                    },
                                                    value: userMaxDistance
                                                        .toDouble(),
                                                    min: 1,
                                                    max: 500,
                                                    divisions: 99,
                                                    label:
                                                        'Max Distance: $userMaxDistance km',
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              SizedBox(
                                                height: 40,
                                                width: 130,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    primary:
                                                        const Color.fromRGBO(
                                                            99, 141, 194, 1.0),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        const Text('Confirmer'),
                                                  ),
                                                  onPressed: () {
                                                    fetchRecommendations(
                                                        userMaxDistance,
                                                        max_members);
                                                    Navigator.of(context).pop();
                                                    print(max_members);
                                                    print(userMaxDistance);
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'Annuller',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        99, 141, 194, 1.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 16, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      'cliquez ici',
                                      style: TextStyle(
                                        fontFamily: 'Source_Sans_pro',
                                        color:
                                            Color.fromRGBO(99, 141, 194, 1.0),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: recomendedGroups.length,
                                    itemBuilder: (context, index) {
                                      final groupData = recomendedGroups[index];

                                      // Access the elements in the groupData list
                                      final groupId = groupData[0];
                                      final groupName = groupData[1];

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(vertical: 15),
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 16, 20, 0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: const Offset(-6, -6),
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Create a Set to hold the markers
                                                          Set<Marker> markers =
                                                              Set<Marker>();

                                                          // Get the selected group data
                                                          String
                                                              selectedGroupName =
                                                              groupName
                                                                  .toString();
                                                          List<dynamic>
                                                              patients =
                                                              groupData[2];

                                                          // Loop through the patients in the group
                                                          for (var patient
                                                              in patients) {
                                                            String patientName =
                                                                patient[0]
                                                                    .toString();
                                                            dynamic latitude =
                                                                patient[1];
                                                            dynamic longitude =
                                                                patient[2];

                                                            // Check if the latitude and longitude values are valid doubles
                                                            if (latitude
                                                                    is double &&
                                                                longitude
                                                                    is double) {
                                                              // Create a LatLng object for the patient's position
                                                              LatLng
                                                                  patientPosition =
                                                                  LatLng(
                                                                      latitude,
                                                                      longitude);

                                                              // Create a Marker object for the patient
                                                              Marker
                                                                  patientMarker =
                                                                  Marker(
                                                                markerId: MarkerId(
                                                                    patientName),
                                                                position:
                                                                    patientPosition,
                                                                infoWindow:
                                                                    InfoWindow(
                                                                  title:
                                                                      patientName,
                                                                  snippet: groupId
                                                                      .toString(),
                                                                  // Add the groupId to the infoWindow widget
                                                                  onTap: () {
                                                                    print(
                                                                        'Group ID: $groupId');
                                                                  },
                                                                ),
                                                              );

                                                              // Add the marker to the Set
                                                              markers.add(
                                                                  patientMarker);
                                                            }
                                                          }

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GoogleMapPage(
                                                                markers:
                                                                    markers,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Image.asset(
                                                            "assets/images/l3.png"),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 11),
                                                    Column(
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
                                                            'Groupe $groupId du $groupName ',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'WorkSans',
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15.0,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              // Get the selected group data
                                                              String
                                                                  selectedGroupName =
                                                                  groupName
                                                                      .toString();
                                                              List<dynamic>
                                                                  patients =
                                                                  groupData[2];

                                                              // Show a dialog with the number of patients and a list of patient names
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Dialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    insetPadding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    child:
                                                                        Stack(
                                                                      clipBehavior:
                                                                          Clip.none,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.7,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.7,
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              24,
                                                                              36,
                                                                              24,
                                                                              16),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.16),
                                                                                blurRadius: 8,
                                                                                offset: const Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                textAlign: TextAlign.center,
                                                                                'Groupe ${groupId} \n ${selectedGroupName}',
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Source_Sans_pro',
                                                                                  color: Color.fromRGBO(99, 141, 194, 1.0),
                                                                                  fontSize: 24.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 16),
                                                                              Text(' ${patients.length} patients'),
                                                                              const SizedBox(height: 16),
                                                                              const SizedBox(height: 8),
                                                                              Expanded(
                                                                                child: ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: patients.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    final patient = patients[index];
                                                                                    final patientName = patient[0].toString();
                                                                                    return Container(
                                                                                        padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
                                                                                        child: Text(
                                                                                          '  $patientName',
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Source_Sans_pro',
                                                                                            color: Colors.black,
                                                                                            fontSize: 18.0,
                                                                                            //fontWeight: FontWeight.bold
                                                                                          ),
                                                                                        ));
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top:
                                                                              -36,
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              shape: BoxShape.circle,
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.16),
                                                                                  blurRadius: 8,
                                                                                  offset: const Offset(0, 4),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.group,
                                                                              size: 48,
                                                                              color: Color.fromRGBO(99, 141, 194, 1.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              -16,
                                                                          top:
                                                                              -16,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.all(12),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                shape: BoxShape.circle,
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.black.withOpacity(0.16),
                                                                                    blurRadius: 8,
                                                                                    offset: const Offset(0, 4),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: const Icon(
                                                                                Icons.close,
                                                                                size: 24,
                                                                                color: Color.fromRGBO(99, 141, 194, 1.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Voir la liste des patients',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'WorkSans',
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          title: const Text(
                                                            'Fixer un rendez vous \n pour ce groupe',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Source_Sans_pro',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        99,
                                                                        141,
                                                                        194,
                                                                        1.0), // Set the text color to blue
                                                                fontSize: 24.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          content: SizedBox(
                                                            height: 300,
                                                            width: 230,
                                                            child:
                                                                CalendarDatePicker(
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate: DateTime
                                                                      .now()
                                                                  .add(const Duration(
                                                                      days:
                                                                          365)),
                                                              onDateChanged:
                                                                  (date) {
                                                                setState(() {
                                                                  selectedDate =
                                                                      date;
                                                                  groupeid =
                                                                      groupData[
                                                                          0]; // Update groupeid with the correct value
                                                                  Map<dynamic,
                                                                          DateTime>
                                                                      appointmentMap =
                                                                      {
                                                                    groupeid:
                                                                        selectedDate
                                                                  };
                                                                  appointements.add(
                                                                      appointmentMap);
                                                                  print(
                                                                      appointements);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          actions: [
                                                            SizedBox(
                                                              height: 40,
                                                              width: 130,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  primary:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          99,
                                                                          141,
                                                                          194,
                                                                          1.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: const Text(
                                                                      'confirmer'),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  final prefs =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  doctorSpeciality =
                                                                      prefs.getString(
                                                                          'doctor_speciality')!;
                                                                  doctorName = prefs
                                                                      .getString(
                                                                          'doctor_name')!;
                                                                  // Close AlertDialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  // Make an API call to send notifications to patients with the same group_id
                                                                  try {
                                                                    // Convert integer to string representation
                                                                    List<String>
                                                                        groupIdList =
                                                                        [
                                                                      groupeid
                                                                          .toString()
                                                                    ]; // Wrap the group ID in a list

                                                                    // Replace the API_URL with the actual URL of your backend API endpoint
                                                                    final String
                                                                        apiUrl =
                                                                        'http://sihati.univ-setif.dz/api/v1/send_notifications'; // Update with your actual API URL
                                                                    final response =
                                                                        await http
                                                                            .post(
                                                                      Uri.parse(
                                                                          apiUrl),
                                                                      body: {
                                                                        'group_id':
                                                                            groupIdList.join(','), // Pass the group_id as a comma-separated string
                                                                        'appointment_date':
                                                                            selectedDate.toString(), // Pass the appointment_date as a parameter to the API
                                                                        'doctor_name':
                                                                            doctorName, // Pass the doctor_name as a parameter to the API
                                                                        'doctor_speciality':
                                                                            doctorSpeciality,
                                                                        'place':
                                                                            groupData[1],
                                                                        'doctor_id':
                                                                            doctorId.toString(),
                                                                      },
                                                                    );
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      print(
                                                                          'Notifications sent successfully');
                                                                      // Handle success
                                                                    } else if (response
                                                                            .statusCode ==
                                                                        422) {
                                                                      print(
                                                                          'Failed to send notifications: Unprocessable Entity');
                                                                      print(
                                                                          'Error: ${response.body}'); // Print the error message from response body
                                                                      // Handle failure due to unprocessable entity
                                                                    } else {
                                                                      print(
                                                                          'Failed to send notifications');
                                                                      // Handle other failure cases
                                                                    }
                                                                  } catch (e) {
                                                                    print(
                                                                        'Error: $e');
                                                                    // Handle error
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                'Annuler',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          99,
                                                                          141,
                                                                          194,
                                                                          1.0),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              )
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
              right: isSideMenuClosed ? 20 : 70,
              top: 20,
              child: MnBtn(
                riveOnInit: (artboard) {
                  StateMachineController controller =
                      RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "State Machine",
                  );

                  isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
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
          ],
        ),
      ),
    );
  }
}
