import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> accessSetupOTP({
  required String qid,
  required String otp,
  required String userPassword,
  required String userId,
  required String language,
  required BuildContext context,
}) async {
  try {
    // Retrieve token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available in shared preferences
      print('Error: Token not found in shared preferences');
      return;
    }

    final url = Uri.parse('$base_url/AcessSetupOTP');
    // Print the request before making the HTTP call
    print('Request: ${url.toString()}');
    String encryptedPassword = _sha512(userPassword);
    print(encryptedPassword);
    Map<String, dynamic> requestBody = {
      'QID': qid,
      'OTP': otp,
      'UserPassword': encryptedPassword,
      'Userid': userId,
      'language': language,
    };

    print('Body: ${jsonEncode(requestBody)}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );
      // Handle successful response
      print('API call successful');
      print(response.body);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );

      // Handle error
      print('API call failed with status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    // Handle network errors
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Error: $e.');
      },
    );
  }
}

String _sha512(String input) {
  var bytes = utf8.encode(input);
  var digest = crypto.sha512.convert(bytes);
  return digest.toString();
}
