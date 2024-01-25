import 'dart:ffi';

import 'package:QBB/constants.dart';
import 'package:QBB/main.dart';
import 'package:QBB/nirmal/login_screen.dart';
import 'package:QBB/nirmal_api.dart/studies_api.dart';
import 'package:QBB/screens/pages/about.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:QBB/screens/pages/results.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
// import 'package:flutter_gen/gen_l10n/app-localizations.dart';

import 'screens/pages/studies.dart';

class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'English';

  String get selectedLanguage => _selectedLanguage;

  void updateLanguage(String newLanguage) {
    _selectedLanguage = newLanguage;
    notifyListeners();
  }
}

class CustomAlertDialogShape extends RoundedRectangleBorder {
  final double bottomLeftRadius;

  CustomAlertDialogShape({
    this.bottomLeftRadius = 30.0,
    double sideRadius = 0.0,
    double bottomRightRadius = 0.0,
    double sideHeight = 0.0,
    sideHeightbottom = 30.0,
  }) : super(
          side: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(sideRadius),
            topRight: Radius.circular(sideRadius),
            bottomRight: Radius.circular(bottomRightRadius),
            bottomLeft: Radius.circular(bottomLeftRadius),
          ),
        );
}

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => sideMenuclass();
}

class sideMenuclass extends State<SideMenu> {
  @override
  void initState() {
    super.initState();
    print('iiiiiiiiiiiiiiiiiiiiii' + getlan.toString());
    loadSelectedLanguage();
  }

  String selectedLanguage = '';

  Future<String> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String selectedLanguagePref = prefs.getString('langSelected').toString();
    print('gggggggggggggggggggggddddddddddddddddd' + selectedLanguagePref);
    if (selectedLanguagePref == "English") {
      selectedLanguage = 'English';
      print('pppppppppppppppppppppppppppppp' + selectedLanguage);
      return selectedLanguage;
    } else {
      selectedLanguage = 'Arabic';
      print('pppppppppppppppppppppppppppppp' + selectedLanguage);
      return selectedLanguage;
    }
  }

  _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', language);
  }

  // selectedLanguage = selectedLanguagePref;

  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'عربي', 'locale': const Locale('ar')},
  ];

  // final List<Map<String, dynamic>> locale = [
  //   {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
  //   {'name': 'عربي', 'locale': Locale('ar')},
  // ];

  updateLanguage(Locale locale) {
    // Get.back();
    Get.updateLocale(locale);
  }

  String lang = 'English';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: null,
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      elevation: 0,
      width: 240,
      child: Container(
        decoration: const BoxDecoration(
          color: primaryColor, // Set the background color
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0), // Set border radius to 0
            bottomRight: Radius.circular(0), // Set border radius to 0
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                "assets/images/logo-welcome-screen.png",
                width: 65.0,
                height: 65.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 30,
              ), // Use SizedBox for spacing
              ListTile(
                leading: Image.asset(
                  "assets/images/date.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'bookAnAppointment'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                // title: Text(
                //   AppLocalizations.of(context)!.bookAnAppointment.toString(),
                //   style: TextStyle(color: textcolor, fontSize: 14),
                // ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookAppointments()),
                  );
                  // Handle onTap action
                  // For example, you can navigate to a different screen.
                  // Navigator.pop(context); // Close the drawer
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/appointment.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'myAppointments'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Appointments()),
                  );
                },
              ),
              // Add more DrawerListTile widgets as needed

              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/document.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'resultsStatus'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Results()),
                  );
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/student.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'studies'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Studies()),
                  );
                  // Handle onTap action
                  // For example, you can navigate to a different screen.
                  // Navigator.pop(context); // Close the drawer
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/user.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'profile'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/about.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'aboutUs'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  // Handle onTap action
                  // For example, you can navigate to a different screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUs()),
                  );
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/language.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'changeLanguage'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: CustomAlertDialogShape(bottomLeftRadius: 36.0),
                        title: Column(
                          children: [
                            Center(
                                child: Text('changeLanguage'.tr,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600))),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                          ],
                        ),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                  value: 'English',
                                  title: Text(
                                    'English',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: selectedLanguage == 'English'
                                          ? secondaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                  groupValue: selectedLanguage,

                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    print(
                                        'selected language' + selectedLanguage);
                                    setState(() {
                                      selectedLanguage = value!;
                                    });
                                  },
                                  // Selection color
                                ),

                                RadioListTile(
                                  title: Text(
                                    'عربي',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: selectedLanguage == 'Arabic'
                                          ? secondaryColor
                                          : Colors.black,
                                    ),
                                  ),
                                  value: 'Arabic',
                                  groupValue: selectedLanguage,
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLanguage = value!;
                                    });
                                  },
                                ),
                                // ),
                              ],
                            );
                          },
                        ),
                        actions: [
                          Column(
                            children: [
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var selectedLanguagePref =
                                          prefs.getString('langSelected').toString();
                                      if (selectedLanguagePref == "Arabic") {
                                        selectedLanguage = 'Arabic';
                                      } else {
                                        selectedLanguage = 'English';
                                      }
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('cancelButton'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (selectedLanguage.isNotEmpty) {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setString(
                                            "langSelected",
                                            selectedLanguage == 'English'
                                                ? "English"
                                                : "Arabic");

                                        updateLanguage(
                                            selectedLanguage == 'English'
                                                ? locale[0]['locale']
                                                : locale[1]['locale']);

                                        print(
                                            'Selected language: $selectedLanguage');
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      } else {
                                        // Show an error or inform the user to select a language
                                      }
                                    },
                                    child: Text('ok'.tr),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/turn-off.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'signOut'.tr,
                  style: TextStyle(color: textcolor, fontSize: 14),
                ),
                onTap: () {
                  // Handle onTap action
                  // For example, you can navigate to a different screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ); // Close the drawer
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  var getlan;
  void getlang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = pref.getString("langSelected").toString();
    if (lang == "false") {
      getlan = "ar";
    } else {
      getlan = "en";
    }
    print('nnnnnnnnnnnnnnnnnnnnnn' + getlan.toString());
  }

  var langg;
  RadioListTile<String> _buildRadioListTile2(String title, String value) {
    if (getlan == "en") {
      langg = "English";
    } else {
      langg = "Arabic";
    }
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: langg,
      onChanged: (value) async {
        setState(() {
          selectedLanguage = value!;
          print('ggggggggggggggggggggg' + selectedLanguage);
        });
      },
    );
  }
}

class Divider extends StatelessWidget {
  const Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Color.fromARGB(255, 184, 184, 184),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
    );
  }
}
