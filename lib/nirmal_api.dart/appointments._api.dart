import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> viewAppointments(
    String qid, int page, String language) async {
  try {
    // Construct the request URL
    String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/ViewAppointmentsAPI';
    String requestUrl = '$apiUrl?qid=$qid&page=$page&language=$language';

    // Make the GET request
    var response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk'
      },
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse and handle the response body
      var responseBody = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseBody);
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
      return []; // Return an empty list in case of an error
    }
  } catch (e, stackTrace) {
    print('Exception during API request: $e');
    print('StackTrace: $stackTrace');
    return []; // Return an empty list in case of an exception
  }
}
