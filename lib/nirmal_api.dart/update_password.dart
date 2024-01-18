import 'dart:convert';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> UpdatePasswordAPI(
  String qid,
  String otp,
  String password,
  BuildContext context, // Added password parameter
) async {
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UpdatePasswordAPI';

  // Get the token from shared preferences
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('token') ?? ''; // Replace with your token key

  final Map<String, String> headers = {
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> requestBody = {
    'QID': qid,
    'OtpToken': otp,
    'UserPassword': password, // Pass the password parameter
    'language': 'en',
  };

  final http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON response
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        });
    return {'success': false, 'error': response.body};

    // If the server did not return a 200 OK response, throw an exception.
  }
}
