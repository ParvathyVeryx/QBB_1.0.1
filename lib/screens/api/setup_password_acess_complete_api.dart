import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setPasswordAccessSetupNotCompleted(
  String qid,
  String language,
  BuildContext context,
) async {
  try {
    // Retrieve token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available in shared preferences
      return;
    }

    final String url =
        '$base_url/SetPasswordAccessSetupNotCompleted?QID=$qid&language=$language';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: json.decode(response.body)["Message"]);
        },
      );
      // Handle the response data if needed
    } else {
      showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: json.decode(response.body)["Message"]);
        },
      );
    }
  } catch (error) {}
}
