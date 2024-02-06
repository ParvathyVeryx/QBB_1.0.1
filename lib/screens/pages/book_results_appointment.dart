import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:QBB/providers/studymodel.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:QBB/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../nirmal_api.dart/profile_api.dart';
import '../api/userid.dart';
import 'appointments.dart';
import 'erorr_popup.dart';

class BookResults extends StatefulWidget {
  const BookResults({Key? key}) : super(key: key);

  @override
  BookResultsState createState() => BookResultsState();
}

class BookResultsState extends State<BookResults> {
  late List<Study> bookAppScreen;
  List<DateTime> upcomingDates = [];
  TextEditingController _dateController = TextEditingController();
  bool isLoading = true; // Add a loading state
  late PageController _pageController;
  DateTime selectedDate = DateTime.now();
  List<String> selectedDates = [];
  List<String> datesOnly = [];
  List<String> dayNames = [];
  List<String> availCId = [];
  List<String> daysAndDates = [];
  late List<String> timeList;
  bool isButtonClicked = false;
  List<int> selectedIndices = [];
  int lastSelectedIndex = -1; // Initialize to an invalid index
  List<DateTime> selectedSlot = [];
  String availabilityCalendarid = '';
  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);
      print("Availability Calendar");
      print(jsonResponse);

      setState(() {
        timeList = List<String>.from(jsonResponse['timelist']);
        // nextAvailableDates =
        //     List<String>.from(jsonResponse['nextAvilableDateList']);
      });
    }
  }

  bool ispicked = false;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: upcomingDates.isNotEmpty ? upcomingDates[0] : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked == null) {
      picked = DateTime.now();
    }

    setState(() {
      ispicked = true;

      generateUpcomingDates(picked!);
      fetchDateList(picked);
    });

    // Fetch data after selecting a date
  }

  List<DateTime> upcomingDateList = [];

  // List<DateTime> generateDates() {
  //   DateTime currentDate = DateTime.now();

  //   for (int i = 0; i < 5; i++) {
  //     DateTime nextDate = currentDate.add(Duration(days: i));

  //     // Only add dates within the same month
  //     if (nextDate.month == currentDate.month) {
  //       upcomingDateList.add(nextDate);
  //     }
  //   }

  //   return upcomingDateList;
  // }

  List<dynamic> availabiltyCandarId = [];

  Future<void> fetchAvailabilityCalendar() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponseResults');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);
      print("Availability Calendar");
      print(jsonResponse);

      if (jsonResponse['BookAppoinmentModelList'] != null &&
          jsonResponse['BookAppoinmentModelList'].isNotEmpty) {
        availabiltyCandarId = jsonResponse['BookAppoinmentModelList']
            .map((item) => item['AvailabilityCalenderId'].toString())
            .toList();
        print("AAAAAACI Results" + availabiltyCandarId.toString());
      } else {
        print("BookAppoinmentModelList is null or empty");
      }

      // Set state if needed (depends on where this function is called)
      // setState(() {
      //   // Do something with availabiltyCandarId
      // });
    }
  }

  bool isNextWeek = false;

  Future<void> fetchDateList(DateTime selectedDate) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);
      print("Availability Calendar");
      DateTime tempDate = selectedDate;
      print(jsonResponse);
      List<dynamic> dynamicList = jsonResponse['datelist'];
      List<String> dateStrings = List<String>.from(dynamicList);
      List<DateTime> dateTimes = dateStrings.map((dateString) {
        return DateTime.parse(dateString);
      }).toList();

      print(ispicked);
      if (ispicked == true) {
        upcomingDateList = [];
        for (int i = 0; i < 5; i++) {
          print("i");
          // Check if the current date is within the same month as the selected date
          if (tempDate.month == selectedDate.month) {
            print("j");

            setState(() {
              upcomingDateList.add(tempDate);
            });
            print(upcomingDateList);
          }
          tempDate = tempDate.add(const Duration(days: 1));
        }
      } else if (isNextWeek == true) {
        upcomingDateList = [];
        for (int i = 0; i < 5; i++) {
          print("i");
          // Check if the current date is within the same month as the selected date
          if (tempDate.month == selectedDate.month) {
            print("j");

            setState(() {
              upcomingDateList.add(tempDate);
            });
            print(upcomingDateList);
          }
          tempDate = tempDate.add(const Duration(days: 1));
        }
      } else {
        setState(() {
          upcomingDateList = dateStrings.map((dateString) {
            return DateTime.parse(dateString);
          }).toList();
        });
      }
    }
  }

  void generateUpcomingDatesandDays(DateTime selectedDate) {
    upcomingDateList = [];
    DateTime tempDate = DateTime.now(); // Start from today

    // Generate the upcoming dates for the next five days within the same month
    for (int i = 0; i < 5; i++) {
      // Check if the current date is within the same month as the selected date
      if (tempDate.month == selectedDate.month) {
        upcomingDateList.add(tempDate);
      }

      tempDate = tempDate.add(const Duration(days: 1));

      // Break if the next day is in the next month
      if (tempDate.month != selectedDate.month) {
        break;
      }
    }

    // Now, upcomingDateList contains the upcoming dates within the same month
    print("Upcoming Dates: " + upcomingDateList.toString());

    // _dateController.text =
    //     '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
  }

  void generateUpcomingDates(DateTime selectedDate) {
    upcomingDates = [];
    DateTime tempDate = selectedDate;

    // Move to the next week's starting day (7 days from the selected date)
    tempDate = tempDate.add(Duration(days: (7 - tempDate.weekday + 2) % 7));

    DateTime currentDate = DateTime.now();

    // Generate the upcoming dates for the next seven days within the same month
    for (int i = 0; i < 7; i++) {
      if (tempDate.isAfter(currentDate) &&
          tempDate.month == currentDate.month) {
        upcomingDates.add(tempDate);
      }

      tempDate = tempDate.add(const Duration(days: 1));

      // Break if the next day is in the next month
      if (tempDate.month != currentDate.month) {
        break;
      }
    }

    _dateController.text = '${DateFormat('dd/MM/yyyy').format(selectedDate)}';
  }

  Future<List<String>> fetchAvailableDates() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonString = pref.getString("availableDates");

// Check if the jsonString is not null
    if (jsonString != null) {
      // Use json.decode to parse the jsonString
      dynamic decodedData = json.decode(jsonString);

      // Check if the decodedData is a List
      if (decodedData is List) {
        // Now you can use the data as a List
        List<String> availableDates = List<String>.from(decodedData);
        for (String dateTimeString in availableDates) {
          try {
            // Parse the date-time string to DateTime
            DateTime dateTime = DateTime.parse(dateTimeString);

            // Format the DateTime to get only the date part
            String dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);

            // Add the date to the result list
            datesOnly.add(dateOnly);
          } catch (e) {
            // Handle parsing errors if necessary
          }
        }

        daysAndDates = availableDates;

        pref.setString("dateOnly", datesOnly.toString());
        pref.getString("dateOnly");
        List<DateTime?> dates = datesOnly.map((dateString) {
          try {
            return DateTime.parse(dateString);
          } catch (e) {
            return null;
          }
        }).toList();

        // Check if any dates were successfully parsed
        for (DateTime? date in dates) {
          if (date != null) {
            String dayName = DateFormat('EEEE').format(date);
            dayNames.add(dayName);
          }
        }

        return datesOnly;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  List<String> daysOnly = [];
  Future<List<String>> fetchAvailableDays() async {
    List<DateTime?> dates = datesOnly.map((dateString) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }).toList();

    // Check if any dates were successfully parsed

    for (DateTime? date in dates) {
      if (date != null) {
        String dayName = DateFormat('EEEE').format(date);
        dayNames.add(dayName);
      }
    }

    return dayNames;
  }

  Future<String> getAvailabilityCalendar(String availabilityCalendar) async {
    availabilityCalendarid = availabilityCalendar;
    return availabilityCalendarid;
  }

  bool isLoadingLoader = false;

  Future<void> confirmAppointment(BuildContext context) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    LoaderWidget _loader = LoaderWidget();
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? qid = await getQIDFromSharedPreferences();
    String studyId = pref.getString("resultsStudyID").toString();
    int? studyIdInt = int.tryParse(studyId);
    String visitTypeId = pref.getString("resultsVisitTypeID").toString();
    String appiontmentID = pref.getString("resultsAppID").toString();
    int? visitTypeIDInt = int.tryParse(visitTypeId);
    String appointmentTypeID =
        pref.getString("resultsAppointmentTypeID").toString();
    int? personGradeId = await getPersonGradeIdFromSharedPreferences();

    String? selectedSlot = pref.getString("selectDate");
    DateTime _selectedDate =
        selectedSlot != null ? DateTime.parse(selectedSlot) : DateTime.now();

    // Retrieve the token from SharedPreferences
    String? token = pref.getString('token');
    if (token == null) {
      // Handle the case where the token is not available
      // You might want to show an error message or navigate the user to the login screen
      return;
    }

    // Construct headers with the retrieved token
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.replaceAll('"', '')}',
    };

    Map<String, dynamic> queryParams = {
      "QID": '$qid',
      "AppointmentTypeId": appointmentTypeID,
      "PersonGradeId": personGradeId.toString(),
      "AppoinmentId": appiontmentID,
      "StudyId": studyId,
      "VisitTypeId": visitTypeId,
      "AvailabilityCalenderId": availabilityCalendarid,
      "ShiftCode": 'shft',
      "language": 'langChange'.tr,
    };
    print("Query PArameter" + queryParams.toString());

    // Construct the API URL
    Uri apiUrl = Uri.parse(
        "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookResultAppointmentAPI?QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&ShiftCode=${queryParams['ShiftCode']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AvailabilityCalenderId=${queryParams['AvailabilityCalenderId']}&language=${queryParams['language']}&AppoinmentId=${queryParams['AppoinmentId']}&AppointmentTypeId=${queryParams['AppointmentTypeId']}");

    print("API URL results");
    print(apiUrl);
    print(jsonEncode(queryParams));

    try {
      Dialogs.showLoadingDialog(context, _keyLoader, _loader);
      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: queryParams);

      // Process the response here

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        // Successful response, show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(''),
              content: Text(json.decode(response.body)["Message"]),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Appointments(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        // Error response, show an error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorPopup(
                errorMessage: json.decode(response.body)["Message"]);
          },
        );
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle network errors or other exceptions
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorPopup(
              errorMessage: 'Network error or other exception occurred.');
        },
      );
    }
  }

  @override
  void initState() {
    // bookAppScreen = [];
    super.initState();
    timeList = [];
    generateUpcomingDates(DateTime.now());
    _pageController = PageController(initialPage: 0);
    fetchApiResponseFromSharedPrefs();
    fetchAvailableDates().then((dates) {
      setState(() {
        datesOnly = dates;
      });
    });
    fetchAvailableDays().then((days) {
      setState(() {
        dayNames = days;
      });
    });
    fetchDateList(DateTime.now());
    fetchAvailabilityCalendar();
  }

  @override
  Widget build(BuildContext context) {
    // if (bookAppScreen.isEmpty) {
    //   // Return a loading indicator or handle the case appropriately
    //   return LoaderWidget(); // Replace with your loading widget
    // }
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'bookAnAppointment'.tr,
                style: const TextStyle(
                  color: appbar,
                  fontFamily: 'Impact',
                  fontSize: 16
                ),
              ),
            ],
          ),
          backgroundColor: textcolor,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          labelText:
                              '${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                          labelStyle: const TextStyle(fontSize: 11),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        color: primaryColor,
                        iconSize: 11,
                      ),
                      Text(
                        "nextWeek".tr,
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: primaryColor,
                        iconSize: 11,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "nextAvailableDates".tr,
                        style: const TextStyle(
                            color: appbar,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "swipeRightToViewMoreDates".tr,
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // or a fixed width
                        height: 40, // or any fixed height
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return PageView.builder(
                              controller: _pageController,
                              itemCount: upcomingDates.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    // width: constraints
                                    //     .maxWidth, // or any desired width
                                    // height: constraints
                                    //     .maxHeight, // or any desired height
                                    margin: const EdgeInsets.all(8),
                                    child: Center(
                                        child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .white, // Background color of the button
                                        side: BorderSide(
                                            color:
                                                Colors.black), // Border color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              0.0), // Set the border radius
                                        ),
                                        padding: EdgeInsets.all(
                                            4.0), // Set the content padding
                                      ),
                                      onPressed: () {
                                        isNextWeek = true;
                                        fetchDateList(upcomingDates[index]);
                                      },
                                      child: Text(
                                        '${DateFormat('dd/MM/yyyy').format(upcomingDates[index])}',
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.black),
                                      ),
                                    )),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "swipeRightToViewMoreSlots".tr,
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'timeSlot'.tr,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            timeList.first,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(width: 16.0),
                      // pickedDate().toString() == "null"
                      //     ?
                      // Container(
                      //   height: 200,
                      //   width: MediaQuery.of(context).size.width * 0.75,
                      //   child: LayoutBuilder(builder: (context, constraints) {
                      //     return PageView.builder(
                      //         controller: _pageController,
                      //         itemCount: upcomingDateList.length,
                      //         itemBuilder: (context, index) {
                      //           return Column(
                      //             children: [
                      //               Text(
                      //                 '${DateFormat('EEEE').format(upcomingDateList[index])},',
                      //                 style: const TextStyle(fontSize: 14),
                      //               ),
                      //               Container(
                      //                 // width: constraints
                      //                 //     .maxWidth, // or any desired width
                      //                 // height: constraints
                      //                 //     .maxHeight, // or any desired height
                      //                 margin: const EdgeInsets.all(8),
                      //                 child: Center(
                      //                   child: Text(
                      //                     '${upcomingDateList[index].day}/${upcomingDateList[index].month}/${upcomingDateList[index].year}',
                      //                     style: const TextStyle(fontSize: 14),
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(height: 8.0),
                      //               ElevatedButton(
                      //                 style: ElevatedButton.styleFrom(
                      //                   shape: const RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.only(
                      //                       bottomLeft: Radius.circular(0.0),
                      //                     ),
                      //                   ),
                      //                   backgroundColor:
                      //                       selectedIndices.contains(index)
                      //                           ? primaryColor
                      //                           : Colors.white,
                      //                   side: const BorderSide(
                      //                       color: primaryColor),
                      //                   elevation: 0,
                      //                 ),
                      //                 onPressed: () async {
                      //                   if (selectedDates.length == 1) {
                      //                     selectedDates[0] = datesOnly[index];
                      //                   } else {
                      //                     selectedDates.add(datesOnly[index]);
                      //                   }

                      //                   SharedPreferences pref =
                      //                       await SharedPreferences
                      //                           .getInstance();
                      //                   pref.setString("selectedData",
                      //                       selectedDates.toString());
                      //                   String prefval = pref
                      //                       .getString("selectedDate")
                      //                       .toString();

                      //                   setState(() {
                      //                     // Reset the color of the last selected button
                      //                     if (lastSelectedIndex != -1) {
                      //                       selectedIndices
                      //                           .remove(lastSelectedIndex);
                      //                     }

                      //                     // Update the color of the current button
                      //                     if (selectedIndices.contains(index)) {
                      //                       selectedIndices.remove(index);
                      //                     } else {
                      //                       selectedIndices.add(index);
                      //                     }

                      //                     // Update the last selected index
                      //                     lastSelectedIndex = index;
                      //                   });

                      //                   // Print the selected date
                      //                   print(
                      //                       'Selected Date: ${datesOnly[index]}');
                      //                 },
                      //                 child: selectedIndices.contains(index)
                      //                     ? Text(
                      //                         'available'.tr,
                      //                         style: const TextStyle(
                      //                             color: textcolor),
                      //                       )
                      //                     : Text(
                      //                         'available'.tr,
                      //                         style: const TextStyle(
                      //                             color: primaryColor),
                      //                       ),
                      //               )
                      //             ],
                      //           );
                      //         });
                      //   }),
                      // ),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: 1100,
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: upcomingDateList.map((date) {
                                      int index =
                                          upcomingDateList.indexOf(date);

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${DateFormat('EEEE').format(date)}',
                                              style: const TextStyle(
                                                  fontSize: 11, color: appbar),
                                            ),
                                            Container(
                                              // margin: const EdgeInsets.all(8),
                                              child: Center(
                                                child: Text(
                                                  '${DateFormat('dd/MM/yyyy').format(date)}',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: appbar,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              width: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom:
                                                      8.0), // Add margin for spacing
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        appbar, // Choose your border color
                                                    width:
                                                        0.7, // Choose your border width
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                  ),
                                                ),
                                                backgroundColor: selectedIndices
                                                        .contains(index)
                                                    ? primaryColor
                                                    : Colors.white,
                                                side: const BorderSide(
                                                    color: primaryColor),
                                                elevation: 0,
                                              ),
                                              onPressed: () async {
                                                // availabiltyCandarId[index];
                                                // print("ACI" +
                                                //     availabiltyCandarId[index]
                                                //         .toString());
                                                fetchAvailabilityCalendar();
                                                getAvailabilityCalendar(
                                                    availabiltyCandarId[index]);
                                                if (selectedDates.length == 1) {
                                                  selectedDates[0] =
                                                      datesOnly[index];
                                                } else {
                                                  selectedDates
                                                      .add(datesOnly[index]);
                                                }

                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setString("selectedData",
                                                    selectedDates.toString());
                                                String prefval = pref
                                                    .getString("selectedDate")
                                                    .toString();

                                                setState(() {
                                                  // Reset the color of the last selected button
                                                  if (lastSelectedIndex != -1) {
                                                    selectedIndices.remove(
                                                        lastSelectedIndex);
                                                  }

                                                  // Update the color of the current button
                                                  if (selectedIndices
                                                      .contains(index)) {
                                                    selectedIndices
                                                        .remove(index);
                                                  } else {
                                                    selectedIndices.add(index);
                                                  }

                                                  // Update the last selected index
                                                  lastSelectedIndex = index;
                                                });

                                                // Print the selected date
                                                print(
                                                    'Selected Date: ${datesOnly[index]}');
                                              },
                                              child: selectedIndices
                                                      .contains(index)
                                                  ? Text(
                                                      'available'.tr,
                                                      style: const TextStyle(
                                                          color: textcolor),
                                                    )
                                                  : Text(
                                                      'available'.tr,
                                                      style: const TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 11),
                                                    ),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width:50),
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
                              side: const BorderSide(color: Colors.deepPurple),
                              elevation: 0,
                            ),
                            onPressed: () {
                              // Handle button press
                              Navigator.pop(context);
                            },
                            child: Text(
                              'cancelButton'.tr,
                              style: const TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
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
                              side: const BorderSide(color: primaryColor),
                              elevation: 0,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(''),
                                    content: Text("areYouSure".tr),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancelButton'.tr),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          confirmAppointment(context);
                                        },
                                        child: Text('confirm'.tr),
                                      ),
                                    ],
                                  );
                                },
                              );
                              // confirmAppointment(context);
                            },
                            child: Text(
                              'confirm'.tr,
                              style: const TextStyle(color: textcolor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}