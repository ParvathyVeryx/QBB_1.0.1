import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> bookAppointmentApiCall() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String qid = prefs.getString("userQID").toString();
  var lang = 'langChange'.tr;
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentAPI';

  final String? token = await getAuthToken();

  if (token == null) {
    // Handle the case where the token is not available
    print('Authentication token not available');
    return;
  }

  final Map<String, dynamic> requestBody = {
    "qatarid": "$qid",
    "StudyId": "10",
    "ShiftCode": null,
    "VisitTypeId": "72",
    "PersonGradeId": null,
    "AvailabilityCalenderId": null,
    "AppoinmentId": "",
    "language": "$lang",
    "AppointmentTypeId": null,
  };

  final Map<String, String> queryParams = {
    "qatarid": "$qid",
    "StudyId": "10",
    "ShiftCode": "",
    "VisitTypeId": "72",
    "PersonGradeId": "",
    "AvailabilityCalenderId": "",
    "AppoinmentId": "",
    "language": "$lang",
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
