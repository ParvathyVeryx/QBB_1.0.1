import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> getNotificationsApiCall() async {
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetNotificationsAPI';

  final String? token = await getAuthToken();

  if (token == null) {
    // Handle the case where the token is not available
    print('Authentication token not available');
    return;
  }

  final Map<String, String> queryParams = {
    "QID": "28900498437",
    "language": "en",
  };

  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
  };

  try {
    final response = await http.get(
      uri,
      headers: headers,
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
