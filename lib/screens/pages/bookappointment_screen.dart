import 'dart:async';
import 'dart:convert';

import 'package:QBB/providers/studymodel.dart';
import 'package:flutter/material.dart';
import 'package:QBB/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/userid.dart';
import 'appointments.dart';
import 'erorr_popup.dart';

class BookAppScreen extends StatefulWidget {
  const BookAppScreen({Key? key}) : super(key: key);

  @override
  BookAppScreenState createState() => BookAppScreenState();
}

class BookAppScreenState extends State<BookAppScreen> {
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
  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        timeList = List<String>.from(jsonResponse['timelist']);
        availCId = List<String>.from(jsonResponse['timelist']);
        // nextAvailableDates =
        //     List<String>.from(jsonResponse['nextAvilableDateList']);
      });
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: upcomingDates.isNotEmpty ? upcomingDates[0] : DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (picked == null) {
  //     picked = DateTime.now();
  //     setState(() {
  //       generateUpcomingDates(picked!);
  //       generateUpcomingDatesandDays(picked!);
  //       // timeList.removeWhere((time) {
  //       //   DateTime parsedDate = DateTime.parse(time);
  //       //   return parsedDate.isBefore(picked);
  //       // });
  //     });
  //   }

  //   if (picked != null &&
  //       (upcomingDates.isEmpty || picked != upcomingDates[0])) {
  //     setState(() {
  //       generateUpcomingDates(picked!);
  //       generateUpcomingDatesandDays(picked!);
  //       // timeList.removeWhere((time) {
  //       //   DateTime parsedDate = DateTime.parse(time);
  //       //   return parsedDate.isBefore(picked);
  //       // });
  //     });

  //     // Fetch data after selecting a date
  //   }
  // }

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
      generateUpcomingDates(picked!);
      generateUpcomingDatesandDays(picked);
    });

    // Fetch data after selecting a date
  }

  List<DateTime> upcomingDateList = [];

List<DateTime> generateDates() {
  DateTime currentDate = DateTime.now();

  for (int i = 0; i < 5; i++) {
    DateTime nextDate = currentDate.add(Duration(days: i));

    // Only add dates within the same month
    if (nextDate.month == currentDate.month) {
      upcomingDateList.add(nextDate);
    }
  }

  return upcomingDateList;
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

    _dateController.text =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
  }

  void generateUpcomingDates(DateTime selectedDate) {
    upcomingDates = [];
    DateTime tempDate = selectedDate;

    // Move to the next week's starting day (7 days from the selected date)
    tempDate = tempDate.add(Duration(days: (7 - tempDate.weekday + 1) % 7));

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

    _dateController.text =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
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

  Future<void> confirmAppointment(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? qid = await getQIDFromSharedPreferences();
    String studyId = pref.getString("selectedStudyId").toString();
    int? studyIdInt = int.tryParse(studyId);
    String visitTypeId = pref.getString("selectedVisitTypeID").toString();
    int? visitTypeIDInt = int.tryParse(visitTypeId);
    String? availabilityCalendarId = pref.getString("availabilityCalendarId");

    // Check if selectedSlot is null, set selectedDate accordingly
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
      'Authorization': 'Bearer ${token.replaceAll('"', '')}',
    };

    Map<String, dynamic> queryParams = {
      "QID": '$qid',
      "StudyId": studyId,
      "ShiftCode": 'shft',
      "VisitTypeId": visitTypeId,
      "PersonGradeId": "4",
      "AvailabilityCalenderId": '11567',
      "language": 'langChange'.tr,
      "AppointmentTypeId": "1"
    };
    print(queryParams);

    // Construct the API URL
    Uri apiUrl = Uri.parse(
        "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentAPI?QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&ShiftCode=${queryParams['ShiftCode']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AvailabilityCalenderId=${queryParams['AvailabilityCalenderId']}&language=${queryParams['language']}&AppointmentTypeId=${queryParams['AppointmentTypeId']}");

    print("API URL");
    print(apiUrl);

    try {
      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: queryParams);

      // Process the response here
      print(queryParams);

      if (response.statusCode == 200) {
        // Successful response, show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text(json.decode(response.body)["Message"]),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Appointments(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
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
      // Handle network errors or other exceptions
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
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
    generateDates();
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
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
                      const Text(
                        "Next Week",
                        style: TextStyle(
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next Available Dates",
                        style: TextStyle(
                            color: appbar,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 500, // or a fixed width
                        height: 70, // or any fixed height
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return PageView.builder(
                              controller: _pageController,
                              itemCount: upcomingDates.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: constraints
                                      .maxWidth, // or any desired width
                                  height: constraints
                                      .maxHeight, // or any desired height
                                  margin: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      '${upcomingDates[index].day}/${upcomingDates[index].month}/${upcomingDates[index].year}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Swipe right to see more slots",
                          style: TextStyle(color: primaryColor, fontSize: 11),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'timeSlot'.tr,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            timeList.first,
                            style: const TextStyle(
                              fontSize: 14.0,
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
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: upcomingDateList.map((date) {
                                int index = upcomingDateList.indexOf(date);
                          
                                return Column(
                                  children: [
                                    Text(
                                      '${DateFormat('EEEE').format(date)},',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                          '${date.day}/${date.month}/${date.year}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0.0),
                                          ),
                                        ),
                                        backgroundColor: selectedIndices.contains(index) ? primaryColor : Colors.white,
                                        side: const BorderSide(color: primaryColor),
                                        elevation: 0,
                                      ),
                                      onPressed: () async {
                                        if (selectedDates.length == 1) {
                                          selectedDates[0] = datesOnly[index];
                                        } else {
                                          selectedDates.add(datesOnly[index]);
                                        }
                          
                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                        pref.setString("selectedData", selectedDates.toString());
                                        String prefval = pref.getString("selectedDate").toString();
                          
                                        setState(() {
                                          // Reset the color of the last selected button
                                          if (lastSelectedIndex != -1) {
                                            selectedIndices.remove(lastSelectedIndex);
                                          }
                          
                                          // Update the color of the current button
                                          if (selectedIndices.contains(index)) {
                                            selectedIndices.remove(index);
                                          } else {
                                            selectedIndices.add(index);
                                          }
                          
                                          // Update the last selected index
                                          lastSelectedIndex = index;
                                        });
                          
                                        // Print the selected date
                                        print('Selected Date: ${datesOnly[index]}');
                                      },
                                      child: selectedIndices.contains(index)
                                          ? Text(
                                              'available'.tr,
                                              style: const TextStyle(color: textcolor),
                                            )
                                          : Text(
                                              'available'.tr,
                                              style: const TextStyle(color: primaryColor),
                                            ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                    ],
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
                              'cancel'.tr,
                              style: TextStyle(color: Colors.deepPurple),
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
                            ),
                            onPressed: () {
                              confirmAppointment(context);
                            },
                            child: Text('confirm'.tr),
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
