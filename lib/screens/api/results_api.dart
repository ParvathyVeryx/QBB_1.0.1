import 'dart:convert';

import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../nirmal_api.dart/profile_api.dart';
import '../pages/loader.dart';

Future<void> getresults(
  BuildContext context,
  String qid,
  String appointmentId,
  String language,
) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  String? qid = await getQIDFromSharedPreferences();
  final TextEditingController _textFieldController = TextEditingController();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'AppointmentID': appointmentId,
    'language': 'langChange'.tr,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&AppointmentID=${queryParams['AppointmentID']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Save the API response in shared preferences

      const String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

      // Now, navigate to the AppointmentBookingPage
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const AppointmentBookingPage(),
      //   ),
      // );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(50.0), // Adjust the radius as needed
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: 'pleaseEnterOTPToDownloadTheResult'.tr),
                ),
              ),
              actions: <Widget>[
                Divider(),
                TextButton(
                  onPressed: () async {
                    String otp = _textFieldController.toString();
                    await getOTPForDownload(context, appointmentId, otp);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text(
                    'ok'.tr,
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            );
          });
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle errors
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );
    }
  } catch (error) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Handle network errors
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> getOTPForDownload(
    BuildContext context, String appointmentId, String otp) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  // String qid = '';
  String language = 'langChange'.tr;
  String? qid = await getQIDFromSharedPreferences();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetResultDataAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'OTP': otp,
    'AppointmentID': appointmentId,
    'language': 'langChange'.tr,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&AppointmentID=${queryParams['AppointmentID']}&OTP=${queryParams['OTP']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successful API call
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Save the API response in shared preferences

      const String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';
    } else {
      // Handle errors
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );
    }
  } catch (error) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Handle network errors
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}
