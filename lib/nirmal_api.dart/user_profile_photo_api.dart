import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> uploadUserProfilePhoto(String qid, File photo) async {
  try {
    // Read the file as bytes
    List<int> photoBytes = await photo.readAsBytes();

    // Encode the bytes to base64
    String base64Photo = base64Encode(photoBytes);

    // Append the 'data:image/png;base64,' prefix to the base64-encoded photo
    String prefixedBase64Photo = 'data:image/png;base64,' + base64Photo;

    // Prepare the request body as a Map
    Map<String, dynamic> requestBody = {
      'QID': qid,
      'Photo': prefixedBase64Photo,
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(requestBody);

    // Make the API call using http.post
    var response = await http.post(
      Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfilePhotoAPI'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk',
      },
      body: requestBodyJson,
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Check if the response is JSON
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        // Parse the response body as JSON
        var responseBody = json.decode(response.body);
        print(responseBody);
      } else {
        // Handle non-JSON response (e.g., log or print the raw response)
        print('Non-JSON Response: ${response.body}');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response: ${response.body}');
    }
  } catch (e, stackTrace) {
    print('Exception during API request: $e');
    print('StackTrace: $stackTrace');
  }
}
