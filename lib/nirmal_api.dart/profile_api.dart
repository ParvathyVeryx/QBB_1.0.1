import 'dart:convert';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> callUserProfileAPI(
    BuildContext context, String email, int maritalId) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
  String qid = prefs.getString("userQID").toString();
  var lang = 'langChange'.tr;
  final String apiUrl =
      "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI";

  final Map<String, dynamic> requestBody = {
    "QID":
        "$qid", // Assuming this value is constant, if not, pass it as a parameter as well
    "Email": email,
    "MaritalId": maritalId,
    "language": "$lang",
  };

  final Map<String, String> headers = {
    "Authorization":
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk", // Replace with your actual token
    "Content-Type": "application/json",
  };

  final http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    // Successful response, you can handle the data here
    showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        });
  } else {
    // Error handling, you can log or display an error message
    showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        });
  }
}
