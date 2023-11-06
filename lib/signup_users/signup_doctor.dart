// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, avoid_print, prefer_const_constructors, depend_on_referenced_packages, must_be_immutable, prefer_typing_uninitialized_variables, unused_element, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import '../pages_doctor/localisation.dart';
import '../login_users/login_doctor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorInscriptionForm extends StatefulWidget {
  late var location;
  DoctorInscriptionForm({this.location});
  @override
  // ignore: library_private_types_in_public_api
  _DoctorInscriptionFormState createState() => _DoctorInscriptionFormState();
}

class _DoctorInscriptionFormState extends State<DoctorInscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeprenameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phonedoctorController = TextEditingController();
  String clinicAddress = "";
  final _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<String> states = [
    'tous',
    'none',
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
    'Aïn El Ahnech et Aïn Boucherit',
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
  List<String> specialites = [
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

  String selectedspec = '';
  // Store the selected states in a Set
  List<String> selectedStates = [];
  late final String loc2;
  // Define the PostgreSQL connection
  void _launchMaps() async {
    String query = Uri.encodeFull(clinicAddress);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      print("Could not launch Google Maps");
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _nomeprenameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectLocation(BuildContext context) async {
    var location = await Navigator.push(
      context,
      MaterialPageRoute<LatLng>(
        builder: (context) => MapScreen(),
      ),
    );
    if (location != null) {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      final Placemark placemark = placemarks.first;

      final String address = '${placemark.thoroughfare}, ${placemark.locality}';

      setState(() {
        widget.location = address;
        _searchController.text = address;
      });
    }
  }

  void sendEmail(
      String namePrename,
      String phoneNumber,
      String email,
      String speciality,
      String address,
      String password,
      List<String> selectedStates) async {
    String apiUrl = 'http://41.111.206.183/doctors';
    Map data = {
      'doctor': {
        'name': namePrename,
        'phone_number': phoneNumber,
        'email': email,
        'address': address,
        'password': password,
        'specialite': speciality,
        'selected_wilaya': selectedStates
      }
    };
    try {
      var response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Signup successful!')));
        selectedStates.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Signup faild!')));
        selectedStates.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.blue,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0.0, // Set the elevation to 0.0
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Center(
                child: Text(
                  'Créer un compte ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    color: Color.fromRGBO(
                        99, 141, 194, 1.0), // Set the text color to blue
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: TextFormField(
                        controller: _nomeprenameController,
                        decoration: const InputDecoration(
                          hintText: 'nom et prenom',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person_outline),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your prename';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: _phonedoctorController,
                        decoration: const InputDecoration(
                          hintText: 'numero de telephone',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.phone_outlined),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'email',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.mail_outline),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.add_box_outlined),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 20.0),
                          hintText: 'spécialité',
                        ),
                        icon: const Icon(Icons.arrow_drop_down),
                        dropdownColor: Color.fromRGBO(243, 246, 255, 1.0),
                        menuMaxHeight: 300,
                        value: null,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        onChanged: (value) {
                          setState(() {
                            selectedspec = (value!);
                          });
                        },
                        items: specialites.map((String state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: SingleChildScrollView(child: Text(state)),
                          );
                        }).toList(),
                        isDense: true,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Si vous pouvez vous rendre dans les zones de l'ombre pour prodiguer des soins, indiquez les comunes où vous pouvez vous rendre",
                              style: TextStyle(
                                fontFamily: 'Source_Sans_pro',
                                color: Color.fromRGBO(30, 27, 27, 1.0),
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Color.fromRGBO(243, 246, 255, 1.0),
                            ),
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: Container(
                              // constraints: BoxConstraints(maxWidth: 300),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.place_outlined),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 20.0,
                                  ),
                                  hintText: 'commune',
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                dropdownColor:
                                    Color.fromRGBO(243, 246, 255, 1.0),
                                menuMaxHeight: 300,
                                value: null,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    selectedStates.add(value!);
                                  });
                                },
                                items: states.map((String state) {
                                  return DropdownMenuItem<String>(
                                    value: state,
                                    child: Text(state),
                                  );
                                }).toList(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      //spacing: 3.0,
                      children: selectedStates.map((state) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(),
                          child: Text(
                            state,
                            style: const TextStyle(
                              fontFamily: 'Source_Sans_pro',
                              color: Color.fromRGBO(30, 27, 27,
                                  1.0), // Set the text color to blue
                              fontSize: 14.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "cliquez pour ajouter votre addresse",
                          style: TextStyle(
                            fontFamily: 'Source_Sans_pro',
                            color: Color.fromRGBO(30, 27, 27, 1.0),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      child: Container(
                        width: 330,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color.fromRGBO(243, 246, 255, 1.0),
                        ),
                        child: Image.asset("assets/images/map3.webp"),
                      ),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()),);
                        _selectLocation(context);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        controller: _searchController,
                        style: TextStyle(
                            color: Colors.black), // Set the text color here
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F6FF),
                          hintText: "l'adresse de votre clinique",
                          hintStyle: TextStyle(
                              color:
                                  Colors.grey), // Set the hint text color here
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(243, 246, 255, 1.0),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'mot de passe',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 45,
                      width: 320,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            // Generate a random password

                            sendEmail(
                              _nomeprenameController.text,
                              _phonedoctorController.text,
                              _emailController.text,
                              selectedspec,
                              _searchController.text,
                              _passwordController.text,
                              selectedStates
                                  .cast<String>()
                                  .toList(), // Pass the generated password to the sendEmail function
                            );

                            // Show a success message or navigate to another page.
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Set the border radius
                          ),
                          primary: Colors.blue, // Set the background color
                        ),
                        child: const Text(
                          'soumettre',
                          style: TextStyle(
                            fontFamily: 'Source_Sans_pro',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.grey,
                            height: 50,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('ou'),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.grey,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: const Text(
                              "vous avez un compte ?",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<LatLng>(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: const Flexible(
                              child: Text(
                                'connecter',
                                style: TextStyle(
                                  fontFamily: 'Source_Sans_pro',
                                  color: Color.fromRGBO(99, 141, 194,
                                      1.0), // Set the text color to blue
                                  fontSize: 16.0,
                                ),
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
          ],
        ),
      ),
    );
  }
}
