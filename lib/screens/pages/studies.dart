import 'package:QBB/customNavBar.dart';
import 'package:QBB/providers/studymodel.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/studies_api.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/screens/pages/notification.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../localestring.dart';
import 'appointments.dart';
import 'homescreen_nk.dart';
import 'profile.dart';
import 'results.dart';

class Studies extends StatefulWidget {
  const Studies({Key? key}) : super(key: key);

  @override
  StudiesState createState() => StudiesState();
}

class StudiesState extends State<Studies> {
  late List<Study> studies;
  bool isLoading = true; // Add a loading state
  @override
  void initState() {
    // studies = [];
    super.initState();
  }

  refreshPage() {
    studies = [];

    fetchStudyMasterAPI().then((studyList) {
      setState(() {
        studies = studyList;
        isLoading = false; // Set loading state to false when data is fetched
      });
    });
  }

  // Future<String> getData() async {

  // }

  @override
  Widget build(BuildContext context) {
    // if (studies.isEmpty) {
    //   // Return a loading indicator or handle the case appropriately
    //   return LoaderWidget(); // Replace with your loading widget
    // }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        drawer: const SideMenu(),
        bottomNavigationBar: CustomTabDefault(),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: appbar,
          ),
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
              Text(
                'studiesAppointment'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Impact',
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
                icon: const Icon(Icons.notifications_none_outlined),
                iconSize: 30.0,
                color: textcolor,
              )
            ],
          ),
          backgroundColor: appbar,
        ),
        body: FutureBuilder<List<Study>>(
          future: fetchStudyMasterAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return Center(child: CircularProgressIndicator());
              isLoading = true;
              return Center(child: LoaderWidget());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              List<Study> studies = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: studies.map((study) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
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
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'studyCode'.tr,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 195, 195, 195),
                                            fontSize: 11,
                                          ),
                                        ),
                                        Text(
                                          study.studyCode,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'studyName'.tr,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 195, 195, 195),
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            study.studyName,
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          // Text()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  study.studyDescription,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12.0),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    // Fetch the "Id" from the study JSON
                                    int? studyId = study
                                        .Id; // Replace "id" with the actual getter in your Study class

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookAppointments(
                                          studyName: study
                                              .studyName, // Pass the study name as an argument
                                          studyId: studyId,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'bookAnAppointment'.tr,
                                      style: const TextStyle(
                                          color: textcolor, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
