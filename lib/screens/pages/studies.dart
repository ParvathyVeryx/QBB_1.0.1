import 'package:QBB/providers/studymodel.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/studies_api.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/screens/pages/notification.dart';
import 'package:QBB/sidebar.dart';
import 'package:get/get.dart';

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
    studies = [];
    print('api calling...');
    
      fetchStudyMasterAPI().then((studyList) {
        setState(() {
          studies = studyList;
          isLoading = false; // Set loading state to false when data is fetched
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (studies.isEmpty) {
      // Return a loading indicator or handle the case appropriately
      return LoaderWidget(); // Replace with your loading widget
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        drawer: const SideMenu(),
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
              Text(
                'studies'.tr,
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
        body: Stack(
          children: [
            SingleChildScrollView(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'studyCode'.tr,
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 195, 195, 195),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(study.studyCode),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'studyName'.tr,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 195, 195, 195),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(study.studyName),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                study.studyDescription,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BookAppointments()),
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
                                  padding: EdgeInsets.fromLTRB(
                                      10.0, 15.0, 10.0, 15.0),
                                  child: Text(
                                    'bookAnAppointment'.tr,
                                    style: TextStyle(
                                      color: textcolor,
                                    ),
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
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
