import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/results.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointments.dart';
import 'appointments_data_extract.dart';
import 'book_appintment_nk.dart';
import 'homescreen_nk.dart';
import 'loader.dart';
import 'profile.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
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
        print('Error: Token not found in shared preferences.');
        return [];
      }

      // Construct the request URL

      String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetNotificationsAPI?QID=$qid&language=$lang';
      String requestUrl = '$apiUrl?qid=$qid&page=1&language=$lang';

      // Make the GET request with the token in the headers
      var response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );
      // print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk' +
      //     response.body.toString());
      if (response.statusCode == 200) {
        // Parse and handle the response body
        var responseBody = json.decode(response.body);
        notifications = List<Map<String, dynamic>>.from(responseBody);
        // print('jkjkjkjk' + notifications.toString());
        return notifications;
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
        // print('Response: ${response.body}');
        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      print('Exception during API request: $e');
      print('StackTrace: $stackTrace');
      return []; // Return an empty list in case of an exception
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
          List<Map<String, dynamic>> allresults = [];
          if (!snapshot.hasData) {
            return LoaderWidget();
          } else {
            allresults = snapshot.data!;
          }

          return Scaffold(
            appBar: AppBar(
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Image.asset(
                      "assets/images/icon.png",
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // SizedBox(
                  //   width: 50.0,
                  // ),

                  Row(
                    children: [
                      Center(
                        child: Text(
                          'notifications'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w900 ,
                            fontFamily: 'Impact',
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   width: 50.0,
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.notifications_none_outlined),
                  //   iconSize: 30.0,
                  //   color: textcolor,
                  // )
                ],
              ),
              backgroundColor: appbar,
              iconTheme: const IconThemeData(color: textcolor),

              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.notifications_none_outlined),
              //     iconSize: 30.0,
              //   ),
              // ],
            ),
            drawer: const SideMenu(),
            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: textcolor,
                unselectedItemColor: textcolor,
                backgroundColor: primaryColor,
                unselectedFontSize: 7,
                selectedFontSize: 7,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  if (index == 0) {
                    // Handle tap for the "HOME" item
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                  if (index == 2) {
                    // Handle tap for the "HOME" item
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookAppointments()),
                    );
                  }
                  if (index == 1) {
                    // Handle tap for the "HOME" item
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Appointments()),
                    );
                  }

                  if (index == 3) {
                    // Handle tap for the "HOME" item
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Results()),
                    );
                  }
                  if (index == 4) {
                    // Handle tap for the "HOME" item
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      child: Image.asset(
                        "assets/images/home.png",
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: 'home'.tr + '\n',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      child: Image.asset(
                        "assets/images/event.png",
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: 'appointment'.tr + '\n',
                  ),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Image.asset(
                          "assets/images/date.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'bookAn'.tr + '\n' + 'appointment'.tr),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Image.asset(
                          "assets/images/experiment-results.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'results'.tr + '/' + '\n' + 'status'.tr),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Image.asset(
                          "assets/images/user.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'profile'.tr.toUpperCase() + '\n'),
                ]),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    for (final appointment in allresults)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 215, 215, 215)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10.0, top: 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      // color: primaryColor,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(18, 3.0, 18, 3),
                                        child: Text(
                                          appointment['Subject'].toString(),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Container(
                                    //   color: appbar,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.fromLTRB(
                                    //         12, 3.0, 12, 3),
                                    //     child: Text(
                                    //       DateFormat('dd')
                                    //           .format(
                                    //               dateExtract(appointment))
                                    //           .toString(),
                                    //       style: const TextStyle(
                                    //         color: Color.fromARGB(
                                    //             255, 255, 255, 255),
                                    //         fontSize: 16,
                                    //         backgroundColor: appbar,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       2, 3.0, 12, 3),
                                    //   child: Text(
                                    //     DateFormat('MM-yyyy')
                                    //         .format(
                                    //             dateExtract(appointment))
                                    //         .toString(),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Flexible(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: HtmlWidget(
                                        appointment['Message'],
                                        textStyle: TextStyle(fontSize: 13),
                                      ),
                                    )),
                                  ],
                                ),

                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(
                                //       20.0, 10, 20, 10),
                                //   child: Column(
                                //     children: [
                                //       Row(
                                //         children: [
                                //           Column(
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   Column(
                                //                     children: [
                                //                       Image.asset(
                                //                         "assets/images/user-time.png",
                                //                         width: 25.0,
                                //                         height: 25.0,
                                //                         fit: BoxFit.cover,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 10,
                                //                   ),
                                //                   Column(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment.start,
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment
                                //                             .start,
                                //                     children: [
                                //                       Text(
                                //                         'visitType'.tr,
                                //                         style: TextStyle(
                                //                           color: Color.fromARGB(
                                //                               255,
                                //                               163,
                                //                               163,
                                //                               163),
                                //                           fontSize: 13,
                                //                         ),
                                //                       ),
                                //                       Text(
                                //                         appointment[
                                //                                 'VisittypeName']
                                //                             .toString(),
                                //                         style: TextStyle(
                                //                             fontSize: 10),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ],
                                //               ),
                                //             ],
                                //           ),
                                //           const SizedBox(
                                //             width: 40,
                                //           ),
                                //           Column(
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   Column(
                                //                     children: [
                                //                       Image.asset(
                                //                         "assets/images/users.png",
                                //                         width: 30.0,
                                //                         height: 30.0,
                                //                         fit: BoxFit.cover,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 10,
                                //                   ),
                                //                   Column(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment.start,
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment
                                //                             .start,
                                //                     children: [
                                //                       Text(
                                //                         'studyName'.tr,
                                //                         style: TextStyle(
                                //                           color: Color.fromARGB(
                                //                               255,
                                //                               163,
                                //                               163,
                                //                               163),
                                //                           fontSize: 13,
                                //                         ),
                                //                       ),
                                //                       Text(
                                //                         appointment['StudyName']
                                //                             .toString(),
                                //                         style: TextStyle(
                                //                             fontSize: 10),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ],
                                //               ),
                                //             ],
                                //           )
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 20,
                                //       ),
                                //       Center(
                                //         child: Text(
                                //           "yourResultIsReadyForCollection".tr,
                                //           style: TextStyle(
                                //               fontSize: 12,
                                //               color: const Color.fromARGB(
                                //                   255, 171, 171, 171)),
                                //         ),
                                //       ),
                                //       const SizedBox(
                                //         height: 20,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: [
                                //           ElevatedButton(
                                //             onPressed: () {},
                                //             style: ButtonStyle(
                                //                 backgroundColor:
                                //                     MaterialStateProperty.all<
                                //                             Color>(
                                //                         primaryColor), // Set background color
                                //                 shape:
                                //                     MaterialStateProperty.all<
                                //                         RoundedRectangleBorder>(
                                //                   const RoundedRectangleBorder(
                                //                     borderRadius:
                                //                         BorderRadius.only(
                                //                       bottomLeft: Radius.circular(
                                //                           12.0), // Rounded border at bottom-left
                                //                     ),
                                //                   ),
                                //                 )),
                                //             child: Padding(
                                //               padding: EdgeInsets.fromLTRB(
                                //                   5.0, 5.0, 5.0, 5.0),
                                //               child: Text(
                                //                 'collectResult'.tr,
                                //                 style: TextStyle(
                                //                     color: textcolor,
                                //                     fontSize: 12),
                                //               ),
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: 20,
                                //           ),
                                //           ElevatedButton(
                                //             onPressed: () {},
                                //             style: ButtonStyle(
                                //                 backgroundColor:
                                //                     MaterialStateProperty.all<
                                //                             Color>(
                                //                         textcolor.withOpacity(
                                //                             0.6)), // Set background color
                                //                 shape:
                                //                     MaterialStateProperty.all<
                                //                         RoundedRectangleBorder>(
                                //                   const RoundedRectangleBorder(
                                //                     side: BorderSide(
                                //                       color:
                                //                           secondaryColor, // Specify the border color here
                                //                       width:
                                //                           1.0, // Specify the border width here
                                //                     ),
                                //                     borderRadius:
                                //                         BorderRadius.only(
                                //                       bottomLeft: Radius.circular(
                                //                           12.0), // Rounded border at bottom-left
                                //                     ),
                                //                   ),
                                //                 )),
                                //             child: Padding(
                                //               padding: EdgeInsets.fromLTRB(
                                //                   5.0, 5.0, 5.0, 5.0),
                                //               child: Text(
                                //                 'download'.tr,
                                //                 style: TextStyle(
                                //                     color: secondaryColor,
                                //                     fontSize: 12),
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),
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

// Your getNotifications function remains the same.
