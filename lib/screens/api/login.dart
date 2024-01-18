import 'dart:convert';
// import 'dart:js_interop';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/homescreen_nk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<void> login(BuildContext context, String qid, String password,
      String deviceToken, String? deviceType,
      {required Null Function() onApiComplete}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;

    // print('the device token is $deviceToken');

    try {
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      print('Authtoken: $token');
      if (token == null) {
        // Handle the case where the token is not available
        print('Token not found in SharedPreferences');
        return;
      }

      // Construct headers with the retrieved token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      // Encrypt the password using SHA-512
      String encryptedPassword = _sha512(password);

      // Construct the request body
      Map<String, dynamic> requestBody = {
        'UserPassword': encryptedPassword,
        'Username': qid,
        'DeviceToken': deviceToken,
        'DeviceType': deviceType,
        'Language': lang,
      };

      // Print headers and request body
      print('Headers: $headers');
      print('Request Body: $requestBody');

      // Construct the API URL
      Uri apiUrl = Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/LoginAPI');

      print('API URL: $apiUrl');

      // Make the HTTP POST request
      final response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Successful response, handle accordingly
        print('Login successful!');
        print('Response body: ${response.body}');

        // Parse the response if needed
        Map<String, dynamic> responseData = json.decode(response.body);

        // Store the entire JSON response in shared preferences
        await pref.setString(
            'userDetails', json.encode(responseData).toString());
        await pref
            .setString('userQID', json.decode(response.body)["QID"])
            .toString();
        await pref
            .setString('userFName', json.decode(response.body)["FirstName"].toString())
            ;
        await pref.setString(
            'userMName', json.decode(response.body)["MiddleName"].toString());
        await pref.setString(
            'userLName', json.decode(response.body)["LastName"].toString());
        await pref.setString(
            'userGender', json.decode(response.body)["Gender"].toString());
        await pref.setString('userHealthCardNo',
            json.decode(response.body)["HealthCardNo"].toString());
        await pref
            .setString('userDOb', json.decode(response.body)["Dob"].toString())
            ;
        await pref
            .setString('userNationality',
                json.decode(response.body)["Nationality"].toString())
            .toString();
        await pref
            .setString('userEmail', json.decode(response.body)["RecoverEmail"].toString())
            ;
        await pref
            .setString('userPhNo', json.decode(response.body)["RecoveryMobile"].toString())
            ;
        await pref
            .setString('userMaritalStatus',
                json.decode(response.body)["MaritalStatus"].toString())
            ;

        // Save user data to SharedPreferences or handle it based on your requirements
        print(
            'Stored User Details: ${pref.getString('userDetails').toString()}');

        // Navigate to the home screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorPopup(
              errorMessage: 'Error: ${response.body}',
            );
          },
        );
        // Handle error response
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // You can throw an exception or handle the error in another way
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
            errorMessage: 'Error fetching country: $e',
          );
        },
      );
      // Handle any exceptions that occurred during the request
      print('Error: $e');
    } finally {
      // Call the callback function to notify that the API is complete
      onApiComplete();
    }
  }

  // Helper method to encrypt the password using SHA-512
  static String _sha512(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha512.convert(bytes);
    return digest.toString();
  }
}
