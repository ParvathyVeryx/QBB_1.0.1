import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/appointments._api.dart';
import 'package:QBB/nirmal_api.dart/booking_get_slots.dart';
import 'package:QBB/screens/pages/appointments_data_extract.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/userid.dart';
import 'appointments.dart';

class Upcoming extends StatefulWidget {
  final List<Map<String, dynamic>> UpcomingAppointments;

  const Upcoming({Key? key, required this.UpcomingAppointments})
      : super(key: key);

  @override
  UpcomingState createState() => UpcomingState();
}

class UpcomingState extends State<Upcoming> {
  List<Map<String, dynamic>> allAppointments = [];
  List<Map<String, dynamic>> allUpcomingAppointments = [];
  List<Map<String, dynamic>> allCancelMsg = [];

  Future<List<Map<String, dynamic>>> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String qid = pref.getString("userQID").toString();

    try {
      // Get the token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          ''; // Replace 'auth_token' with your actual key

      // Check if the token is available
      if (token.isEmpty) {
        return [];
      }

      // Construct the request URL
      String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/ViewAppointmentsAPI';
      String requestUrl = '$apiUrl?qid=$qid&page=1&language=$lang';

      // Make the GET request with the token in the headers
      var response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and handle the response body
        var responseBody = json.decode(response.body);

        allAppointments = List<Map<String, dynamic>>.from(responseBody);
        allUpcomingAppointments = allAppointments
            .where((appointment) =>
                appointment['AppoinmentStatus'] is int &&
                appointment['AppoinmentStatus'] == 1)
            .toList();

        if (allUpcomingAppointments.isNotEmpty) {
          pref.setString("appointmentID",
              allUpcomingAppointments[0]['AppoinmentId'].toString());
        }

        pref.getString("appointmentID");
        print(allAppointments);
        return allUpcomingAppointments;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  List<Map<String, dynamic>> reasons = [];
  Future<List<Map<String, dynamic>>> getReasons() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String token = pref.getString('token') ??
        ''; // Replace 'auth_token' with your actual key
    var response = await http.get(
      Uri.parse(
          "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetReasonForCancelAppoinmentAPI?language=$lang"),
      headers: {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      },
    );

    if (response.statusCode == 200) {
      // Parse and handle the response body
      var responseBody = json.decode(response.body);
      reasons = List<Map<String, dynamic>>.from(responseBody);

      return reasons;
    } else {
      return [];
    }
  }

  bool isToday(DateTime compareDate) {
    DateTime today = DateTime.now();
    return today.year == compareDate.year &&
        today.month == compareDate.month &&
        today.day == compareDate.day;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReasons();
  }

  String selectedReason = '';

  List<Widget> buildReasonRadioButtons() {
    // Create a list of radio buttons based on the reasons
    return reasons.map((reason) {
      String reasonName = reason['Name'] ?? '';
      return RadioListTile(
        title: Text(
          reasonName,
          style: TextStyle(fontSize: 10),
        ),
        value: reasonName,
        groupValue: selectedReason,
        activeColor: primaryColor,
        onChanged: (value) async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          // Handle radio button selection
          setState(() {
            selectedReason = value!;
          });
          pref.setString("selectedReason", value!);
          pref.getString("selectedReason");
        },
      );
    }).toList();
  }

  void cancelAppointment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String qid = pref.getString("userQID").toString();
    String reason = pref.getString("selectedReason").toString();
    String appId = pref.getString("appointmentID").toString();
    try {
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      if (token == null) {
        // Handle the case where the token is not available
        return;
      }
      Map<String, dynamic> requestBody = {
        'QID': qid,
        'AppoinmentId': appId,
        'Reason': reason,
        'ReasonType': 0,
        'ReasonType': 0,
      };
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      Uri apiUrl = Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/CancelAppointmentAPI');

      final response = await http.post(
        apiUrl,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        AlertDialog(
          title: Text('Success'),
          content: Text(response.body),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      } else {
        AlertDialog(
          title: Text('Success'),
          content: Text(response.body),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
            errorMessage: '$e',
          );
        },
      );
    }
  }

  Future<void> cancelAnAppointment(String appointmentId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? qid = await getQIDFromSharedPreferences();
    var lang = 'langChange'.tr;
    // String selectedAppointmentId =
    //     pref.getString("selectedAppointmentId").toString();
    String selectedReason = pref.getString("selectedReason").toString();

    try {
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      if (token == null) {
        // Handle the case where the token is not available
        return;
      }

      // Construct headers with the retrieved token
      Map<String, String> headers = {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      Map<String, dynamic> requestBody = {
        "QID": qid,
        "AppoinmentId": appointmentId,
        "Reason": '$selectedReason',
        "ReasonType": '0',
      };

      print("Response Body" + requestBody.toString());

      // Construct the API URL
      Uri apiUrl = Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/CancelAppointmentAPI');

      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: requestBody);

      print("REsponse Status COde and Response" +
          response.body +
          response.statusCode.toString());
      if (response.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text(response.body),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Appointments(),
                        ),
                      ); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context, // Use the context of the current screen
            builder: (BuildContext context) {
              return ErrorPopup(errorMessage: response.body);
            });
      }
    } catch (e) {}
  }

  void rescheduleAppointment(
      String appID,
      String appStatus,
      String visitType,
      String calendarId,
      String apptypeId,
      String visitTypeId,
      String studyId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? qid = await getQIDFromSharedPreferences();

    var lang = 'langChange'.tr;

    try {
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      if (token == null) {
        // Handle the case where the token is not available
        return;
      }

      // Construct headers with the retrieved token
      Map<String, String> headers = {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      Map<String, dynamic> queryParam = {
        "QID": '$qid',
        "AppointmentStatus": appStatus,
        "ShiftCode": 'shft',
        "VisitTypeId": visitTypeId,
        "AvailabilityCalenderId": calendarId,
        "AppoinmentId": appID,
        "language": "$lang",
      };

      // Construct the API URL
      Uri apiUrl = Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/RescheduleAppointmentAPI?QID=${queryParam['QID']}&ShiftCode=${queryParam['ShiftCode']}&VisitTypeId=${queryParam['VisitTypeId']}&AvailabilityCalenderId=${queryParam['AvailabilityCalenderId']}&AppoinmentId=${queryParam['AppoinmentId']}&language=${queryParam['language']}&AppointmentStatus=${queryParam['AppointmentStatus']}');

      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: queryParam);
      print(apiUrl);
      print(response.body);

      if (response.statusCode == 200) {
        await bookAppointmentApiCall(
          context,
          studyId,
          visitTypeId,
          visitType,
        );
      } else {
        showDialog(
            context: context, // Use the context of the current screen
            builder: (BuildContext context) {
              return ErrorPopup(errorMessage: response.body);
            });
      }
    } catch (e) {}
  }

  // {\r\n    \"QID\": \"28900498437\",\r\n    \"AppoinmentId\": \"11488\",\r\n    \"Reason\": \"Reason\",\r\n    \"ReasonType\": \"ReasonType\"\r\n}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Display an error message if an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the data when it's available
          List<Map<String, dynamic>> UpcomingAppointments = [];
          if (!snapshot.hasData) {
            return LoaderWidget();
          } else {
            UpcomingAppointments = snapshot.data!;
          }
          if (snapshot.data!.length == 0) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(child: Text('thereAreNoAppointments'.tr)));
          }
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    for (final appointment in UpcomingAppointments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 188, 188, 188)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, top: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: appbar,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 3.0, 12, 3),
                                            child: Text(
                                              DateFormat('dd')
                                                  .format(
                                                      dateExtract(appointment))
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 16,
                                                backgroundColor: appbar,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 3.0, 12, 3),
                                          child: Text(
                                            DateFormat('MM-yyyy')
                                                .format(
                                                    dateExtract(appointment))
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                18, 3.0, 18, 3),
                                            child: Text(
                                              "upcoming".tr,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 10, 20, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/fast.png",
                                                        width: 30.0,
                                                        height: 30.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'timeSlot'.tr,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        timeExtract(
                                                            appointment), // Use the extracted time here
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/user-time.png",
                                                        width: 25.0,
                                                        height: 25.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'visitType'.tr,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        appointment[
                                                                'VisittypeName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/appointment-list.png",
                                                        width: 25.0,
                                                        height: 25.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'appointmentType'.tr,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        appointment[
                                                                'AppoinmenttypName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/users.png",
                                                        width: 30.0,
                                                        height: 30.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'studyName'.tr,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        appointment['StudyName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Colors.deepPurple),
                                            elevation: 0,
                                          ),
                                          onPressed: () async {
                                            // if (appointment[
                                            //         'CancelExpiredMSG'] !=
                                            //     null) {
                                            //   showDialog(
                                            //       context: context,
                                            //       builder:
                                            //           (BuildContext context) {
                                            //         return AlertDialog(
                                            //           title: Text(''),
                                            //           content: Text(appointment[
                                            //               'CancelExpiredMSG']),
                                            //           actions: [
                                            //             ElevatedButton(
                                            //               onPressed: () {
                                            //                 Navigator.pop(
                                            //                     context); // Close the dialog
                                            //               },
                                            //               child: Text('OK'),
                                            //             ),
                                            //           ],
                                            //         );
                                            //       });
                                            // } else {
                                            appointment["AppoinmentId"];
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: CustomAlertDialogShape(
                                                      bottomLeftRadius: 36.0),
                                                  title: Column(
                                                    children: [
                                                      Center(
                                                          child: Text("",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      // Divider(),
                                                    ],
                                                  ),
                                                  content: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ...buildReasonRadioButtons()

                                                          // ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  actions: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                // SharedPreferences prefs =
                                                                //     await SharedPreferences.getInstance();
                                                                // var selectedLanguagePref =
                                                                //     prefs.getString('langEn').toString();
                                                                // if (selectedLanguagePref == "false") {
                                                                //   selectedLanguage = 'Arabic';
                                                                // } else {
                                                                //   selectedLanguage = 'English';
                                                                // }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                  'cancelButton'
                                                                      .tr),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                String appId =
                                                                    appointment[
                                                                            "AppoinmentId"]
                                                                        .toString();
                                                                // SharedPreferences
                                                                //     pref =
                                                                //     await SharedPreferences
                                                                //         .getInstance();
                                                                // pref.setString(
                                                                //     "selectedAppointmentId",
                                                                //     appointment[
                                                                //             "AppoinmentId"]
                                                                //         .toString());
                                                                cancelAnAppointment(
                                                                    appId);
                                                              },
                                                              child:
                                                                  Text('ok'.tr),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            // }
                                          },
                                          child: Text(
                                            'cancel'.tr,
                                            style: TextStyle(
                                                color: Colors.deepPurple),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                              ),
                                            ),
                                            backgroundColor: primaryColor,
                                            side: const BorderSide(
                                                color: Colors.black),
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            String appId =
                                                appointment["AppoinmentId"]
                                                    .toString();
                                            String Vtype =
                                                appointment['VisittypeName']
                                                    .toString();
                                            String vTypeId =
                                                appointment['VisitTypeId']
                                                    .toString();
                                            String appstatus =
                                                appointment['AppoinmentStatus']
                                                    .toString();
                                            String calendarId = appointment[
                                                    "AvailabilityCalenderId"]
                                                .toString();
                                            String appTypeId =
                                                appointment["AppointmentTypeId"]
                                                    .toString();
                                            String studyId =
                                                appointment["StudyId"]
                                                    .toString();
                                            rescheduleAppointment(
                                                appId,
                                                appstatus,
                                                Vtype,
                                                calendarId,
                                                appTypeId,
                                                vTypeId,
                                                studyId);
                                          },
                                          child: Text(
                                            'reschedule'.tr,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
