import 'package:flutter/material.dart';

class Presentation2 extends StatefulWidget {
  const Presentation2({Key? key}) : super(key: key);

  @override
  State<Presentation2> createState() => _Presentation2State();
}

class _Presentation2State extends State<Presentation2> {
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
              Expanded(child: SizedBox(height:300, width:80,child: Image.asset("assets/images/p6.png"))),
              Expanded(child: SizedBox(height:300, width:100,child: Image.asset("assets/images/p4.png"))),
              Expanded(child: SizedBox(height:300, width:90,child: Image.asset("assets/images/d3.png"))),
              Expanded(child: SizedBox(height:300, width:85,child: Image.asset("assets/images/d4.png"))),],),

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
                  const Center(
                    child: Text(
                      'Faites venir un médecin dans votre commune',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Color.fromRGBO(
                            99, 141, 194, 1.0), // Set the text color to blue
                        fontSize: 28.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Center(
                      child: Text(
                        "Décrivez votre besoin de santé et demandez une visite d'un médecin. ",
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
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Center(
                      child: Text(
                        " Les médecins disponibles dans votre région seront informés de votre demande et pourront y venir à le plus proche centre de santé . ",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
