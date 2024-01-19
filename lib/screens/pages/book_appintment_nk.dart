import 'dart:convert';
import 'package:QBB/bottom_nav.dart';
import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/Booking_get_slots.dart';
import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/homescreen_nk.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:QBB/screens/pages/notification.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:QBB/screens/pages/results.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointments extends StatefulWidget {
  final String? studyName;

  const BookAppointments({Key? key, this.studyName}) : super(key: key);

  @override
  BookAppointmentsState createState() => BookAppointmentsState();
}

class BookAppointmentsState extends State<BookAppointments> {
  String selectedValue = 'selectStudies'.tr;
  String secondSelectedValue = 'Select visit type';
  bool showSecondDropdown = false;
  List<String> studyNames = [];
  List<int> studyIds = [];
  List<String> visitTypeNames = [];
  String responseFromApi = '';
  List<int> visitTypeIds = [];
  int? selectedVisitTypeIdForBooking;
  int? selectedStudyId;
  bool isLoading = false; // Added flag for loading indicator
  int currentIndex = 2;
  final screens = [
    HomeScreen(),
    Appointments(),
    BookAppointments(),
    Results(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    fetchStudyMasterAPI();
  }

  Future<void> fetchStudyMasterAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var setLang = 'langChange'.tr;
    

    final String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/StudyMasterAPI';

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      String? qid = await getQIDFromSharedPreferences();

      if (qid != null) {
        print('QID: $qid');
      } else {
        print('Failed to retrieve QID');
      }
      final http.Response response = await http.get(
        Uri.parse('$apiUrl?QID=$qid&language=$setLang'),
        headers: {
          'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        },
      );

      print('API URL: $apiUrl');
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          studyNames =
              responseData.map((data) => data['Name'].toString()).toList();
          if (studyNames.isNotEmpty) {
            selectedValue = 'selectStudies'.tr; // Set the initial placeholder
          }

          studyIds = responseData.map((data) => data['Id'] as int).toList();
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchVisitTypes(int studyId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = pref.getString("langEn").toString();
    var setLang;
    if (lang == "false") {
      setLang = "ar";
    } else {
      setLang = "en";
    }
    print('fffffffffffffffffffffffffff' + setLang);
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = true;
    });

    final String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetVisitTypeForAppointment';

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      String? qid = await getQIDFromSharedPreferences();

      if (qid != null) {
        print('QID: $qid');
      } else {
        print('Failed to retrieve QID');
      }

      final http.Response response = await http.get(
        Uri.parse(
            '$apiUrl?QID=$qid&StudyId=$studyId&Preg=false&language=$setLang'),
        headers: {
          'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        },
      );

      if (response.statusCode == 200) {
        print('successfully fetched visittypes');
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          visitTypeNames =
              responseData.map((data) => data['Name'].toString()).toList();

          visitTypeIds = responseData.map((data) => data['Id'] as int).toList();
        });
      } else {
        throw Exception('Failed to fetch visit types');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: DefaultTabController(
        length: 1,
        child: PopScope(
          canPop: true,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: textcolor),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 10.0),
                  //   child:
                  //   Image.asset(
                  //     "assets/images/icon.png",
                  //     width: 40.0,
                  //     height: 40.0,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Text(
                    'pageATitle'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Impact',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none_outlined),
                    iconSize: 30.0,
                    color: Colors.white,
                  )
                ],
              ),
              backgroundColor: appbar,
            ),
            drawer: SideMenu(),
            // bottomNavigationBar: null,
            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: textcolor,
                unselectedItemColor: textcolor,
                backgroundColor: primaryColor,
                currentIndex: currentIndex,
                unselectedFontSize: 7,
                selectedFontSize: 7,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  if (index == 0) {
                    // Handle tap for the "HOME" item
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
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
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Image.asset(
                        "assets/images/home.png",
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: 'HOME',
                  ),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Image.asset(
                          "assets/images/event.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'APPOINTMENT'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Image.asset(
                          "assets/images/event.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'BOOK AN APPOINTMENT'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Image.asset(
                          "assets/images/experiment-results.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'RESULTS/STATUS'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Image.asset(
                          "assets/images/user.png",
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      label: 'MY PROFILE'),
                ]),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: 300.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: DropdownButton<String>(
                              value: selectedValue,
                              items: [
                                DropdownMenuItem<String>(
                                  value: 'Select studies',
                                  child: Text('Select studies'),
                                ),
                                ...studyNames.map(
                                  (studyName) => DropdownMenuItem<String>(
                                    value: studyName,
                                    child: Text(studyName),
                                  ),
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value!;
                                  showSecondDropdown =
                                      value != 'Select studies';
                                  int selectedStudyIndex =
                                      studyNames.indexOf(value);
                                  selectedStudyId =
                                      studyIds[selectedStudyIndex];
                                  fetchVisitTypes(selectedStudyId!);
                                });
                              },
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 16.0,
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showSecondDropdown,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: 300.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: DropdownButton<String>(
                              value:
                                  secondSelectedValue ?? visitTypeNames.first,
                              items: ['Select visit type', ...visitTypeNames]
                                  .toSet()
                                  .toList() // Convert to set to remove duplicates
                                  .map((visitTypeName) => DropdownMenuItem(
                                        value: visitTypeName,
                                        child: Text(visitTypeName),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  secondSelectedValue = value!;
                                });

                                if (value != 'Select visit type') {
                                  int selectedVisitTypeIndex =
                                      visitTypeNames.indexOf(value!);
                                  int selectedVisitTypeId =
                                      visitTypeIds[selectedVisitTypeIndex];
                                  selectedVisitTypeIdForBooking =
                                      selectedVisitTypeId;
                                }
                              },
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 16.0,
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                side:
                                    const BorderSide(color: Colors.deepPurple),
                                elevation: 0,
                              ),
                              onPressed: () {
                                // Handle button press
                              },
                              child: Text(
                                'cancelButton'.tr,
                                style: TextStyle(color: Colors.deepPurple),
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
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ),
                                backgroundColor: primaryColor,
                                side: const BorderSide(color: Colors.black),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                if (selectedValue != 'selectStudies'.tr &&
                                    secondSelectedValue !=
                                        'Select visit type') {
                                  await bookAppointmentApiCall(
                                    context,
                                    selectedStudyId.toString(),
                                    selectedVisitTypeIdForBooking.toString(),
                                    secondSelectedValue,
                                  );

                                  // if (response.success) {
                                  // API call was successful, navigate to the next screen
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         AppointmentBookingPage(
                                  //       apiResponse: response,
                                  //     ),
                                  //   ),
                                  // );
                                  // }
                                }
                              },
                              child: Text(
                                'tutorialContinueButton'.tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Loading indicator
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LoaderWidget(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
