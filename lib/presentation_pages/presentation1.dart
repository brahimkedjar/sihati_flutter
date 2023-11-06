import 'package:flutter/material.dart';

class Presentation1 extends StatefulWidget {
  const Presentation1({Key? key}) : super(key: key);

  @override
  State<Presentation1> createState() => _Presentation1State();
}

class _Presentation1State extends State<Presentation1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 246, 255, 1.0),
      //backgroundColor: Color.fromRGBO(220, 237, 243, 1.0),
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Row(children: [
              Expanded(child: Container(height: 300,width:100,child: Image.asset("assets/images/p1.png"))),
              Expanded(child: Container(height: 300,width:90,child: Image.asset("assets/images/d3.png"))),
              Expanded(child: SizedBox(height: 300,width:100,child: Image.asset("assets/images/p4.png"))),
              Expanded(child: Container(height: 300,width:100,child: Image.asset("assets/images/p5.png"))),
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Bienvenue dans sihati !',
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
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Center(
                      child: Text(
                        "Inscrivez-vous sur l'application, demandez un medecin où que vous soyez et avoir des soins de santé de bonne qualité. ",
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
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
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