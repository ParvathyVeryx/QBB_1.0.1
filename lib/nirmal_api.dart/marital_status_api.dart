import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MaritalStatus {
  final int id;
  final String name;
  final String short;
  final String description;
  final int genderId;

  MaritalStatus({
    required this.id,
    required this.name,
    required this.short,
    required this.description,
    required this.genderId,
  });

  factory MaritalStatus.fromJson(Map<String, dynamic> json) {
    return MaritalStatus(
      id: json['Id'],
      name: json['Name'],
      short: json['Short'],
      description: json['Description'],
      genderId: json['GenderId'],
    );
  }
}

Future<MaritalStatus> fetchMaritalStatus(int maritalStatusId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var lang = pref.getString("langEn");
  var setLang;
  if (lang == "true") {
    setLang = "en";
  } else {
    setLang = "ar";
  }

  try {
    String token =
        pref.getString('token') ?? ''; // Fetch token from shared preferences

    String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/MaritalStatusAPI?GenderId=1&language=$setLang';

    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      // Find the matching marital status
      var matchingStatus = responseData.firstWhere(
        (status) => status['Id'] == maritalStatusId,
        orElse: () => null,
      );

      if (matchingStatus != null) {
        return MaritalStatus.fromJson(matchingStatus);
      } else {
        throw Exception('Marital status with Id $maritalStatusId not found.');
      }
    } else {
      throw Exception(
          'Error: ${response.statusCode}\nResponse: ${response.body}');
    }
  } catch (e) {
    throw Exception('Exception during API request: $e');
  }
}
