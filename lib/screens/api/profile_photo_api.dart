// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<void> updateUserProfilePhoto() async {
//   final String apiUrl =
//       'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfilePhotoAPI';

//   final Map<String, dynamic> requestBody = {
//     "QID": "28900498437",
//     "Photo": "",
//   };

//   final http.Response response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization':
//           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMDU2MTE0MCwiZXhwIjoxNzAxMTY1OTQwLCJpYXQiOjE3MDA1NjExNDAsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.BKyV2t6VQQreqMf4jm3tcUQbB0rTsp2mhOpBmr1t4Tc',
//     },
//     body: json.encode(requestBody),
//   );

//   if (response.statusCode == 200) {
//     // Successful API call
//     print('API Call Successful');
//     print('Response: ${response.body}');
//   } else {
//     // Handle API call failure
//     print('API Call Failed');
//     print('Error Code: ${response.statusCode}');
//     print('Error Message: ${response.body}');
//   }
// }
