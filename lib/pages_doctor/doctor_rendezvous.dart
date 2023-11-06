import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RndvMdcn extends StatefulWidget {
  const RndvMdcn({Key? key}) : super(key: key);

  @override
  State<RndvMdcn> createState() => _RndvMdcnState();
}

class _RndvMdcnState extends State<RndvMdcn> {
  late List<dynamic> notifications = [];
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    int? doctorId = prefs.getInt('doctor_id');
    final url = Uri.parse(
        'http://192.168.91.170/api/v1/get_rndv2?doctor_id=$doctorId'); // Replace with your actual API endpoint URL and include patient_id as a query parameter

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      // If the API call is successful
      setState(() {
        notifications = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<void> deleteNotification(int groupId) async {
    final prefs = await SharedPreferences.getInstance();
    int? doctorId = prefs.getInt('doctor_id');
    final url = Uri.parse('http://sihati.univ-setif.dz/api/v1/destroy');
    final response = await http.delete(url, body: {
      'doctor_id': doctorId.toString(),
      'group_id': groupId.toString()
    });
    if (response.statusCode == 200) {
      print('Notification deleted successfully');
    } else {
      print('Failed to delete notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 237, 243, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.05,
              MediaQuery.of(context).size.width * 0.05,
              0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset("assets/images/cal.png"),
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
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Column(
                    children: notifications.map((text) {
                      final shortDate1 = text['appointment_date'];

                      String shortDate = shortDate1.substring(0, 10);

                      final id = notifications.indexOf(text, 0);
                      return Dismissible(
                        key: Key(text['group_id'].toString()),
                        onDismissed: (direction) {
                          // Create a copy of the notifications list.
                          final List<Map<String, dynamic>> _notifications =
                              List.from(notifications);
                          // Remove the notification from the list.
                          _notifications.remove(text);
                          // Update the state with the modified copy of the list.
                          setState(() {
                            notifications = _notifications;
                          });
                          // Delete the notification from the backend.
                          final groupId = int.parse(text['group_id']);
                          deleteNotification(groupId);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          padding: const EdgeInsets.fromLTRB(25, 20, 15, 8),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Avec groupe ${text['group_id']}',
                                  style: const TextStyle(
                                    fontFamily: 'SourceSansPro',
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: Colors.grey,
                                        size: 15,
                                      ),
                                      Container(
                                        child: Text(
                                          ' ${shortDate}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.place_outlined,
                                          color: Colors.grey,
                                          size: 15,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              ' ${text['place']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  // TODO: Implement notification details screen
                                  print("Notification ID: $id");
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                          fontFamily: 'SourceSansPro',
                                          color: Colors.blue,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
