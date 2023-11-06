// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sihati/pages_doctor/groupe.dart';
import 'package:sihati/signup_users/signup_doctor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  List<dynamic> state = [];
  List<String> state1 = [];
  String errorMessage = "password ou email invalid !";
  late String acesstoekn = '';
  late bool _isLoading = false;
  late int userid;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> checkLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    ///final csrfTokenResponse =
    ///await http.get(Uri.parse('http://localhost:3000/csrf_token'));
    ///final csrfToken = jsonDecode(csrfTokenResponse.body)['csrf_token'];
    final response = await http.post(
      Uri.parse('http://sihati.univ-setif.dz/doctors/sign_in'),
      headers: {
        'Content-Type': 'application/json',

        ///'X-CSRF-Token': csrfToken,
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: jsonEncode({
        'doctor': {'email': email, 'password': password}
      }),
    );

    if (response.statusCode == 200) {
      final accessToken = jsonDecode(response.body)['access_token'] as String?;
      acesstoekn = accessToken!;
      setState(() {});
      final int doctorId = jsonDecode(response.body)['doctor_id'];
      final String doctorName = jsonDecode(response.body)['doctor_name'];
      final String doctorEmail = jsonDecode(response.body)['doctor_email'];
      final String doctorPhone = jsonDecode(response.body)['doctor_phone'];
      final String doctorSpeciality =
          jsonDecode(response.body)['doctor_speciality'];
      final String doctorAddress = jsonDecode(response.body)['doctor_address'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token_$doctorId', accessToken);

      ///await prefs.setString('csrf_token', csrfToken); // Save the CSRF token in preferences
      await prefs.setInt('doctor_id', doctorId);
      await prefs.setString('doctor_name', doctorName);
      await prefs.setString('doctor_email', doctorEmail);
      await prefs.setString('doctor_phone', doctorPhone);
      await prefs.setString('doctor_speciality', doctorSpeciality);
      await prefs.setString('doctor_address', doctorAddress);

      acesstoekn = accessToken;
      setState(() {
        _isLoading = false;
      });
      await prefs.setString('access_token_$doctorId', accessToken);

      ///await prefs.setString(
      ///'csrf_token', csrfToken); // Save the CSRF token in preferences

      await prefs.setBool('isLoggedIn_doctor', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const groupe(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('login fiald!')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void checkIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn_doctor');
    if (isLoggedIn == false) {
    } else {
      Navigator.pushNamed(context, '/dashboard_doctor');
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: const Center(
                          child: Text(
                            'Content de te revoir 👋   ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Pacifico',
                              color: Color.fromRGBO(99, 141, 194,
                                  1.0), // Set the text color to blue
                              fontSize: 28.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'pour utiliser votre compte,vous devez d’abord vous connecter',
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Source_Sans_pro',
                            color: Color.fromRGBO(
                                30, 27, 27, 1.0), // Set the text color to blue
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: const Color.fromRGBO(243, 246, 255, 1.0),
                        ),
                        margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          // ignore: prefer_const_constructors
                          decoration: const InputDecoration(
                            hintText: 'email',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.mail),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: const Color.fromRGBO(243, 246, 255, 1.0),
                        ),
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'mot de passe',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: _toggle,
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // Set the border radius
                                    ),
                                    primary:
                                        Colors.blue, // Set the background color
                                  ),
                                  child: const Text(
                                    'se connecter',
                                    style: TextStyle(
                                      fontFamily: 'Source_Sans_pro',
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    checkLogin(emailController.text,
                                        passwordController.text);
                                  },
                                ),
                              ),
                            ),
                      const SizedBox(height: 16.0),
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
                      const SizedBox(height: 28.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                                child: const Text(
                                  "vous n'avez pas un compte ?",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorInscriptionForm()),
                                  );
                                },
                                child: const Text(
                                  'créer un compte',
                                  style: TextStyle(
                                    fontFamily: 'Source_Sans_pro',
                                    color: Color.fromRGBO(99, 141, 194,
                                        1.0), // Set the text color to blue
                                    fontSize: 16.0,
                                  ),
                                ),
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
    );
  }
}
