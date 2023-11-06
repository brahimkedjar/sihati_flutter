// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, camel_case_types, avoid_print, deprecated_member_use, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../login_users/login_patient.dart';

class Signup_patients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //extendBodyBehindAppBar: true,
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
        body: Material(
          child: SignupForm(),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late List<String> selectedStates;
  List<String> states = [
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
  @override
  void initState() {
    super.initState();
    selectedStates = [];
  }

  String selectedOption = '';
  void _submitForm() async {
    try {
      String apiUrl = 'http://41.111.206.183/patients';

      // Get the CSRF token from the server
      /*String csrfTokenUrl = 'http://127.0.0.1:3000/csrf_token';
      var csrfTokenResponse = await http.get(Uri.parse(csrfTokenUrl));
      var csrfToken = jsonDecode(csrfTokenResponse.body)['csrf_token'];*/

      // Set the request headers with the CSRF token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        /* 'X-CSRF-Token': csrfToken,*/
      };

      Map data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'password': _passwordController.text,
        'baladia': selectedOption
      };
      var response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode({'patient': data}), headers: headers);

      if (response.statusCode == 302) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Signup successful!')));
        selectedStates.clear();
      } else {
        print("Signup failed");
      }
    } catch (e) {
      print(e);
    }
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Color.fromRGBO(243, 246, 255, 1.0),
              ),
              margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'nom et prenom',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
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
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 300),
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
                        dropdownColor: Color.fromRGBO(243, 246, 255, 1.0),
                        menuMaxHeight: 300,
                        value: null,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Color.fromRGBO(243, 246, 255, 1.0),
              ),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: 'numero de telephone',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.phone),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                keyboardType:
                    TextInputType.emailAddress, // Set the text color here
                decoration: const InputDecoration(
                  hintText: 'email',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.mail),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                      _obscureText ? Icons.visibility : Icons.visibility_off,
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SizedBox(
                  height: 45,
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Set the border radius
                      ),
                      primary: Colors.blue, // Set the background color
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'soumettre',
                      style: TextStyle(
                        fontFamily: 'Source_Sans_pro',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                        MaterialPageRoute(
                          builder: (context) => LoginForm(),
                        ),
                      );
                    },
                    child: const Flexible(
                      child: Text(
                        'connecter',
                        style: TextStyle(
                          fontFamily: 'Source_Sans_pro',
                          color: Color.fromRGBO(
                              99, 141, 194, 1.0), // Set the text color to blue
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
    );
  }
}
