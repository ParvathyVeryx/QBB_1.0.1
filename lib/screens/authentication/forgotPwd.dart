import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/forget_password_getotp.dart';
import 'package:QBB/nirmal_api.dart/update_password.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String password = ''; // Store the entered password
  String confirmPassword = ''; // Store the entered confirm password
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  bool isPasswordValid = false;
  String errorText = '';
  String errorPwd = '';
  final TextEditingController _controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
    passwordController.addListener(_validatePwd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 179, 179, 179),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text(
              'forgotPasswordTitle'.tr,
              style: TextStyle(
                color: appbar,
                fontFamily: 'Impact',
              ),
            ),
          ),
        ),
        backgroundColor: textcolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRoundedBorderTextField(
                  labelText: 'qid'.tr,
                  labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your QID';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Print the entered QID for debugging
                        print('Entered QID: ${_controller.text}');

                        // Call the API function to get OTP
                        String enteredQID = _controller.text.trim();

                        try {
                          Map<String, dynamic> result =
                              await callUpdatePasswordAPI(enteredQID, context);

                          // Handle the result as needed
                          // For example, you can print the OTP
                          print('OTP: ${result['OTP']}');

                          // Update the UI or perform other actions based on the result
                        } catch (e) {
                          // Handle errors, for example, show an error message
                          print('Error fetching OTP: $e');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                        child: Text(
                          'getOTP'.tr,
                          style: TextStyle(
                            color: textcolor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                _buildRoundedBorderOTPField(
                  labelText: 'enterOTP'.tr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'pleaseEnterOtp'.tr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                ),
                const SizedBox(height: 20.0),
                _buildPasswordField(),
                const SizedBox(height: 20.0),
                _buildConfirmPasswordField(),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            // Print values before calling the API function
                            print('QID: $QID');
                            print('OTP: $otp');
                            print('Password: $password');

                            // Call the API function with QID, OTP, and password
                            try {
                              Map<String, dynamic> result =
                                  await UpdatePasswordAPI(
                                QID,
                                otp,
                                password,
                                context,
                              );

                              // Handle the result as needed
                              // For example, you can print the API response
                              print('API Response: $result');

                              // Check if the API call was successful
                              if (result.containsKey('statusCode') &&
                                  result['statusCode'] == 200) {
                                // API call successful, handle accordingly
                              } else {
                                // API call failed, display the error on the screen
                                String errorMessage = result['message'] ??
                                    'Failed to update password';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $errorMessage'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle errors, for example, show an error message
                              print('Error calling API: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      : null,
                  style: isButtonEnabled
                      ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              primaryColor), // Set background color
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    20.0), // Rounded border at bottom-left
                              ),
                            ),
                          ))
                      : ButtonStyle(
                          // Set background color
                          backgroundColor: MaterialStateProperty.all<Color>(
                              primaryColor
                                  .withOpacity(0.6)), // Set background color
                          // Set overlay color when disabled
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    20.0), // Rounded border at bottom-left
                              ),
                            ),
                          ),
                        ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                    child: Text(
                      'submit'.tr,
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
      ),
    );
  }

  void _validateInput() {
    setState(() {
      if (_controller.text.isEmpty) {
        errorText = '';
      } else if (!RegExp(r'^[0-9]*$').hasMatch(_controller.text)) {
        errorText = 'pleaseEnterValidQatarID'.tr;
      } else {
        errorText = '';
      }
    });
  }

  void _validatePwd() {
    setState(() {
      if (passwordController.text.isEmpty) {
        errorPwd = '';
      } else if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*\d)(?=.*[A-Z]).*$')
          .hasMatch(passwordController.text)) {
        errorPwd =
            'passwordsMustBeAtLeast8CharactersAndContainAt3Of4OfTheFollowingUpperCaseAZLowerCaseAAnumber09AndSpecialCharacterEG'
                .tr;
      } else {
        errorPwd = '';
      }
    });
  }

  Widget _buildRoundedBorderTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      // ],
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: const Icon(
          Icons.card_membership_outlined,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        labelStyle:
            TextStyle(color: labelTextColor), // Set the label text color
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
      onChanged: (value) {
        setState(() {
          QID = value.trim(); // Trim to remove leading/trailing whitespaces
          // Enable or disable the button based on whether the OTP field is empty or not
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: validator,
    );
  }

  Widget _buildRoundedBorderOTPField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: const Icon(
          Icons.phone_android,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        labelStyle:
            TextStyle(color: labelTextColor), // Set the label text color
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
      onChanged: (value) {
        setState(() {
          otp = value;
          // Enable or disable the button based on whether the OTP field is empty or not
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        errorText: errorPwd,
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'newPassword'.tr + '*',
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 173, 173), // Label text color
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
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
      obscureText: true,
      // Hide the entered text
      onChanged: (value) {
        setState(() {
          password = value;
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'pleaseEnterYourPwd'.tr; // Validation error message
        }
        return null; // No error
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'confirmPassword'.tr + '*',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 173, 173), // Label text color
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
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
      obscureText: true, // Hide the entered text
      onChanged: (value) {
        setState(() {
          confirmPassword = value;
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password'; // Validation error message
        } else if (value != password) {
          return 'Passwords do not match'; // Validation error message for mismatch
        }
        return null; // No error
      },
    );
  }
}
