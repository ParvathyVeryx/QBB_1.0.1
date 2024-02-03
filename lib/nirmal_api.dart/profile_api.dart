import 'dart:convert';
import 'dart:io';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> callUserProfileAPI(
//     BuildContext context, String email, int maritalId) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String qid = prefs.getString("userQID").toString();
//   var lang = 'langChange'.tr;
//   // final String apiUrl =
//   //     "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI";

//   final Map<String, dynamic> requestBody = {
//     "QID":
//         "$qid", // Assuming this value is constant, if not, pass it as a parameter as well
//     "Email": email,
//     "MaritalId": maritalId,
//     "language": "$lang",
//   };
//   String? userID = prefs.getString("userID");
//   String? userDetails = prefs.getString("userDetails");
//   print(userDetails.toString() + "UserID");

//   final String apiUrl =
//       "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI?UserId=$userID&language=${requestBody['language']}";
//   print(apiUrl);

//   String token = prefs.getString('token') ?? '';
//   print(token);

//   final http.Response response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       'Authorization': 'Bearer ${token.replaceAll('"', '')}',
//     },
//     body: jsonEncode(requestBody),
//   );

//   print(response.body);
//   print(response.statusCode);
//   print(jsonEncode(requestBody));

//   if (response.statusCode == 200) {
//     // Successful response, you can handle the data here
//     showDialog(
//         context: context, // Use the context of the current screen
//         builder: (BuildContext context) {
//           return ErrorPopup(errorMessage: response.body);
//         });
//   } else {
//     // Error handling, you can log or display an error message
//     showDialog(
//         context: context, // Use the context of the current screen
//         builder: (BuildContext context) {
//           return ErrorPopup(errorMessage: response.body);
//         });
//   }
// }
Future<void> callUserProfileAPI(
    BuildContext context, String email, int maritalId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String qid = prefs.getString("userQID").toString();
  var lang = 'langChange'.tr;

  final Map<String, dynamic> requestBody = {
    "QID": qid,
    "Email": email,
    "MaritalId": maritalId,
    "language": lang,
  };

  String? userID = prefs.getString("userID");
  final String apiUrl =
      "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI?UserId=$userID&language=${requestBody['language']}";

  String token = prefs.getString('token') ?? '';

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print("Request URL: $apiUrl");
    print("Request Headers: ${{
      'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      'Content-Type': 'application/json',
    }}");
    print("Request Body: ${jsonEncode(requestBody)}");
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      // Successful response, display a success popup or handle it accordingly
            showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(20.0), // Adjust the radius as needed
              ),
            ),
            title: const Text(
              '',
              style: TextStyle(color: primaryColor),
            ),
            content: Text(
              json.decode(response.body)["Message"],
              style: const TextStyle(color: primaryColor),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                child: Text('ok'.tr),
              ),
            ],
          );
        },
      );
    } else {
      // Unsuccessful response, display an error popup or handle it accordingly
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(20.0), // Adjust the radius as needed
              ),
            ),
            title: const Text(
              '',
              style: TextStyle(color: primaryColor),
            ),
            content: Text(
              json.decode(response.body)["Message"],
              style: const TextStyle(color: primaryColor),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                child: Text('ok'.tr),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    // Handle exceptions, e.g., network errors
    print("Error: $error");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: "An error occurred");
      },
    );
  } finally {
    // Add any cleanup code here if needed
  }
}
