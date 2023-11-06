import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 237, 243, 1.0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  80,
                  MediaQuery.of(context).size.width * 0.1,
                  0),
              height: 250,
              width: 250,
              child: Image.asset("assets/images/avis1.png"),
            ),
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
              padding: EdgeInsets.only(top: 50),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: const Center(
                      child: Text(
                        'Contactez-nous sur :',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Source_Sans_Pro',
                          color: Colors.black, // Set the text color to blue
                          fontSize: 26.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'amanigham@gmail.com',
                            //queryParameters: {'subject': 'User Feedback', 'body': _commentController.text},
                          );
                          if (await canLaunch(emailLaunchUri.toString())) {
                            await launch(emailLaunchUri.toString());
                          } else {
                            throw 'Could not launch $emailLaunchUri';
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.width * 0.12,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/gmaill.png'),
                              fit: BoxFit.cover, // specify the fit type
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          const url =
                              'https://web.facebook.com/profile.php?id=100085923417471';
                          final facebookSchemeUrl =
                              'fb://page/100085923417471'; // Replace <page-id> with your Facebook page ID
                          final fallbackUrl =
                              'https://www.facebook.com/<page-id>'; // Replace <page-id> with your Facebook page ID
                          if (await canLaunch(facebookSchemeUrl)) {
                            await launch(facebookSchemeUrl);
                          } else {
                            await launch(fallbackUrl);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          height: MediaQuery.of(context).size.width * 0.13,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/fbb.png'),
                              fit: BoxFit.cover, // specify the fit type
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () =>
                            launch('instagram://user?username=amanighmd'),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.width * 0.12,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/cinst.png'),
                              fit: BoxFit.cover, // specify the fit type
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: const Center(
                      child: Text(
                        'Nous sommes impatients de recevoir votre opinion sur notre service 😊  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Source_Sans_Pro',
                          color: Colors.black, // Set the text color to blue
                          fontSize: 18.0,
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
