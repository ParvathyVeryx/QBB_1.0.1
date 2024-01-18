import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/profile_api.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_gen/gen_l10n/app-localizations.dart';

class EditUser extends StatefulWidget {
  final String email; // Add this line

  const EditUser({required this.email, super.key});

  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _emailValidationMessage;

  String password = ''; // Store the entered password
  String confirmPassword = ''; // Store the entered confirm password
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  String? maritalStatus = "Single"; // Default value for Marital Status
// Define maritalStatusId in your state class
  String? maritalStatusId;
  bool isLoading = false;
  // Declare a TextEditingController for the email field
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text(
              'Edit Profile',
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
                  labelText: 'Email',
                  labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                  validator: (value) {
                    if (value!.isEmpty) {
                      _setEmailValidationMessage('Please enter your email');
                      return 'Please enter your email';
                    } else if (!isValidEmail(value)) {
                      _setEmailValidationMessage('Invalid email format');
                      return 'Invalid email format';
                    } else {
                      _setEmailValidationMessage(null);
                      return null;
                    }
                  },
                  controller: _emailController,
                ),
                if (_emailValidationMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _emailValidationMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                _buildDropdownFormField(
                  value: '1', // Set the default value based on the initial 'id'
                  onChanged: (value) {
                    setState(() {
                      maritalStatusId = value!;
                      print('Selected Marital Status Id: $maritalStatusId');
                      isButtonEnabled = _emailValidationMessage ==
                          null; // Enable the button if email is valid
                    });
                  },
                  items: [
                    {'id': '1', 'label': 'Single'},
                    {'id': '2', 'label': 'Married'},
                    {'id': '3', 'label': 'Divorced'},
                    {'id': '4', 'label': 'Widowed'},
                  ].map((Map<String, String> item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text(item['label']!),
                    );
                  }).toList(),
                  labelText: 'Marital Status*',
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (isButtonEnabled) {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading =
                              true; // Set loading to true when button is pressed
                        });
                        print('Validation passed, executing onPressed block');
                        // Process the form data
                        String userEmail = _emailController.text;
                        int userMaritalId = int.parse(maritalStatusId ??
                            '1'); // Use default value '1' if null
                        callUserProfileAPI(context, userEmail, userMaritalId);
                      } else {
                        print('Validation failed');
                      }
                    } else {
                      // Show a warning to the user that there are no changes
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No changes to save.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          primaryColor), // Set background color
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                20.0), // Rounded border at bottom-left
                          ),
                        ),
                      )),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                    child: Text(
                      'Save',
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

  // void _submitForm() {
  //   print('Submit form called');
  //   // Call your API function with the email and maritalStatus
  //   callUserProfileAPI();
  // }

  void _setEmailValidationMessage(String? message) {
    print('Email Validation Message: $message');
    setState(() {
      _emailValidationMessage = message;
    });
  }

  bool isValidEmail(String value) {
    // Use a regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
    );
    return emailRegex.hasMatch(value);
  }

  Widget _buildRoundedBorderTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    required TextEditingController controller, // Add this line

    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      controller: controller, // Add this line

      decoration: InputDecoration(
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
      ),
      onChanged: (value) {
        setState(() {
          _emailValidationMessage = validator!(value);
        });

        setState(() {
          QID = value;
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
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'Password*',
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
      ),
      obscureText: true, // Hide the entered text
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
          return 'Please enter a password'; // Validation error message
        }
        return null; // No error
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'Confirm Password*',
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

  Widget _buildDropdownFormField(
      {required String? value,
      required void Function(String?)? onChanged,
      required List<DropdownMenuItem<String>> items,
      required String labelText,
      String? defaultValue}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(
              255, 173, 173, 173), // Set the border color to grey
          width: 1.0, // Set the border width
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Rounded border at bottom-left
        ), // Rounded border corners
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: DropdownButtonFormField<String>(
          value: value ?? defaultValue,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
                color: Color.fromARGB(255, 173, 173, 173)), // Label text color
            border: InputBorder.none, // Remove the default border
          ),
          validator: (value) {
            // if (selectedDate == null) {
            //   return 'Please select a value'; // Validation error message
            // }
            return null; // No error
          },
        ),
      ),
    );
  }
}
