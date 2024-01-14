import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:http/http.dart' as http;

Future<bool> getAcess(
  String qid,
  String otp,
  // bool otpMatch,
) async {
  var token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMjQ2OTA2NCwiZXhwIjoxNzAzMDczODY0LCJpYXQiOjE3MDI0NjkwNjQsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.RPHFJL1OLmVAR10vG6yHnHIe8zxP4j0qahv58C5PFFE";
  final Map<String, dynamic> verify = {
    'QID': qid,
    'OTP': otp,
  };

  print(verify);

  final String verifyOtp =
      '$base_url/AcessSetupOTP?QID=${verify['QID']}&OtpToken=${verify['OTP']}';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final http.Response response =
        await http.get(Uri.parse(verifyOtp), headers: headers);

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var userId = json.decode(response.body);
      return true; // Return true if OTP verification is successful
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      // otpMatch = false; // Set otpMatch to false
      return false; // Return false to indicate OTP verification failure
    }
  } catch (err) {
    // Handle network errors
    print('Error: $err');
    // otpMatch = false; // Set otpMatch to false
    return false; // Return false to indicate OTP verification failure
  }
}
