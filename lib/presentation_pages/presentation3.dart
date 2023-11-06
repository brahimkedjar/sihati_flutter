import 'package:flutter/material.dart';
import 'package:sihati/main_page/home_page.dart';

class Presentation3 extends StatefulWidget {
  const Presentation3({Key? key}) : super(key: key);

  @override
  State<Presentation3> createState() => _Presentation3State();
}

class _Presentation3State extends State<Presentation3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 246, 255, 1.0),
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Row(children: [
              Expanded(child: Container(height: 300,width:100,child: Image.asset("assets/images/p1.png"))),
              Expanded(child: Container(height: 300,width:80,child: Image.asset("assets/images/p8.png"))),
              Expanded(child: Container(height:300, width:90,child: Image.asset("assets/images/p9.png"))),
              Expanded(child: Container(height: 300,width:120,child: Image.asset("assets/images/p7.png"))),


            ],),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
              //margin: EdgeInsets.symmetric(vertical: 2.0),
              child: const Center(
                child: Text(
                  "vous êtes des medecins ?",
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
              padding: const EdgeInsets.all(16.0),
              //margin: EdgeInsets.symmetric(vertical: 8.0),
              child: const Center(
                child: Text(
                  " notre application est conçue pour vous aider à fournir des soins plus accessibles et à faciliter votre travail.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Source_Sans_pro',
                    color: Color.fromRGBO(
                        30, 27, 27, 1.0), // Set the text color to blue
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Set the border radius
                    ),
                    primary: Colors.blue, // Set the background color
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontFamily: 'Source_Sans_pro',
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage()),
                    );

                  },
                ),
              ),
            ),
          ],),),

          ],
        ),
      ),
    );
  }
}
