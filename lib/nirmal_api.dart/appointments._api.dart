import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> viewAppointments(
    String qid, int page, String language) async {
  try {
    // Get the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ??
        ''; // Replace 'auth_token' with your actual key

    // Check if the token is available
    if (token.isEmpty) {
      print('Error: Token not found in shared preferences.');
      return [];
    }

    // Construct the request URL
    String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/ViewAppointmentsAPI';
    String requestUrl = '$apiUrl?qid=$qid&page=$page&language=$language';

    // Make the GET request with the token in the headers
    var response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      },
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse and handle the response body
      var responseBody = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseBody);
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
      return []; // Return an empty list in case of an error
    }
  } catch (e, stackTrace) {
    print('Exception during API request: $e');
    print('StackTrace: $stackTrace');
    return []; // Return an empty list in case of an exception
  }
}
