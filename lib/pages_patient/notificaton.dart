import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PatientNotifications extends StatefulWidget {
  @override
  _PatientNotificationsState createState() => _PatientNotificationsState();
}

class _PatientNotificationsState extends State<PatientNotifications> {
  List<String> notifications = []; // List to store received notifications

  // Function to fetch notifications from API
  void _showNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int patientId = prefs.getInt('patient_id')!;
      // Replace the API_URL with the actual URL of your backend API endpoint
      final String apiUrl =
          'sihati.univ-setif.dz/get_notifications'; // Update with your actual API URL

      // Get the patient ID from your app's state or wherever it's stored

      // Make a GET request to the API with the patient_id as a query parameter
      final response =
          await http.get(Uri.parse('$apiUrl?patient_id=$patientId'));

      if (response.statusCode == 200) {
        // Parse the response body and extract the notifications
        List<dynamic> notifications = jsonDecode(response.body);

        // Implement the logic to show the notifications in your app's UI
        // For example, you can display the notifications in a modal dialog or a bottom sheet
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Notifications'),
              content: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(notifications[index]['message']),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to fetch notifications');
        // Handle failure
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    _showNotifications(); // Fetch notifications when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Notifications'),
      ),
      body: IconButton(
        icon: Icon(
            Icons.notifications), // Replace with the actual notification icon
        onPressed: () {
          _showNotifications();
        },
      ),
    );
  }
}
