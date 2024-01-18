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
    _loadSelectedLanguage();
  }

  var selectedLanguagePref;
  _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('langEn').toString();
      if (selectedLanguage == "false") {
        selectedLanguage = 'Arabic';
      } else {
        selectedLanguage = 'English';
      } // Default language if none is stored
    });
  }

  _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', language);
  }

  String selectedLanguage = '';
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
              const SizedBox(height: 140), // Use SizedBox for spacing
              ListTile(
                leading: Image.asset(
                  "assets/images/date.png",
                  width: 30.0,
                  height: 30.0,
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
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/appointment.png",
                  width: 30.0,
                  height: 30.0,
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
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/about.png",
                  width: 30.0,
                  height: 30.0,
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
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/document.png",
                  width: 30.0,
                  height: 30.0,
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
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/student.png",
                  width: 30.0,
                  height: 30.0,
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
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/user.png",
                  width: 30.0,
                  height: 30.0,
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
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/language.png",
                  width: 30.0,
                  height: 30.0,
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
                        title: Text('Select Language'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text('English'),
                              leading: Radio(
                                value: 'English',
                                groupValue: selectedLanguage,
                                onChanged: (value) async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString("langEn", "true");
                                  setState(() {
                                    selectedLanguage = value!;
                                    // _saveSelectedLanguage(value);
                                    updateLanguage(locale[0]['locale']);
                                    refreshAPI();
                                    Provider.of<RefreshNotifier>(context,
                                            listen: false)
                                        .triggerRefresh();
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('عربي'),
                              leading: Radio(
                                value: 'Arabic',
                                groupValue: selectedLanguage,
                                onChanged: (value) async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString("langEn", "false");
                                  setState(() {
                                    selectedLanguage = value!;
                                    // _saveSelectedLanguage(value);

                                    updateLanguage(locale[1]['locale']);
                                    refreshAPI();
                                    Provider.of<RefreshNotifier>(context,
                                            listen: false)
                                        .triggerRefresh();
                                    
                                    
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('cancelButton'.tr),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Add logic to handle the selected language
                              if (selectedLanguage.isNotEmpty) {
                                // Your logic to handle the selected language
                                refreshAPI();
                                print('Selected language: $selectedLanguage');
                                Navigator.of(context).pop(); // Close the dialog
                              } else {
                                // Show an error or inform the user to select a language
                              }
                            },
                            child: Text('ok'.tr),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              ListTile(
                leading: Image.asset(
                  "assets/images/turn-off.png",
                  width: 30.0,
                  height: 30.0,
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
    var lang = pref.getString("langEn").toString();
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

  // _buildRadioListTile(String title, String value) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var lang = pref.getString("langEn");
  //   var setLang;
  //   if (lang == "true") {
  //     setLang = "en";
  //   } else {
  //     setLang = "ar";
  //   }

  //   return RadioListTile<String>(
  //     title: Text(title),
  //     value: value,
  //     groupValue: value,
  //     onChanged: (newValue) {
  //       setState(() {
  //         lang = newValue!;
  //       });
  //     },
  //     activeColor: primaryColor,
  //   );
  // }

  String registrationMode = '';

  Widget _buildRadioListTile(String title, String value) {
    print('nnnnnnnnnnnnnnnnnnnnnn' + getlan.toString());
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: getlan.toString(),
      onChanged: (newValue) {
        setState(() {
          registrationMode = newValue!;
        });
      },
      activeColor: primaryColor,
    );
  }

  void _reloadPage() {
    Navigator.of(context).pop(); // Pop the current route
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => MyCurrentPage())); // Push the page again
  }

  Future<void> refreshAPI() async {
    await fetchStudyMasterAPI();
  }
}

_refreshPage() {
  print('Refreshing api...');
  fetchStudyMasterAPI();
}
