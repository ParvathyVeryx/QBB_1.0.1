import 'dart:convert';

import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/bookappointment_screen.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class ApiResponse {
//   final bool success;
//   final String message;
//   final dynamic data;

//   ApiResponse({required this.success, required this.message, this.data});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data,
//     };
//   }
// }
Future<void> bookAppointmentApiCall(
  BuildContext context,
  String studyId,
  String visitTypeId,
  String visitTypeName,
) async {
  String? qid = await getQIDFromSharedPreferences();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentapi';

  final Map<String, dynamic> queryParams = {
    'qatarid': qid,
    'StudyId': studyId,
    'VisitTypeId': visitTypeId,
    'Pregnant': 'null',
    'PersonGradeId': personGradeId,
    'VisitName': visitTypeName,
    'page': '1',
    'language': 'langChange'.tr,
  };

  // final Uri urinew = Uri.parse(
  //     "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetReasonForCancelAppoinmentAPI?language=en");
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');
  // final responsen = await http.get(
  //   urinew,
  //   headers: {
  //     'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
  //     'Content-Type': 'application/json',
  //   },
  // );
  final Uri uri = Uri.parse(
      '$apiUrl?qatarid=${queryParams['qatarid']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&VisitName=${queryParams['VisitName']}&page=${queryParams['page']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );
    print("Response Body for Book APp");
    print(uri);
    print(response.body);
    if (response.statusCode == 200) {
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      BookAppScreenState myWidget = BookAppScreenState();
      String result =
          await myWidget.getAvailabilityCalendar("yourAvailabilityCalendar");
      pref.setString("availabilityCalendarId",
          jsonResponse["AvailabilityCalenderId"].toString());
      print(jsonResponse["AvailabilityCalenderId"].toString());
      print("availabilty calendar");
      print(response.body);
      // Save the API response in shared preferences
      pref.setString('apiResponse', json.encode(jsonResponse));
      pref.setString("availableDates", json.encode(jsonResponse['datelist']));

      String? jsonString = pref.getString("availableDates");

// Check if the jsonString is not null
      if (jsonString != null) {
        // Use json.decode to parse the jsonString
        dynamic decodedData = json.decode(jsonString);

        // Check if the decodedData is a List
        if (decodedData is List) {
          // Now you can use the data as a List
          List<String> availableDates = List<String>.from(decodedData);

          // Use the 'availableDates' list as needed
        }
      }

      // Now, navigate to the AppointmentBookingPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookAppScreen(),
        ),
      );
    } else {
      // Handle errors

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );
    }
  } catch (error) {
    // Handle network errors
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> bookAppointmentToGetResults(
  BuildContext context,
  String Qid,
  String AppointmentTypeId,
  String AppoinmentId,
  String studyId,
  String visitTypeId,
  String availabilityCalendar,
) async {
  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  try {
    Map<String, dynamic> requestBody = {
      'QID': Qid,
      "AppointmentTypeId": AppointmentTypeId,
      "AppoinmentId": AppoinmentId,
      'StudyId': studyId,
      'AvailabilityCalenderId': visitTypeId,
      'AvailabilityCalenderId': visitTypeId,
      'AvailabilityCalenderId': availabilityCalendar,
      "ShiftCode": 'shft',
      'PersonGradeId': '$personGradeId',
      'language': 'langChange'.tr,
    };

    String apiUrl =
        "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookResultAppointmentAPI?QID=${requestBody['QID']}&StudyId=${requestBody['StudyId']}&ShiftCode=${requestBody['ShiftCode']}&VisitTypeId=${requestBody['AvailabilityCalenderId']}&PersonGradeId=${requestBody['PersonGradeId']}&AvailabilityCalenderId=${requestBody['AvailabilityCalenderId']}&AppoinmentId=${requestBody['AppoinmentId']}&language=en&AppointmentTypeId=${requestBody['AppointmentTypeId']}";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    print(apiUrl);
    final Uri uri = Uri.parse('$apiUrl');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Accept': 'application/json'
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Save the API response in shared preferences

// Check if the jsonString is not null

      // Now, navigate to the AppointmentBookingPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AppointmentBookingPage(),
        ),
      );
    } else {
      // Handle errors

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );
    }
  } catch (error) {
    // Handle network errors
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> getResultAppointmentApiCall(
  BuildContext context,
  String studyId,
  String visitTypeId,
  String AppointmentId,
) async {
  String? qid = await getQIDFromSharedPreferences();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookResultAppointmentAPI';

  final Map<String, dynamic> queryParams = {
    'qatarid': qid,
    'StudyId': studyId,
    'VisitTypeId': visitTypeId,
    'Pregnant': 'null',
    'PersonGradeId': personGradeId,
    'AppointmentId': AppointmentId,
    'page': '1',
    'language': 'langChange'.tr,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?qatarid=${queryParams['qatarid']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AppointmentId=${queryParams['AppointmentId']}&page=${queryParams['page']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
    } else {
      // Handle errors

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: response.body);
        },
      );
    }
  } catch (error) {
    // Handle network errors
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}
