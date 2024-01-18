import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> bookAppointmentApiCall() async {
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentAPI';

  final String? token = await getAuthToken();

  if (token == null) {
    // Handle the case where the token is not available
    print('Authentication token not available');
    return;
  }

  final Map<String, dynamic> requestBody = {
    "qatarid": "28900498437",
    "StudyId": "10",
    "ShiftCode": null,
    "VisitTypeId": "72",
    "PersonGradeId": null,
    "AvailabilityCalenderId": null,
    "AppoinmentId": "",
    "language": "en",
    "AppointmentTypeId": null,
  };

  final Map<String, String> queryParams = {
    "qatarid": "28900498437",
    "StudyId": "10",
    "ShiftCode": "",
    "VisitTypeId": "72",
    "PersonGradeId": "",
    "AvailabilityCalenderId": "",
    "AppoinmentId": "",
    "language": "en",
    "AppointmentTypeId": "",
  };

  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request was successful, you can handle the response here
      print('API call successful');
      print(response.body);
    } else {
      // Request failed, handle the error
      print('API call failed with status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    // Handle any exceptions that occur during the API call
    print('Error during API call: $e');
  }
}
