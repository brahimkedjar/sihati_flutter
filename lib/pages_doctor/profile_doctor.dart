// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'localisation.dart';
import 'mapscreen.dart';

class Profiledoctor extends StatefulWidget {
  @override
  _ProfiledoctorState createState() => _ProfiledoctorState();
}

class _ProfiledoctorState extends State<Profiledoctor> {
  late File? _image = null;
  String? _imageUrl = null;
  @override
  void initState() {
    super.initState();
    loaddata();
    _loadImageFromBackend().then((imageUrl) {
      setState(() {
        _imageUrl = imageUrl;
      });
    });
  }

  late String doctorSpeciality = "";
  late String doctorAddress = "";
  late String doctorName = "";
  late String doctorEmail = "";
  late String doctorPhone = "";
  late int doctorId = 0;
  var _numeroCliniqueController = TextEditingController();
  final _numeroexperianceController = TextEditingController();
  bool _isEditable = false;

  Future<void> loaddata() async {
    final prefs = await SharedPreferences.getInstance();
    doctorId = prefs.getInt('doctor_id')!;
    doctorSpeciality = prefs.getString('doctor_speciality')!;
    doctorName = prefs.getString('doctor_name')!;
    doctorEmail = prefs.getString('doctor_email')!;
    doctorPhone = prefs.getString('doctor_phone')!;
    doctorAddress = prefs.getString('doctor_address')!;
    _numeroCliniqueController.text = doctorPhone;
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImageToBackend() async {
    final url = Uri.parse('http://sihati.univ-setif.dz/api/v1/user_images');
    final prefs = await SharedPreferences.getInstance();
    final userId = doctorId;
    final accessToken = prefs.getString('access_token_$userId');

    // Create a multipart request and add the image file and user ID to it
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path))
      ..fields['user_id'] =
          userId.toString(); // Add user_id field to the request

    // Send the request and handle the response
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      final userImageId = responseBody['id'];
      prefs.setInt('user_image_id', userImageId);
      setState(() {
        _imageUrl = responseBody['image_url'];
        prefs.setString('doctor_image_$doctorId', _imageUrl!);
      });
      print('Image saved to backend.');
    } else {
      print('Failed to save/update image to backend.');
    }
  }

  Future<String?> _loadImageFromBackend() async {
    setState(() {
      _loading = true;
    });

    final prefs = await SharedPreferences.getInstance();
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

  Future<void> updateDoctorInfo(String phone, int experience) async {
    final prefs = await SharedPreferences.getInstance();
    doctorId = prefs.getInt('doctor_id')!;
    final String apiUrl = 'http://sihati.univ-setif.dz/doctors/$doctorId';

    final Map<String, dynamic> requestData = {
      'doctor': {
        'phone': phone,
        'experience': experience,
      },
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Success
        print('Doctor info updated successfully');
      } else {
        // Error
        print('Error updating doctor info');
      }
    } catch (e) {
      // Exception
      print('Exception: ${e.toString()}');
    }
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          color: const Color.fromRGBO(0, 181, 247, 1),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(220, 237, 243, 1.0),
        elevation: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(220, 237, 243, 1.0),
              Color.fromRGBO(220, 237, 243, 1.0),
            ],
          ),
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () async {
                              await _getImageFromGallery();
                              if (_image != null) {
                                await _saveImageToBackend();
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: _imageUrl != null
                                  ? Image.network(
                                      _imageUrl!,
                                      width: 100.0,
                                      height: 160.0,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50.0,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorName,
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                doctorSpeciality,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapScreen2(
                                            doctorAddress: doctorAddress,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.location_pin,
                                        color: Colors.blue),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                child: Card(
                                                  margin: const EdgeInsets.only(
                                                      left: 16.0,
                                                      right: 16.0,
                                                      top: 80.0,
                                                      bottom: 16.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'Doctor Address',
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10.0),
                                                        Text(
                                                          doctorAddress,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20.0),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: const Text(
                                                                'OK',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        doctorAddress,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[700],
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        const Text(
                                          '4.5',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'étoiles',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.only(left: 8),
              height: 100,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey[200],
                            backgroundImage:
                                const AssetImage("assets/images/work.png"),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Experience',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              TextFormField(
                                controller: _numeroexperianceController,
                                enabled: _isEditable,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: ' ..ans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/telephone.png'),
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Clinic Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: _numeroCliniqueController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      hintText: '00 .. .. .. ',
                                    ),
                                    enabled: _isEditable,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isEditable = !_isEditable;
                      });
                    },
                    icon: Icon(_isEditable ? Icons.save : Icons.edit),
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
