import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;

Future<void> accessSetupOTP({
  required String qid,
  required String otp,
  required String userPassword,
  required String userId,
  required String language,
  required BuildContext context,
}) async {
  final url = Uri.parse('$base_url/AcessSetupOTP');
  // Print the request before making the HTTP call
  print('Request: ${url.toString()}');
  String encryptedPassword = _sha512(userPassword);
  print(encryptedPassword);
  Map<String, dynamic> requestBody = {
    'QID': qid,
    'OTP': otp,
    'UserPassword': encryptedPassword, // Fix: Pass the encrypted password here
    'Userid': userId,
    'language': language,
  };

  print('Body: ${jsonEncode(requestBody)}');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(errorMessage: response.body);
          });
      // Handle successful response
      print('API call successful');
      print(response.body);
    } else {
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(errorMessage: response.body);
          });
      // Handle error
      print('API call failed with status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    // Handle network errors
    showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: 'Error: $e.');
        });
  }
}

String _sha512(String input) {
  var bytes = utf8.encode(input);
  var digest = crypto.sha512.convert(bytes);
  return digest.toString();
}
