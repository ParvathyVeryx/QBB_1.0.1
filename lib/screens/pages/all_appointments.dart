import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/appointments._api.dart';
import 'package:QBB/screens/pages/appointments_data_extract.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllAppointments extends StatefulWidget {
  final List<Map<String, dynamic>> allAppointments;

  const AllAppointments({Key? key, required this.allAppointments})
      : super(key: key);

  @override
  AllAppointmentsState createState() => AllAppointmentsState();
}

class AllAppointmentsState extends State<AllAppointments> {
  List<Map<String, dynamic>> allAppointments = [];
  String allCancelMsg = '';
  List<String> cancelMessages = [];
  bool _isMounted = false;
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
        allCancelMsg = allAppointments[0]["CancelExpiredMSG"];

        cancelMessages = allAppointments
            .map((appointment) => appointment["CancelExpiredMSG"])
            .cast<String>()
            .toList();
        print(allAppointments);
        return allAppointments;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isMounted = true;
    fetchData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   // Display a loading indicator while waiting for the data
        //   return CircularProgressIndicator();
        // } else

        if (snapshot.hasError) {
          // Display an error message if an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the data when it's available
          List<Map<String, dynamic>> completedAppointments = [];
          if (!snapshot.hasData) {
            return LoaderWidget();
          } else {
            completedAppointments = snapshot.data!;
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
                    for (final appointment in completedAppointments)
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
                                            padding: EdgeInsets.fromLTRB(
                                                18, 3.0, 18, 3),
                                            child: Text(
                                              appointment['AppoinmentStatus']
                                                          .toString() ==
                                                      "4"
                                                  ? "completed".tr
                                                  : appointment['AppoinmentStatus']
                                                              .toString() ==
                                                          "1"
                                                      ? 'upcoming'.tr
                                                      : appointment['AppoinmentStatus']
                                                                  .toString() ==
                                                              "10"
                                                          ? 'noShow'.tr
                                                          : appointment['AppoinmentStatus']
                                                                  .toString() ==
                                                              "2"
                                                          ? 'rescheduled'.tr
                                                          : 'cancelled'.tr,
                                              style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                      appointment["AppoinmentStatus"] == 1
                                          ? Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        side: const BorderSide(
                                                            color: Colors
                                                                .deepPurple),
                                                        elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                        if (appointment[
                                                                'CancelExpiredMSG'] !=
                                                            null) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      Text(''),
                                                                  content: Text(
                                                                      appointment[
                                                                          'CancelExpiredMSG']),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: Text(
                                                        'cancelButton'.tr,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .deepPurple),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                  SizedBox(
                                                    width: 150,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            primaryColor,
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.black),
                                                        elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                        if (appointment[
                                                                'ResultExpiredMSG'] !=
                                                            null) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      Text(''),
                                                                  content: Text(
                                                                      appointment[
                                                                          'ResultExpiredMSG']),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: Text(
                                                        'Reschedule',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
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
