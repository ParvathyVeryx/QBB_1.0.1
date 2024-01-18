import 'package:QBB/screens/api/userid.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> callUserProfileAPIGet() async {
  int? userId = await getUserIdFromSharedPreferences();
  print('ggggggggggggggggggggggggggggggggggggggggggg' + userId.toString());
  if (userId != null) {
    print('User ID: $userId');
  } else {
    print('Failed to retrieve user ID');
    return "Failed to retrieve user ID"; // or handle it accordingly
  }

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');
  print('Authtoken: $token');

  if (token == null) {
    print('Token is null. Unable to make API request.');
    return "Token is null. Unable to make API request."; // or handle it accordingly
  }

  const String apiUrl =
      "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI";
   String language = "langChange".tr;

  final Map<String, String> headers = {
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
  };

  final Uri uri = Uri.parse("$apiUrl?UserId=$userId&language=$language");

  try {
    final http.Response response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Successful response, return the body
      print(
          "Api Calling successful: ${response.statusCode} - ${response.body}");
      return response.body;
    } else {
      // Error handling, log or display an error message
      print("Error: ${response.statusCode} - ${response.body}");
      return "Error: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    // Exception handling, log or display an error message
    print("Exception during API request: $e");
    return "Exception during API request: $e";
  }
}

// Example of calling the function and handling the response
