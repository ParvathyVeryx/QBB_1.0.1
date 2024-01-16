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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late SharedPreferences _prefs;
  String _fullName = '';
  int _userId = 0;
  String _mobile = '';
  String _qid = '';
  String _gender = '';
  String _healthCardNo = '';
  String _dob = '';
  String _nationality = '';
  String _email = '';
  String _profilePicture = '';
  late File? _selectedImage; // Add this line to define _selectedImage
  String _maritalStatus = '';
  bool _isLoading = true; // Add this line for loading indicator
  int currentIndex = 4;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userDetails =
        json.decode(_prefs.getString('userDetails') ?? '{}');

    try {
      print('calling userdate');
      String responseBody = await callUserProfileAPIGet();
      print("Response from API: $responseBody");

      Map<String, dynamic> responseJson = json.decode(responseBody);

      // Fetch Marital Status based on MaritalStatusId
      int? maritalStatusId = responseJson['MaritalId'];
      MaritalStatus maritalStatus = maritalStatusId != null
          ? await fetchMaritalStatus(maritalStatusId)
          : MaritalStatus(
              id: 0,
              name: '',
              short: '',
              description: '',
              genderId: 0); // Set a default value for marital status

      setState(() {
        String firstName = responseJson['FirstName'] ?? '';
        String middleName = responseJson['MiddleName'] ?? '';
        String lastName = responseJson['LastName'] ?? '';

        _fullName = '$firstName $middleName $lastName'.trim();
        _userId = responseJson['UserId'] ?? 0;
        _mobile = responseJson['RecoveryMobile'] ?? '';
        _qid = responseJson['QID'] ?? '';
        _gender = responseJson['Gender'] ?? '';
        _healthCardNo = responseJson['HealthCardNo'] ?? '';
        _dob = responseJson['Dob'] ?? '';
        _nationality = responseJson['Nationality'] ?? '';
        _email = responseJson['Email'] ?? '';
        _profilePicture = responseJson['Photo'] ?? ''; // Add null check here
        _maritalStatus = maritalStatus.name;
        _isLoading = false; // Set loading to false when data is loaded
      });
    } catch (e) {
      print("Catch Exception during API request: $e");
      _isLoading = false; // Set loading to false even if there's an exception
    }
  }

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
            if (index == 4) {
              BottomNavigationBarItem(
                backgroundColor: secondaryColor,
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
      body: _isLoading
          ? Center(child: LoaderWidget()) // Loader widget
          : SingleChildScrollView(
              child: Center(
                child: Expanded(
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
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
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
                          ],
                        ),
                        const SizedBox(height: 30),
                        ProfileInfoRow(label: 'fullName'.tr, value: _fullName),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(label: 'mobile'.tr, value: _mobile),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(label: 'qid'.tr, value: _qid),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(label: 'gender'.tr, value: _gender),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(
                            label: 'healthCardNo'.tr, value: _healthCardNo),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(label: 'dateOfBirth'.tr, value: _dob),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(
                            label: 'nationality'.tr, value: _nationality),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(label: 'email'.tr, value: _email),
                        const PinkDivider(),
                        const SizedBox(height: 30),
                        ProfileInfoRow(
                            label: 'maritalStatus'.tr, value: _maritalStatus),
                        const PinkDivider(),
                        OutlinedButton(
                          onPressed: () {
                            // Handle Edit Profile button press
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // builder: (context) => EditProfilePage())
                                builder: (context) => EditUser(
                                  email: _email,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.pink), // Set the border color
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                                color: Colors.pink), // Set the text color
                          ),
                        ),
                      ],
                    ),
                  ),
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
      color: primaryColor,
      margin: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Add horizontal padding
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Add left padding
              child: Text(label),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Add right padding
              child: Text(value),
            ),
          ],
        ),
      ],
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
