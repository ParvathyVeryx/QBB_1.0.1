import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getAccess(String qid, String otp, BuildContext context) async {
  // Retrieve token from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    // Handle the case where the token is not available in shared preferences
    print('Error: Token not found in shared preferences');
    return false;
  }

  final Map<String, dynamic> verify = {
    'QID': qid,
    'OTP': otp,
  };

  print(verify);

  final String verifyOtp =
      '$base_url/AcessSetupOTP?QID=${verify['QID']}&OtpToken=${verify['OTP']}';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
  };

  try {
    final http.Response response =
        await http.get(Uri.parse(verifyOtp), headers: headers);

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var userId = json.decode(response.body);
      showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );
      return true; // Return true if OTP verification is successful
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      return false; // Return false to indicate OTP verification failure
    }
  } catch (err) {
    // Handle network errors
    print('Error: $err');
    return false; // Return false to indicate OTP verification failure
  }
}
