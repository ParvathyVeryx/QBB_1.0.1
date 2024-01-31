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
  int? maritalId;

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
                _buildRoundedBorderTextField(
                          labelText: '${'emailAddress'.tr}*',
                          labelTextColor:
                              const Color.fromARGB(255, 173, 173, 173),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseEnterAValidEmailId'.tr;
                            } // Email validation regular expression
                            RegExp emailRegex = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

                            if (!emailRegex.hasMatch(value)) {
                              return 'pleaseEnterAValidEmailId'.tr;
                            }
                            return null;
                          },
                          controller: _emailController),
                const SizedBox(
                  height: 20.0,
                ),
                _buildDropdownFormField(
                  value: null,
                  onChanged: (value) {
                    setState(() {
                      maritalStatus = value!;
                      switch (maritalStatus) {
                        case 'Single':
                          maritalId = 1;
                          break;
                        case 'Married':
                          maritalId = 2;
                          break;
                        case 'Divorced':
                          maritalId = 3;
                          break;
                        case 'Widowed':
                          maritalId = 4;
                          break;
                        default:
                          maritalId = null;
                          break;
                      }
                    });
                  },
                  items: ['forsfemale', 'married', 'divorced', 'widowed']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value.tr,
                      child: Text(value.tr),
                    );
                  }).toList(),
                  labelText: '${'maritalStatus'.tr}*',
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // if (isButtonEnabled) {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      String userEmail = _emailController.text;
                      int userMaritalId = int.parse(maritalStatusId ?? '1');
                      callUserProfileAPI(context, userEmail, userMaritalId);
                    } else {}
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('No changes to save.'),
                    //       duration: Duration(seconds: 2),
                    //     ),
                    //   );
                    // }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColor),
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

  // Widget _buildRoundedBorderTextField({
  //   required String labelText,
  //   required FormFieldValidator<String> validator,
  //   Color? labelTextColor,
  //   required TextEditingController controller,
  //   TextInputType? keyboardType,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
  //       labelText: labelText,
  //       prefixIcon: Container(
  //         height: 5,
  //         width: 5,
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Image.asset(
  //             "assets/images/id-card.png",
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //       labelStyle: TextStyle(color: labelTextColor),
  //       enabledBorder: const OutlineInputBorder(
  //         borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
  //         borderRadius: BorderRadius.only(
  //           bottomLeft: Radius.circular(20.0),
  //         ),
  //       ),
  //       focusedBorder: const OutlineInputBorder(
  //         borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
  //         borderRadius: BorderRadius.only(
  //           bottomLeft: Radius.circular(20.0),
  //         ),
  //       ),
  //     ),
  //     onChanged: (value) {
  //       setState(() {
  //         _emailValidationMessage = validator(value);
  //       });

  //       setState(() {
  //         QID = value;
  //         isButtonEnabled = QID.isNotEmpty &&
  //             otp.isNotEmpty &&
  //             password.isNotEmpty &&
  //             confirmPassword.isNotEmpty;
  //       });
  //     },
  //     validator: validator,
  //   );
  // }

  // Widget _buildRoundedBorderTextField({
  //   required String labelText,
  //   required FormFieldValidator<String> validator,
  //   Color? labelTextColor,
  //   required TextEditingController controller,
  //   TextInputType? keyboardType,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
  //       labelText: labelText,
  //       prefixIcon: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Container(
  //           width: 5,
  //           height: 5,
  //           child: Image.asset(
  //             "assets/images/id-card.png",
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //       labelStyle: TextStyle(color: labelTextColor),
  //       enabledBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
  //         borderRadius: const BorderRadius.only(
  //           bottomLeft: Radius.circular(20.0),
  //         ),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
  //         borderRadius: const BorderRadius.only(
  //           bottomLeft: Radius.circular(20.0),
  //         ),
  //       ),
  //     ),
  //     keyboardType: keyboardType ?? TextInputType.text,
  //     validator: validator,
  //   );
  // }

  // ... Existing code ...

//   Widget _buildDropdownFormField({
//     required String? value,
//     required void Function(String?)? onChanged,
//     required List<DropdownMenuItem<String>> items,
//     required String labelText,
//     String? defaultValue,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: const Color.fromARGB(255, 173, 173, 173),
//           width: 1.0,
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(20.0),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
//         child: DropdownButtonFormField<String>(
//           value: value ?? defaultValue,
//           onChanged: onChanged,
//           items: items,
//           decoration: InputDecoration(
//             labelText: labelText,
//             labelStyle: const TextStyle(
//               color: Color.fromARGB(255, 173, 173, 173),
//             ),
//             border: InputBorder.none,
//           ),
//           validator: (value) {
//             return null;
//           },
//         ),
//       ),
//     );
//   }
// }

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
            errorStyle: const TextStyle(
              // Add your style properties here
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
            labelText: labelText,
            labelStyle: const TextStyle(
                color: Color.fromARGB(255, 173, 173, 173), fontSize: 12),
            // Set the label text color

            // Label text color
            border: InputBorder.none, // Remove the default border
          ),
          validator: (value) {
            return null; // No error
          },
        ),
      ),
    );
  }
}

  Widget _buildRoundedBorderTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller, // Set the controller
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        errorStyle: const TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        labelStyle: TextStyle(
            color: labelTextColor, fontSize: 12), // Set the label text color
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

