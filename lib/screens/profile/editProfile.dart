import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/profile_api.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUser extends StatefulWidget {
  final Future<String> emailFuture;
  const EditUser({required this.emailFuture, Key? key}) : super(key: key);

  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _emailValidationMessage;

  String password = '';
  String confirmPassword = '';
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  String? maritalStatus = "Single";
  String? maritalStatusId;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _emailController.text = widget.email; // Removed this line
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
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text(
              'settingsPageProfile'.tr,
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
                FutureBuilder<String>(
                  future: widget.emailFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      _emailController.text = snapshot.data ?? '';
                      return _buildRoundedBorderTextField(
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
                      );
                    }
                  },
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
                  value: '1',
                  onChanged: (value) {
                    setState(() {
                      maritalStatusId = value!;
                      print('Selected Marital Status Id: $maritalStatusId');
                      isButtonEnabled = _emailValidationMessage == null;
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
                          isLoading = true;
                        });
                        print('Validation passed, executing onPressed block');
                        String userEmail = _emailController.text;
                        int userMaritalId = int.parse(maritalStatusId ?? '1');
                        callUserProfileAPI(context, userEmail, userMaritalId);
                      } else {
                        print('Validation failed');
                      }
                    } else {
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
                          primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
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

  void _setEmailValidationMessage(String? message) {
    print('Email Validation Message: $message');
    setState(() {
      _emailValidationMessage = message;
    });
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
    );
    return emailRegex.hasMatch(value);
  }

  // ... Existing code ...

  Widget _buildRoundedBorderTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: Container(
          height: 5,
          width: 5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              "assets/images/id-card.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        labelStyle: TextStyle(color: labelTextColor),
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
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: validator,
    );
  }

  // ... Existing code ...

  Widget _buildRoundedBorderOTPField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType,
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
        labelStyle: TextStyle(color: labelTextColor),
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
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: validator,
    );
  }

  // ... Existing code ...

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
      obscureText: true,
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
          return 'Please enter a password';
        }
        return null;
      },
    );
  }

  // ... Existing code ...

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'Confirm Password*',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 173, 173),
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
      obscureText: true,
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
          return 'Please confirm your password';
        } else if (value != password) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // ... Existing code ...

  Widget _buildDropdownFormField({
    required String? value,
    required void Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> items,
    required String labelText,
    String? defaultValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 173, 173, 173),
          width: 1.0,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
        ),
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
              color: Color.fromARGB(255, 173, 173, 173),
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            return null;
          },
        ),
      ),
    );
  }
}

