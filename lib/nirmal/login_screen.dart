import 'package:QBB/localestring.dart';
import 'package:QBB/nirmal/device_type.dart';
import 'package:QBB/nirmal/deviceid.dart';
import 'package:QBB/screens/api/login.dart';
import 'package:QBB/screens/authentication/registration_mode.dart';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/api/register_api.dart';
import 'package:QBB/screens/authentication/forgotPwd.dart';
import 'package:QBB/screens/authentication/loginorReg.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var QE = 'pleaseEnterValidQatarID'.tr;
  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'عربي', 'locale': const Locale('ar')},
  ];

  // final List<Map<String, dynamic>> locale = [
  //   {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
  //   {'name': 'عربي', 'locale': Locale('ar')},
  // ];

  updateLanguageLogin(Locale locale) {
    // Get.back();
    Get.updateLocale(locale);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController qidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? deviceToken;
  Register reg = Register();
  String? deviceType;
  // String? token;
  bool isLoading = false;

  bool isButtonClicked = true;
  bool isButtonClickedArabic = false;
  bool _obscureText = true;
  var qidErr;
  bool validated = false;
  String errorText = '';
  String passwordErrorText = '';

  @override
  void initState() {
    super.initState();
    qidController.addListener(_validateInput);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: isLoading
            ? Center(
                child: LoaderWidget(),
              )
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      // height:, // Set height to take the entire screen
                      height: 790,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          alignment: Alignment
                              .bottomCenter, // Align the image to the bottom center // Replace with your image path
                          fit: BoxFit
                              .contain, // Adjust to your needs (e.g., BoxFit.fill, BoxFit.fitHeight)
                        ),
                      ),
                      child: Padding(
                        // padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Set to MainAxisSize.min
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset(
                                    "assets/images/logo-welcome-screen.png",
                                    width: 60.0,
                                    height: 60.0,
                                    // fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: isButtonClicked
                                              ? ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(appbar),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: appbar),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          onPressed: () async {
                                            setState(() {
                                              // Toggle the state to change the button style
                                              isButtonClicked = true;
                                              isButtonClickedArabic = false;
                                            });
                                            // print('token before calling api $token');
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            pref.setString("langEn", "English");
                                            var lan = pref
                                                .getString("langEn")
                                                .toString();
                                            print("jjjjjjjjjjjjjjj" + lan);
                                            updateLanguageLogin(
                                                locale[0]['locale']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                6.0, 3.0, 6.0, 3.0),
                                            child: isButtonClicked
                                                ? const Text(
                                                    'English',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: textcolor,
                                                    ),
                                                  )
                                                : const Text(
                                                    'English',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: appbar,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: isButtonClickedArabic
                                              ? ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(appbar),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    const RoundedRectangleBorder(
                                                      // borderRadius: BorderRadius.only(
                                                      //   bottomLeft: Radius.circular(20.0),
                                                      // ),
                                                      side: BorderSide(
                                                          color: appbar),
                                                    ),
                                                  ),
                                                ),
                                          onPressed: () async {
                                            setState(() {
                                              // Toggle the state to change the button style
                                              isButtonClicked = false;
                                              isButtonClickedArabic = true;
                                            });
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            pref.setString("langAR", "Arabic");
                                            var lan = pref
                                                .getString("langAR")
                                                .toString();
                                            print("jjjjjjjjjjjjjjj" + lan);
                                            updateLanguageLogin(
                                                locale[1]['locale']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                6.0, 3.0, 6.0, 3.0),
                                            child: isButtonClickedArabic
                                                ? const Text(
                                                    'عربي',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: textcolor,
                                                    ),
                                                  )
                                                : const Text(
                                                    'عربي',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: appbar,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  SingleChildScrollView(
                                    // physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            'login'.tr,
                                            style: TextStyle(
                                                color: appbar,
                                                fontFamily: 'Impact',
                                                fontSize: 24),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        _buildRoundedBorderTextField(
                                          labelText: 'qid'.tr + '*',
                                          labelTextColor: const Color.fromARGB(
                                              255, 173, 173, 173),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              print('Checking Lang' +
                                                  'pleaseEnterValidQatarID'.tr);
                                              validated = !validated;
                                              return 'pleaseEnterValidQatarID'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                          // controller: qidController,
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        _buildRoundedBorderPWDField(
                                          labelText: 'password'.tr + '*',

                                          labelTextColor: const Color.fromARGB(
                                              255, 173, 173, 173),
                                          validator: (value) {
                                            print('Print error !!!!!!!!!!!!' +
                                                value!);
                                            if (value!.isEmpty) {
                                              print(
                                                  'Print error !!!!!!!!!!!!33333333333333333333333333' +
                                                      value);
                                              setState(() {
                                                passwordErrorText =
                                                    'thePasswordCannotBeEmpty'
                                                        .tr;
                                              });
                                              return passwordErrorText;
                                            }

                                            return null;
                                          },

                                          controller: passwordController,
                                          isPassword:
                                              true, // Set isPassword to true for the password field
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Container(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(primaryColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              // print('token before calling api $token');
                                              String deviceToken =
                                                  getDeviceId().toString();
                                              // String deviceToken = 'qwd';
                                              String deviceType =
                                                  getDeviceType().toString();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isLoading =
                                                      true; // Set loading to true when button is pressed
                                                });
                                                await LoginApi.login(
                                                  context,
                                                  qidController.text,
                                                  passwordController.text,
                                                  deviceToken,
                                                  deviceType,
                                                  onApiComplete: () {
                                                    setState(() {
                                                      isLoading =
                                                          false; // Set loading to false when API call is complete
                                                    });
                                                  },
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 8.0, 10.0, 8.0),
                                              child: Text(
                                                'login'.tr,
                                                style: TextStyle(
                                                  color: textcolor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ForgotPassword()),
                                                );
                                              },
                                              child: Text(
                                                'forgotPassword'.tr,
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const loginOrReg()),
                                                );
                                              },
                                              child: Text(
                                                'create/activateAcc'.tr,
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildRoundedBorderPWDField({
    bool obscureText = false,
    bool isPassword =
        false, // Add this parameter to identify the password field
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType,
    required TextEditingController controller,
  }) {
    return TextFormField(
      obscureText: _obscureText, // Set obscureText to true for password fields
      // obscuringCharacter: "*",
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            !_obscureText ? Icons.visibility_off : Icons.visibility,
            color: Color.fromARGB(255, 173, 173, 173),
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        prefixIcon: Container(
          height: 10.0,
          width: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              "assets/images/lock.png",
              width: 15.0,
              height: 15.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        labelStyle: TextStyle(color: labelTextColor, fontSize: 12),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      validator: validator,
      controller: passwordController,
    );
  }

  void _validateInput() {
    setState(() {
      if (qidController.text.isEmpty) {
        errorText = '';
      } else if (!RegExp(r'^[0-9]*$').hasMatch(qidController.text)) {
        errorText = 'pleaseEnterValidQatarID'.tr;
      } else {
        errorText = '';
      }
    });
  }

  Widget _buildRoundedBorderTextField({
    validationKey = 'pleaseEnterValidQatarID',
    bool isPassword =
        false, // Add this parameter to identify the password field
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: qidController,
      // obscureText: _obscureText, // Set obscureText to true for password fields
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        prefixIcon: Container(
          height: 5,
          width: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              "assets/images/id-card.png",
              // width: 15.0,
              // height: 15.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        labelStyle: TextStyle(color: labelTextColor, fontSize: 12),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> prepareAndPrintJson() async {
    String? qid = qidController.text;
    String? password = passwordController.text;

    // ignore: unused_local_variable
    Map<String, dynamic> jsonPayload = {
      'QID': qid,
      'Password': password,
    };
  }

  String getValidationMessage(String Key) {
    // Add logic to retrieve the validation messages based on the selected language
    // You can use the GetX translation system or any other localization approach here
    return Key;
  }
}
