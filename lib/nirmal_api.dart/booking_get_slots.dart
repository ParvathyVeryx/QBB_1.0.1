import 'dart:convert';

import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

Future<ApiResponse> bookAppointmentApiCall(
  BuildContext context,
  String studyId,
  String visitTypeId,
  String visitTypeName,
) async {
  String? qid = await getQIDFromSharedPreferences();

  if (qid != null) {
    print('QID: $qid');
  } else {
    print('Failed to retrieve QID');
  }
  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  if (personGradeId != null) {
    print('PersonGradeId: $personGradeId');
  } else {
    print('Failed to retrieve PersonGradeId');
  }

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
    'language': 'en',
  }; // Print study parameters before making the API call
  print('Study Parameters:');
  print('qatarid: ${queryParams['qatarid']}');
  print('StudyId: ${queryParams['StudyId']}');
  print('VisitTypeId: ${queryParams['VisitTypeId']}');
  print('Pregnant: ${queryParams['Pregnant']}');
  print('PersonGradeId: ${queryParams['PersonGradeId']}');
  print('VisitName: ${queryParams['VisitName']}');
  print('page: ${queryParams['page']}');
  print('language: ${queryParams['language']}');

  final Uri uri = Uri.parse(
      '$apiUrl?qatarid=${queryParams['qatarid']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&VisitName=${queryParams['VisitName']}&page=${queryParams['page']}&language=${queryParams['language']}');
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');
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
      print('API Response: ${response.body}');

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(jsonResponse);

      // Return the ApiResponse
      return apiResponse;
    } else {
      // Handle errors
      print('API Call Failed. Status Code: ${response.statusCode}');
      print('Error Message: ${response.body}');
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(errorMessage: response.body);
          });
      // Return an ApiResponse with error information
      return ApiResponse(
          success: false, message: 'API Call Failed', data: null);
    }
  } catch (error) {
    // Handle network errors
    print('Error: $error');

    // Return an ApiResponse with error information
    return ApiResponse(success: false, message: 'Network Error', data: null);
  }
}
