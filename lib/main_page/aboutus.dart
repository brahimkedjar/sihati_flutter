import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/aboutus.png',
                width: 200.0,
                height: 200.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Notre équipe',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Nous sommes une équipe de développeurs passionnés par la santé et la technologie. Notre mission est de faciliter l\'accès aux soins de santé pour tous, en particulier dans les zones les plus éloignées et les plus défavorisées.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Contactez-nous',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Si vous avez des questions ou des commentaires sur notre application, n\'hésitez pas à nous contacter par e-mail à l\'adresse suivante : contact@monapplicationdesante.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 25.0),
              Text(
                'Sihati',
                style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15.0),
              Text(
                'Une meilleure expérience de santé',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
