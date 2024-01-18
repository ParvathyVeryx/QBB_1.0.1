import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> setPasswordAccessSetupNotCompleted(
  String qid,
  String language,
  BuildContext context,
) async {
  const token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk";

  final String url =
      '$base_url/SetPasswordAccessSetupNotCompleted?QID=$qid&language=$language';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(errorMessage: response.body);
          });
      print('SetPasswordAccessSetupNotCompleted API call successful!');
      // Handle the response data if needed
    } else {
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(errorMessage: response.body);
          });
      print(
          'SetPasswordAccessSetupNotCompleted API call failed with status code: ${response.body}');
    }
  } catch (error) {
    print('Error calling SetPasswordAccessSetupNotCompleted API: $error');
  }
}
