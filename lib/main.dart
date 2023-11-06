// ignore_for_file: avoid_print, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:sihati/pages_doctor/groupe.dart';
import 'package:sihati/pages_patient/medecinp.dart';
import 'package:sihati/presentation_pages/presentation1.dart';
import 'package:sihati/presentation_pages/presentation2.dart';
import 'package:sihati/presentation_pages/presentation3.dart';
import 'login_users/login_doctor.dart';
import 'main_page/home_page.dart';

void main() {
  runApp(const MyPageView());
}

class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomePage(),
        '/dashboard_doctor': (context) => const groupe(),
        '/dashboard_patient': (context) => const PatientMedecin(),
      },
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  const Presentation1(),
                  const Presentation2(),
                  const Presentation3(),
                ],
              ),
            ),
            _buildPageIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text(
                'sauter',
                style: TextStyle(
                  fontFamily: 'Source_Sans_pro',
                  color: Color.fromRGBO(99, 141, 194, 1.0),
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageIndicatorItem(0),
                _buildPageIndicatorItem(1),
                _buildPageIndicatorItem(2),
              ],
            ),
            Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPageIndicatorItem(int pageIndex) {
    Color color =
        _currentPageIndex == pageIndex ? Colors.blue : Colors.grey[300]!;
    return Container(
      margin: const EdgeInsets.all(5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
