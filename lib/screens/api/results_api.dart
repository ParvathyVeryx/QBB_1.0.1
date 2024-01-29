import 'dart:convert';

import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getresults(
  BuildContext context,
  String qid,
  String appointmentId,
  String language,
) async {
  String? qid = await getQIDFromSharedPreferences();

  if (qid != null) {
    print('QID: $qid');
  } else {
    print('Failed to retrieve QID');
  }
  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  if (personGradeId != null) {
    print('PersonGradeId: $personGradeId');
  } else {
    print('Failed to retrieve PersonGradeId');
  }

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'AppointmentID': appointmentId,
    'language': 'langChange'.tr,
  };

  print('Study Parameters:');
  print('qatarid: ${queryParams['QID']}');
  print('AppointmentID: ${queryParams['AppointmentID']}');
  print('language: ${queryParams['language']}');

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&AppointmentID=${queryParams['AppointmentID']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    final response = await http.get(
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

      const String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';
      getOTPForDownload(context);

      // Now, navigate to the AppointmentBookingPage
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const AppointmentBookingPage(),
      //   ),
      // );
    } else {
      // Handle errors
      print('API Call Failed. Status Code: ${response.statusCode}');
      print('Error Message: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: json.decode(response.body)["Message"]);
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

Future<void> getOTPForDownload(
  BuildContext context,
) async {
  // String qid = '';
  String otp = '';
  String appointmentId = '';
  String language = '';
  String? qid = await getQIDFromSharedPreferences();

  if (qid != null) {
    print('QID: $qid');
  } else {
    print('Failed to retrieve QID');
  }
  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  if (personGradeId != null) {
    print('PersonGradeId: $personGradeId');
  } else {
    print('Failed to retrieve PersonGradeId');
  }

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetResultDataAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'OTP': otp,
    'AppointmentID': appointmentId,
    'language': 'langChange'.tr,
  };

  print('Study Parameters:');
  print('qatarid: ${queryParams['QID']}');
  print('AppointmentID: ${queryParams['AppointmentID']}');
  print('language: ${queryParams['language']}');

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&AppointmentID=${queryParams['AppointmentID']}&OTP=${queryParams['OTP']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    final response = await http.get(
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

      const String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

      // Now, navigate to the AppointmentBookingPage
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const AppointmentBookingPage(),
      //   ),
      // );
    } else {
      // Handle errors
      print('API Call Failed. Status Code: ${response.statusCode}');
      print('Error Message: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: json.decode(response.body)["Message"]);
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
