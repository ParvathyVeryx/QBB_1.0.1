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
      return;
    }

    final url = Uri.parse('$base_url/AcessSetupOTP');

    String encryptedPassword = _sha512(userPassword);
    Map<String, dynamic> requestBody = {
      'QID': qid,
      'OTP': otp,
      'UserPassword': encryptedPassword,
      'Userid': userId,
      'language': language,
    };

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
          return ErrorPopup(errorMessage: json.decode(response.body)["Message"]);
        },
      );
      // Handle successful response
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: json.decode(response.body)["Message"]);
        },
      );

      // Handle error
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
