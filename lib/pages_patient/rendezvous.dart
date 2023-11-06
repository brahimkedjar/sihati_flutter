import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Rndv extends StatefulWidget {
  const Rndv({Key? key}) : super(key: key);

  @override
  State<Rndv> createState() => _RndvState();
}

class _RndvState extends State<Rndv> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  late SharedPreferences _prefs;
  late int patientId = 0;
  List<dynamic> notifications = [];
  List<dynamic> imageUrls = [];

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    int? patientId = prefs.getInt('patient_id');
    final url = Uri.parse(
        'http://sihati.univ-setif.dz/api/v1/get_rndv?patient_id=$patientId');

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData != null) {
        setState(() {
          notifications = jsonData["notifications"];
          imageUrls = jsonData["image_urls"];
        });
      } else {
        throw Exception('Notifications object not found');
      }
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  void initState() {
    super.initState();
    fetchNotifications();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('z');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    Future onSelectNotification(String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      // handle notification tapped logic here
    }

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> _scheduleReminder(int index) async {
    String? appointmentDateText = notifications[index][
        'text2']; // assuming you want to get the appointment date from the first item in the list
    print(appointmentDateText);
    DateTime appointmentDateTime =
        DateTime.parse(appointmentDateText!).toLocal();
    var scheduledNotificationDateTime =
        appointmentDateTime.subtract(const Duration(days: 1));
    if (scheduledNotificationDateTime.isAfter(DateTime.now())) {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          'Channel for Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

      var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.schedule(
          index,
          "n'oubliez pas votre rendez vous de demain",
          'avec ${notifications[index]['text1']} dans le ${notifications[index]['text3']}',
          scheduledNotificationDateTime,
          platformChannelSpecifics);
    }
  }

  List<bool> _pressedList = List.generate(10, (_) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 237, 243, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0.0, // Set the elevation to 0.0
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  0,
                  0,
                  MediaQuery.of(context).size.width * 0.02),
              height: 233,
              width: 300,
              child: Image.asset("assets/images/app.png"),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final doctorName = notification['doctor_name'];
                    final doctorSpeciality = notification['doctor_speciality'];
                    final appointmentDate = notification['appointment_date'];
                    String shortDate = appointmentDate.substring(0, 10);

                    final place = notification['place'];
                    final doctorImageUrl = imageUrls[index];
                    final id = index;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            offset: const Offset(-6, -6),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width -
                            40, // adjust the width as needed

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                            NetworkImage(doctorImageUrl),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              'Dr. ${doctorName}',
                                              style: const TextStyle(
                                                fontFamily: 'SourceSansPro',
                                                color: Colors.black,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              ' ${doctorSpeciality}',
                                              style: const TextStyle(
                                                fontFamily: 'SourceSansPro',
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 400, // adjust the width as needed
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.watch_later_outlined,
                                                color: Colors.grey,
                                                size: 15),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${shortDate}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Row(
                                          children: [
                                            const Icon(Icons.place_outlined,
                                                color: Colors.grey, size: 15),
                                            const SizedBox(width: 5),
                                            Text(
                                              'centre de ${place}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _scheduleReminder(id);
                                setState(() {
                                  _pressedList[id] = true;
                                });
                              },
                              icon: Icon(
                                _pressedList[id]
                                    ? Icons.notifications_active
                                    : Icons.notifications_none_outlined,
                                color: _pressedList[id]
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
