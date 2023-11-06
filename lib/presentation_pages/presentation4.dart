import 'package:flutter/material.dart';
import 'package:sihati/main_page/home_page.dart';

class Presentation4 extends StatefulWidget {
  const Presentation4({Key? key}) : super(key: key);

  @override
  State<Presentation4> createState() => _Presentation4State();
}

class _Presentation4State extends State<Presentation4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 15.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [

            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                child: const Text(
                  '                                                     Commencer >>',
                  style: TextStyle(
                    fontFamily: 'Source_Sans_pro',
                    color: Color.fromRGBO(
                        30, 27, 27, 1.0), // Set the text color to blue
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
