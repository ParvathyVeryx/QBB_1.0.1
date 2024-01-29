import 'dart:convert';
import 'dart:io';
// import 'dart:js';
import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../nirmal/login_screen.dart';

Future<void> signOut(BuildContext context) async {
  // String qid = '';

  String? qid = await getQIDFromSharedPreferences();

  if (qid != null) {
    print('QID: $qid');
  } else {
    print('Failed to retrieve QID');
  }

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/LogoutAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse('$apiUrl?QID=${queryParams['QID']}');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successful API call
      print('API Response: ${response.body}');

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Save the API response in shared preferences
      print(response.body);

      // Now, navigate to the AppointmentBookingPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false, );
    } else {
      // Handle errors
      print('API Call Failed. Status Code: ${response.statusCode}');
      print('Error Message: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );
    }
  } catch (error) {
    // Handle network errors
    print('Error: $error');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}
