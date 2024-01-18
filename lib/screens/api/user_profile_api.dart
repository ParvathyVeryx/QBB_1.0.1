import 'package:QBB/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getUserProfile(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lang = prefs.getString("langEn").toString();
  String setLang;
  if (lang == "true") {
    setLang = "en";
  } else {
    setLang = "ar";
  }

  final apiUrl = '$base_url/UserProfileAPI';
  final token = prefs.getString('token');

  print('API URL: $apiUrl');
  print('Bearer Token: $token');

  final response = await http.post(
    Uri.parse('$apiUrl?id=$id&language=$setLang'), // Include id in the URL
    headers: {
      'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('API Response Body: ${response.body}');
    return json.decode(response.body);
  } else {
    print('API Error Response: ${response.body}');
    throw Exception('Failed to load user profile: ${response.statusCode}');
  }
}
