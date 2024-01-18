import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getNotifications(context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString("token").toString();
  print('kkkklkl' + token.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;

    
  var uri =
      Uri.parse(base_url + 'GetNotificationsAPI?language=$lang&QID=28900498437');

  final response = await http.get(uri, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials":
        'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS"
  });

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response,
    // parse the response body and return it.
    print('llllllllllllllllllllllllllllllllllllllllll' +
        response.body.toString());
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // throw an exception.
    throw Exception('Failed to load notifications');
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      dynamic response = await getNotifications(context);
      setState(() {
        notifications = List<Map<String, dynamic>>.from(response['data']);
      });
      print('hhhhhhhhhhhhhhhhhhhhh' + response.toString());
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Screen'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> notification = notifications[index];
          String message = notification['message'];
          String data = notification['data'];
          String time = notification['time'];

          return Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message: $message',
                  style: const TextStyle(color: Colors.black),
                ),
                Text('Data: $data'),
                Text('Time: $time'),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Your getNotifications function remains the same.
