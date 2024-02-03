import 'dart:convert';
import 'dart:io';
import 'package:QBB/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> uploadUserProfilePhoto(BuildContext context, String qid, File photo) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String qid = pref.getString("userQID").toString();
  try {
    // Read the file as bytes
    List<int> photoBytes = await photo.readAsBytes();

    // Encode the bytes to base64
    String base64Photo = base64Encode(photoBytes);
    String? token = pref.getString('token');

    // Append the 'data:image/png;base64,' prefix to the base64-encoded photo
    String prefixedBase64Photo = 'data:image/png;base64,' + base64Photo;

    // Prepare the request body as a Map
    Map<String, dynamic> requestBody = {
      'QID': qid,
      'Photo': prefixedBase64Photo,
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(requestBody);
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
    };

    // Make the API call using http.post
    var response = await http.post(
      Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfilePhotoAPI'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
      },
      body: requestBodyJson,
    );
    print(response.body);
    print(response.statusCode);
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Check if the response is JSON
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        // Parse the response body as JSON
        var responseBody = json.decode(response.body);
        
      } else {
        // Handle non-JSON response (e.g., log or print the raw response)
      }
              showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(''),
              content: Text(json.decode(response.body)["Message"]),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
    }
  } catch (e, stackTrace) {}
}
