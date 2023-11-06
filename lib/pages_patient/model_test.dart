import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatelessWidget {
  TextEditingController specialityController = TextEditingController();
  TextEditingController baladiaController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: specialityController,
              decoration: InputDecoration(labelText: 'Speciality'),
            ),
            TextField(
              controller: baladiaController,
              decoration: InputDecoration(labelText: 'Baladia'),
            ),
            TextField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: longitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            ElevatedButton(
              onPressed: () {
                String speciality = specialityController.text;
                String baladia = baladiaController.text;
                double latitude =
                    double.tryParse(latitudeController.text) ?? 0.0;
                double longitude =
                    double.tryParse(longitudeController.text) ?? 0.0;

                // Create a JSON object with the data to be sent
                Map<String, dynamic> data = {
                  'speciality': speciality,
                  'baladia': baladia,
                  'latitude': latitude,
                  'longitude': longitude
                };

                // Convert the data to JSON string
                String jsonData = jsonEncode(data);

                // Convert the string URL to a Uri object
                Uri url = Uri.parse(
                    'https://brahimkedjar.pythonanywhere.com/model_kmeans_classifying_patients_200.py');

                // Make an HTTP POST request to the Flask app
                http.post(url, body: jsonData).then((response) {
                  // Handle the response from Flask, if needed
                  print('Response: ${response.body}');
                }).catchError((error) {
                  // Handle any error that occurs during the request
                  print('Error: $error');
                });
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}


/*double radians(double degrees) {
  return degrees * pi / 180.0;
}

double haversineDistance(double lat1, double lng1, double lat2, double lng2) {
  double R = 6371; // radius of the Earth in km

  // convert latitude and longitude coordinates to radians
  lat1 = radians(lat1);
  lng1 = radians(lng1);
  lat2 = radians(lat2);
  lng2 = radians(lng2);

  // calculate the differences in latitude and longitude
  double dlat = lat2 - lat1;
  double dlng = lng2 - lng1;

  // apply the Haversine formula
  double a =
      pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlng / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c;

  return distance;
}

Future<Map<int, List<Tuple2<double, double>>>> assignGroup(
    double lat, double lng, String speciality, String baladia,
    {int maxGroupSize = 3}) async {
  var connection = PostgreSQLConnection(
    'abul.db.elephantsql.com',
    5432,
    'isrmxiqe',
    username: 'isrmxiqe',
    password: 'yQyk5XUzALGp2heEN84hnW_FLrRbYeQf',
  );

  await connection.open();

  List<Map<String, dynamic>> existingPatients =
      await connection.mappedResultsQuery(
    'SELECT * FROM patients',
  );

  Map<int, List<Tuple2<double, double>>> groupDict = {};

  if (existingPatients.isEmpty) {
    await connection.execute(
      'INSERT INTO patients (latitude, longitude, group_id, speciality, baladia) VALUES (@lat, @lng, 1, @speciality, @baladia)',
      substitutionValues: {
        'lat': lat,
        'lng': lng,
        'speciality': speciality,
        'baladia': baladia,
      },
    );

    groupDict = {
      1: [Tuple2<double, double>(lat, lng)],
    };
  } else {
    List<Tuple2<double, double>> patientCoords = [];
    List<int> groupIds = [];
    Map<int, int> groupSizes = {};

    for (var patient in existingPatients) {
      double? patientLat = patient['latitude'] as double?;
      double? patientLng = patient['longitude'] as double?;
      int? groupId = patient['group_id'] as int?;
      String? patientSpeciality = patient['speciality'] as String?;
      String? patientBaladia = patient['baladia'] as String?;

      if (patientLat != null &&
          patientLng != null &&
          groupId != null &&
          patientSpeciality != null &&
          patientBaladia != null) {
        if (patientSpeciality == speciality && patientBaladia == baladia) {
          patientCoords.add(Tuple2<double, double>(patientLat, patientLng));
          groupIds.add(groupId);
          groupSizes[groupId] =
              groupSizes.containsKey(groupId) ? groupSizes[groupId]! + 1 : 1;
        }
      }
    }

    List<int> availableGroups = [];

    for (var groupId in groupSizes.keys) {
      if (groupSizes[groupId]! < maxGroupSize) {
        availableGroups.add(groupId);
      }
    }

    if (availableGroups.isEmpty) {
      // all groups are full, create a new group
      int newGroupId = 1;
      await connection.execute(
        'INSERT INTO patients (latitude, longitude, group_id, speciality, baladia) VALUES (@lat, @lng, @groupId, @speciality, @baladia)',
        substitutionValues: {
          'lat': lat,
          'lng': lng,
          'groupId': newGroupId,
          'speciality': speciality,
          'baladia': baladia,
        },
      );
      groupDict[newGroupId] = [
        Tuple2<double, double>(lat, lng),
      ];
    } else {
      // assign the patient to an available group
      int groupId = availableGroups[0];
      await connection.execute(
        'INSERT INTO patients (latitude, longitude, group_id, speciality, baladia) VALUES (@lat, @lng, @groupId, @speciality, @baladia)',
        substitutionValues: {
          'lat': lat,
          'lng': lng,
          'groupId': groupId,
          'speciality': speciality,
          'baladia': baladia,
        },
      );
      groupDict[groupId] ??= [];
      groupDict[groupId]!.add(Tuple2<double, double>(lat, lng));
    }
  }
  await connection.close();
  return Future.value(groupDict);
}
*/
