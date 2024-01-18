// import 'package:QBB/constants.dart';
// import 'package:QBB/sidebar.dart';
// import 'package:flutter/material.dart';

// class Results extends StatefulWidget {
//   const Results({super.key});

//   @override
//   ResultsState createState() => ResultsState();
// }

// class ResultsState extends State<Results> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context);
//           return false;
//         },
//         child: Scaffold(
//             drawer: const SideMenu(),
//             appBar: AppBar(
//               iconTheme: const IconThemeData(color: textcolor),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Image.asset(
//                       "assets/images/icon.png",
//                       width: 40.0,
//                       height: 40.0,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   // SizedBox(
//                   //   width: 50.0,
//                   // ),
//                   const Text(
//                     'Results',
//                     style: TextStyle(
//                       color: Colors.white,
//                       // fontWeight: FontWeight.w900 ,
//                       fontFamily: 'Impact',
//                     ),
//                   ),
//                   // SizedBox(
//                   //   width: 50.0,
//                   // ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.notifications_none_outlined),
//                     iconSize: 30.0,
//                     color: textcolor,
//                   )
//                 ],
//               ),
//               backgroundColor: appbar,
//             ),
//             body: SingleChildScrollView(
//               child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.9,
//                   child: const Center(
//                       child: Text(
//                     "No Results Available",
//                     style: TextStyle(fontSize: 18),
//                   ))),
//             )));
//   }
// }
// ------------------------------------------------------------------------------
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'appointments.dart';
import 'homescreen_nk.dart';
import 'profile.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  ResultsState createState() => ResultsState();
}

class ResultsState extends State<Results> {
  int currentIndex = 3;
  final List<Map<String, dynamic>> resultAppointments = [
    {
      'date': DateTime.now(),
      'VisittypeName': 'Routine Visit',
      'AppoinmenttypName': 'General Checkup',
      'StudyName': 'Health Study',
    },
    // Add more sample data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: textcolor),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Text(
              'results'.tr,
              style: TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.w900 ,
                fontFamily: 'Impact',
              ),
            ),
            // SizedBox(
            //   width: 50.0,
            // ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined),
              iconSize: 30.0,
              color: textcolor,
            )
          ],
        ),
        backgroundColor: appbar,
      ),
      drawer: SideMenu(),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: textcolor,
          unselectedItemColor: textcolor,
          backgroundColor: primaryColor,
          currentIndex: currentIndex,
          unselectedFontSize: 7,
          selectedFontSize: 7,
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: secondaryColor),
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
            if (index == 2) {
              // Handle tap for the "HOME" item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookAppointments()),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              for (final appointment in resultAppointments)
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
                      padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    color:
                                        Colors.blue, // Replace with your color
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 3.0, 12, 3),
                                      child: Text(
                                        DateFormat('dd')
                                            .format(appointment['date'])
                                            .toString(),
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 16,
                                          backgroundColor: Colors
                                              .blue, // Replace with your color
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('MM-yyyy')
                                            .format(appointment['date'])
                                            .toString(),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              18, 3.0, 18, 3),
                                          child: Text(
                                            'completed'.tr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    buildInfoItem(
                                      imageAsset: "assets/images/fast.png",
                                      title: 'timeSlot'.tr,
                                      content: '9:00 AM - 10:00 AM',
                                    ),
                                    const SizedBox(width: 20),
                                    buildInfoItem(
                                      imageAsset: "assets/images/user-time.png",
                                      title: 'visitType'.tr,
                                      content: appointment['VisittypeName']
                                          .toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    buildInfoItem(
                                      imageAsset:
                                          "assets/images/appointment-list.png",
                                      title: 'appointmentType'.tr,
                                      content: appointment['AppoinmenttypName']
                                          .toString(),
                                    ),
                                    const SizedBox(width: 40),
                                    buildInfoItem(
                                      imageAsset: "assets/images/users.png",
                                      title: 'studyName'.tr,
                                      content:
                                          appointment['StudyName'].toString(),
                                    ),
                                  ],
                                ),
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

  Widget buildInfoItem(
      {required String imageAsset,
      required String title,
      required String content}) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Image.asset(
                  imageAsset,
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 163, 163, 163),
                    fontSize: 13,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  BottomNavigationBarItem customBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
    required Color selectedColor,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: secondaryColor,
          icon: Stack(
    children: [
      Icon(icon, color: textcolor),
      if (currentIndex == index)
        Positioned.fill(
          child: Container(
            width: double.infinity,
            color: selectedColor,
            alignment: Alignment.center,
          ),
        ),
    ],
          ),
          label: label,
        );
  }
}
