import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/marital_status_api.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:QBB/screens/pages/results.dart';
import 'package:QBB/sidebar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QBB/nirmal_api.dart/user_profile_photo_api.dart';
import 'package:QBB/nirmal_api.dart/user_profileapi_get.dart';
import 'package:QBB/screens/pages/about.dart';
import 'package:QBB/screens/profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointments.dart';
import 'book_appintment_nk.dart';
import 'homescreen_nk.dart';

class UserProfileData {
  String userName = '';
  String mobile = '';
  String email = '';
  String nationality = '';
  String hCNo = '';
  String dob = '';
  String qid = '';
  String gender = '';
  String maritalStatus = '';
  String dateOnly = '';
  String profilePicture = '';
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String _qid = '';

  String _profilePicture = '';
  late File? _selectedImage; // Add this line to define _selectedImage

  bool _isLoading = false; // Add this line for loading indicator
  int currentIndex = 4;

  Future<UserProfileData> getUserProfileData() async {
    String responseBody = await callUserProfileAPIGet();

    UserProfileData userProfileData = UserProfileData();
    try {
      
        String middleName =
            json.decode(responseBody)['MiddleName'].toString() == "null"
                ? ''
                : json.decode(responseBody)['MiddleName'].toString() + '';
        userProfileData.userName =
            json.decode(responseBody)['FirstName'].toString() +
                ' ' +
                middleName +
                json.decode(responseBody)['LastName'].toString();

        userProfileData.mobile =
            json.decode(responseBody)['RecoveryMobile'].toString();
        userProfileData.email =
            json.decode(responseBody)['RecoverEmail'].toString();

        userProfileData.nationality =
            json.decode(responseBody)["Nationality"].toString() ?? ' ';

        userProfileData.hCNo =
            json.decode(responseBody)['HealthCardNo'].toString() == "null"
                ? ""
                : json.decode(responseBody)['HealthCardNo'].toString();

        userProfileData.dob = json.decode(responseBody)['Dob'].toString();
        DateTime dateTime = DateTime.parse(userProfileData.dob);
        userProfileData.dateOnly =
            "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

        userProfileData.qid = json.decode(responseBody)['QID'].toString();
        userProfileData.gender = json.decode(responseBody)['Gender'].toString();
        userProfileData.maritalStatus =
            json.decode(responseBody)['MaritalStatus'].toString();
        _profilePicture = json.decode(responseBody)['Photo'] ?? '';
        _isLoading = false;
      
      print("is loading is false");
    } catch (e) {
      _isLoading = false;
      print("Catch Exception during API request: $e");
      // Handle exception here if needed
    } finally {
      // Set loading to false even if there's an exception
      _isLoading = false;
    }

    return userProfileData;
  }

  @override
  void initState() {
    super.initState();
    // getUserProfileData();
  }

  // void _delayedLoadUserData() {
  //   Timer(const Duration(seconds: 2), () {
  //     getUserProfileData();
  //   });
  // }

  String userName = '';
  String userMName = '';
  String userLanme = '';
  String qid = '';
  String mobile = '';
  String email = '';
  String gender = '';
  String hCNo = '';
  String dob = '';
  String nationality = '';
  String maritalStatus = '';
  String dateOnly = '';

  // loadUserData() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   Map<String, dynamic> userDetails =
  //       json.decode(pref.getString('userDetails') ?? '{}');

  //   try {
  //     String responseBody = await callUserProfileAPIGet();
  //     print("Response from API: $responseBody");

  //     Map<String, dynamic> responseJson = json.decode(responseBody);
  //     print('reponse' + json.decode(responseBody)["Nationality"].toString());
  //     setState(() {
  //       String middleName =
  //           json.decode(responseBody)['MiddleName'].toString() == "null"
  //               ? ''
  //               : json.decode(responseBody)['MiddleName'].toString() + '';
  //       userName = json.decode(responseBody)['FirstName'].toString() +
  //           ' ' +
  //           middleName +
  //           json.decode(responseBody)['LastName'].toString();
  //       print('jjjjjjjjjjjjjjjjjjjjjjjj' +
  //           pref.getString('userFName').toString());
  //       print("UserName" + userName.toString());
  //       mobile = json.decode(responseBody)['RecoveryMobile'].toString();
  //       qid = json.decode(responseBody)['QID'].toString();
  //       gender = json.decode(responseBody)['Gender'].toString();
  //       hCNo = json.decode(responseBody)['HealthCardNo'].toString() == "null"
  //           ? ""
  //           : json.decode(responseBody)['HealthCardNo'].toString();
  //       dob = json.decode(responseBody)['Dob'].toString();
  //       DateTime dateTime = DateTime.parse(dob);
  //       dateOnly =
  //           "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  //       nationality =
  //           json.decode(responseBody)["Nationality"].toString() ?? ' ';
  //       email = json.decode(responseBody)['RecoverEmail'].toString();
  //       maritalStatus = json.decode(responseBody)['MaritalStatus'].toString();
  //       _profilePicture = json.decode(responseBody)['Photo'] ?? '';

  //       _isLoading = false; // Set loading to false when data is loaded
  //     });
  //   } catch (e) {
  //     print("Catch Exception during API request: $e");
  //     _isLoading = false; // Set loading to false even if there's an exception
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future<String> userProfilePic = getUserProfileData()
        .then((userProfileData) => userProfileData.profilePicture);
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
            Text(
              'profile'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Impact',
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined),
              iconSize: 30.0,
              color: Colors.white,
            )
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: const SideMenu(),
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
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
            if (index == 1) {
              // Handle tap for the "HOME" item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Appointments()),
              );
            }
            if (index == 2) {
              // Handle tap for the "HOME" item
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookAppointments()),
              );
            }
            if (index == 3) {
              // Handle tap for the "HOME" item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Results()),
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
      body: _isLoading
          ? Center(child: LoaderWidget()) // Loader widget
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.white
                    ], // Two different colors
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.150, 0.150],
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profilePicture.isNotEmpty
                              ? _getImageProvider(_profilePicture)
                              : const AssetImage('assets/images/user.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryColor, // Set the border color
                                  width: 1.0, // Set the border width
                                ),
                                color: primaryColor),
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  // Open the image picker
                                  final pickedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedImage != null) {
                                    setState(() {
                                      _selectedImage = File(pickedImage.path);
                                    });

                                    // Call the API with the selected image
                                    await uploadUserProfilePhoto(
                                        _qid, _selectedImage!);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ProfileInfoRow(
                      label: 'fullName'.tr,
                      value: getUserProfileData()
                          .then((userProfileData) => userProfileData.userName),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                        label: 'mobile'.tr,
                        value: getUserProfileData()
                            .then((userProfileData) => userProfileData.mobile)),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'qid'.tr,
                      value: getUserProfileData()
                          .then((userProfileData) => userProfileData.qid),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'gender'.tr,
                      value: getUserProfileData()
                          .then((userProfileData) => userProfileData.gender),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'healthCardNo'.tr,
                      value: getUserProfileData()
                          .then((userProfileData) => userProfileData.hCNo),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'dateOfBirth'.tr,
                      value: getUserProfileData()
                          .then((userProfileData) => userProfileData.dateOnly),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'nationality'.tr,
                      value: getUserProfileData().then(
                          (userProfileData) => userProfileData.nationality),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'email'.tr,
                      value: getUserProfileData()
                          .then((userProfileData) => userProfileData.email),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'maritalStatus'.tr,
                      value: getUserProfileData().then(
                          (userProfileData) => userProfileData.maritalStatus),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15, 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditUser(
                                    email: email,
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                                // Set background color

                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      12.0), // Rounded border at bottom-left
                                ),
                                side: BorderSide(
                                  color:
                                      secondaryColor, // Specify the border color here
                                  width: 1.0, // Specify the border width here
                                ),
                              ),
                            )),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                              child: Text(
                                'settingsPageProfile'.tr,
                                style: const TextStyle(
                                    color: secondaryColor, fontSize: 13),
                              ),
                            )),
                      ),
                    ),
                    const PinkDivider(),
                  ],
                ),
              ),
            ),
    );
  }
}

class PinkDivider extends StatelessWidget {
  const PinkDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color.fromARGB(255, 228, 228, 228),
      margin: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Add horizontal padding
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final Future<String> value;

  const ProfileInfoRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.50,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16), // Add left padding
//                 child: Text(
//                   label,
//                   style: const TextStyle(color: Colors.grey, fontSize: 13),
//                 ),
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.50,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16), // Add right padding
//                 child: Directionality(
//                   textDirection: TextDirection.ltr,
//                   child: Text(
//                     value.tr,
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If data is still loading, return a loading indicator

          return Container();
        } else if (snapshot.hasError) {
          // If there's an error, return an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If data has been loaded successfully, display the Row
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16), // Add left padding
                      child: Text(
                        label,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16), // Add right padding
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          snapshot.data ?? '', // Use the fetched data
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

ImageProvider _getImageProvider(String profilePicture) {
  if (profilePicture.startsWith('data:image')) {
    // If the profile picture is a base64-encoded image
    List<String> parts = profilePicture.split(',');
    if (parts.length == 2) {
      String base64String = parts[1];
      Uint8List bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    }
  }

  // If the profile picture is a network image
  return NetworkImage(profilePicture);
}
