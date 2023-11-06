import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sihati/main_page/opinion.dart';

import '../main_page/aboutus.dart';
import '../pages_doctor/groupe.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: 288,
          color: Color.fromRGBO(99, 141, 194, 1.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => groupe()),
                      );
                    },
                    leading: SizedBox(
                      height: 34,
                      width: 34,
                      child: Icon(Icons.home_outlined, color: Colors.white),
                    ),
                    title: Text(
                      "Page d'accueil",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      )),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    },
                    leading: SizedBox(
                      height: 34,
                      width: 34,
                      child:
                          Icon(Icons.info_outline_rounded, color: Colors.white),
                    ),
                    title: Text(
                      "À propos de Sihati",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      )),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPage()),
                      );
                    },
                    leading: SizedBox(
                      height: 34,
                      width: 34,
                      child: Icon(Icons.message_outlined, color: Colors.white),
                    ),
                    title: Text(
                      "Contactez-nous",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      )),
                  ListTile(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      List<String> keysToKeep = ["doctor_image"];

                      Set<String> allKeys = prefs.getKeys();
                      for (String key in allKeys) {
                        if (!keysToKeep.contains(key)) {
                          prefs.remove(key);
                        }
                      }
                      await prefs.setBool('isLoggedIn_patient', false);
                      await prefs.setBool('isLoggedIn_doctor', false);
                      prefs.remove('access_token');

                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    leading: SizedBox(
                        height: 34,
                        width: 34,
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                    title: Text(
                      "Déconnexion",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
