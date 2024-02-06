import 'dart:convert';

import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/book_results_appointment.dart';
import 'package:QBB/screens/pages/bookappointment_screen.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/pages/loader.dart';
import '../screens/pages/reschedule_app.dart';
import '../screens/pages/reschedule_result_app.dart';
import '../screens/pages/upcoming.dart';

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
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
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

  final Uri uri = Uri.parse(
      '$apiUrl?qatarid=${queryParams['qatarid']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&VisitName=${queryParams['VisitName']}&page=${queryParams['page']}&language=${queryParams['language']}');
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
    print("Print Response");
    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      BookAppScreenState myWidget = BookAppScreenState();
      String result =
          await myWidget.getAvailabilityCalendar("yourAvailabilityCalendar");
      pref.setString("availabilityCalendarId",
          jsonResponse["AvailabilityCalenderId"].toString());

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
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      showDialog(
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> GetRescheduleAppointment(
    BuildContext context,
    String studyId,
    String visitTypeId,
    String visitTypeName,
    String appID,
    String appointmentDate) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  String? qid = await getQIDFromSharedPreferences();
  Future<String> appDateFuture = Future.value(appointmentDate);

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/RescheduleAppointmentAPI';

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
  RescheduleAppState myWidget = RescheduleAppState();
  myWidget.getAppID(appID);
  pref.setString("appoinmentID", appID);
  final Uri uri = Uri.parse(
      '$apiUrl?qatarid=${queryParams['qatarid']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&VisitName=${queryParams['VisitName']}&page=${queryParams['page']}&language=${queryParams['language']}');
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
      // BookAppScreenState myWidget = BookAppScreenState();
      // String result =
      //     await myWidget.getAvailabilityCalendar("yourAvailabilityCalendar");
      pref.setString("availabilityCalendarId",
          jsonResponse["AvailabilityCalenderId"].toString());

      // Save the API response in shared preferences
      pref.setString('apiResponseReschedule', json.encode(jsonResponse));
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

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => RescheduleApp(appDate: appDateFuture)),
      );
    } else {
      // Handle errors
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      showDialog(
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> GetResultRescheduleAppointment(
    BuildContext context,
    String studyId,
    String visitTypeId,
    String visitTypeName,
    String appID,
    String appointmentDate) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  String? qid = await getQIDFromSharedPreferences();
  Future<String> appDateFuture = Future.value(appointmentDate);
  SharedPreferences pref = await SharedPreferences.getInstance();
  String appID = pref.getString("resultsAppID").toString();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/RescheduleResultAppointmentAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'StudyId': studyId,
    'VisitTypeId': visitTypeId,
    'Pregnant': 'null',
    'PersonGradeId': personGradeId,
    // 'VisitName': visitTypeName,
    'AppointmentId': appID,
    'page': '1',
    'language': 'langChange'.tr,
  };

  // final Uri urinew = Uri.parse(
  //     "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetReasonForCancelAppoinmentAPI?language=en");
  String? token = pref.getString('token');
  // final responsen = await http.get(
  //   urinew,
  //   headers: {
  //     'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
  //     'Content-Type': 'application/json',
  //   },
  // );
  RescheduleAppState myWidget = RescheduleAppState();
  myWidget.getAppID(appID);
  pref.setString("ResultsappoinmentID", appID);
  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AppointmentId=${queryParams['AppointmentId']}&page=${queryParams['page']}&language=${queryParams['language']}');
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

    print("Reschedule Result");

    if (response.statusCode == 200) {
      // Successful API call
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // BookAppScreenState myWidget = BookAppScreenState();
      // String result =
      //     await myWidget.getAvailabilityCalendar("yourAvailabilityCalendar");
      pref.setString("availabilityCalendarId",
          jsonResponse["AvailabilityCalenderId"].toString());

      // Save the API response in shared preferences
      pref.setString('apiResponseReschedule', json.encode(jsonResponse));
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

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => RescheduleResult(appDate: appDateFuture)),
      );
    } else {
      // Handle errors
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      showDialog(
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
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
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
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
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
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle errors

      showDialog(
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
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  String? qid = await getQIDFromSharedPreferences();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentapi';

  final Map<String, dynamic> queryParams = {
    'isResultGetAppointment': 'true',
    'QID': qid,
    'StudyId': studyId,
    'VisitTypeId': visitTypeId,
    'Pregnant': 'null',
    'PersonGradeId': personGradeId,
    'AppointmentId': AppointmentId,
    // 'page': '1',
    // 'language': 'langChange'.tr,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?isResultGetAppointment=${queryParams['isResultGetAppointment']}&QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AppointmentId=${queryParams['AppointmentId']}');
  print(uri);

  // final Uri uri = Uri.parse(
  //     '$apiUrl?isResultGetAppointment=${queryParams['isResultGetAppointment']}&QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AppointmentId=${queryParams['AppointmentId']}&page=${queryParams['page']}&language=${queryParams['language']}');
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
    } else {
      // Handle errors
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      showDialog(
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> getResultsSlot(BuildContext context, String studyId,
    String visitTypeId, String visitTypeName, String appointmentID) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  String? qid = await getQIDFromSharedPreferences();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookResultAppointmentAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'StudyId': studyId,
    'VisitTypeId': visitTypeId,
    'Pregnant': 'null',
    'PersonGradeId': personGradeId,
    'AppointmentId': appointmentID,
    'VisitName': visitTypeName,
    'page': '1',
    'language': 'langChange'.tr,
  };

  // final Uri urinew = Uri.parse(
  //     "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetReasonForCancelAppoinmentAPI?language=en");
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&Pregnant=${queryParams['Pregnant']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AppointmentId=${queryParams['AppointmentId']}&VisitName=${queryParams['VisitName']}&page=${queryParams['page']}&language=${queryParams['language']}');
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
      BookAppScreenState myWidget = BookAppScreenState();
      String result =
          await myWidget.getAvailabilityCalendar("yourAvailabilityCalendar");
      pref.setString("availabilityCalendarId",
          jsonResponse["AvailabilityCalenderId"].toString());

      // Save the API response in shared preferences
      pref.setString('apiResponseResults', json.encode(jsonResponse));
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
          builder: (context) => BookResults(),
        ),
      );
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle errors

      showDialog(
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
    BuildContext context,
    GlobalKey key,
    Widget? child,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}
