// -------------
import 'package:QBB/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:QBB/screens/pages/appointments_data_extract.dart';

class Completed extends StatefulWidget {
  final List<Map<String, dynamic>> completedAppointments;

  const Completed({required this.completedAppointments, Key? key})
      : super(key: key);

  @override
  CompletedState createState() => CompletedState();
}

class CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    print('Completed Appointments: ${widget.completedAppointments}');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                for (final appointment in widget.completedAppointments)
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: appbar,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 3.0, 12, 3),
                                        child: Text(
                                          DateFormat('dd')
                                              .format(dateExtract(appointment))
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
                                            .format(dateExtract(appointment))
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.blue,
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(18, 3.0, 18, 3),
                                        child: Text(
                                          'Completed',
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
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Time Slot',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 163, 163, 163),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Visit Type',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 163, 163, 163),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    appointment['VisittypeName']
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Appointment Type',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 163, 163, 163),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Study Name',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 163, 163, 163),
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
      ),
    );
  }
}
