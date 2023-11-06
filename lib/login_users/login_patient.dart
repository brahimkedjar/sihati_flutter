// ignore_for_file: camel_case_types, library_private_types_in_public_api, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sihati/signup_users/signup_patient.dart';
import 'package:http/http.dart' as http;

import '../pages_patient/medecinp.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String acesstoekn = '';
  late bool _isLoading = false;
  final String _errorMessage = '';
  void checkIsLoggedIn() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn_patient');
    if (isLoggedIn != null && isLoggedIn) {
      setState(() {
        _loading = false;
      });
      Navigator.pushNamed(context, '/dashboard_patient');
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  Future<void> checkLogin(String email, String password) async {
    setState(() {});

    ///final csrfTokenResponse = await http.get(Uri.parse('http://localhost:3000/csrf_token_login'));
    ///final csrfToken = jsonDecode(csrfTokenResponse.body)['csrf_token'];

    final response = await http.post(
      Uri.parse('http://sihati.univ-setif.dz/patients/sign_in'),
      headers: {
        'Content-Type': 'application/json',

        ///'X-CSRF-Token': csrfToken,
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: jsonEncode({
        'patient': {'email': email, 'password': password}
      }),
    );

    if (response.statusCode == 200) {
      final accessToken = jsonDecode(response.body)['access_token'] as String?;
      acesstoekn = accessToken!;
      final int patientId = jsonDecode(response.body)['patient_id'];
      final String patientName = jsonDecode(response.body)['patient_name'];
      final String patientEmail = jsonDecode(response.body)['patient_email'];
      final String patientPhone = jsonDecode(response.body)['patient_phone'];
      final String patientBaladia =
          jsonDecode(response.body)['patient_baladia'];
      final List<dynamic> patientGroup =
          jsonDecode(response.body)['patient_group'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token_$patientId', accessToken);

      ///await prefs.setString('csrf_token', csrfToken); // Save the CSRF token in preferences
      await prefs.setInt('patient_id', patientId);
      await prefs.setString('patient_name', patientName);
      await prefs.setString('patient_email', patientEmail);
      await prefs.setString('patient_phone', patientPhone);
      await prefs.setString('patient_baladia', patientBaladia);
      await prefs.setBool('isLoggedIn_patient', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientMedecin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('login faild !')));
    }
  }

  bool _loading = false;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Form',
      home: Scaffold(
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
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                              color: Color.fromRGBO(30, 27, 27,
                                  1.0), // Set the text color to blue
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
                        //const SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color.fromRGBO(243, 246, 255, 1.0),
                          ),
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              hintText: 'mot de passe',
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.lock),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                                margin:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Set the border radius
                                      ),
                                      primary: Colors
                                          .blue, // Set the background color
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        checkLogin(emailController.text,
                                            _passwordController.text);
                                      }
                                    },
                                    child: const Text(
                                      'se connecter',
                                      style: TextStyle(
                                        fontFamily: 'Source_Sans_pro',
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16.0),
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 15, 0),
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
                                              Signup_patients()),
                                    );
                                  },
                                  child: Container(
                                      child: const Text(
                                    'créer un compte',
                                    style: TextStyle(
                                      fontFamily: 'Source_Sans_pro',
                                      color: Color.fromRGBO(99, 141, 194,
                                          1.0), // Set the text color to blue
                                      fontSize: 16.0,
                                    ),
                                  )),
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
      ),
    );
  }
}
