import 'package:QBB/constants.dart';
import 'package:QBB/screens/api/check_qid.dart';
import 'package:QBB/screens/api/register_api.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  final String? behalfFname;
  final String? behalfLname;
  final String registrationMode;
  const RegisterUser(
      {super.key,
      this.behalfFname,
      this.behalfLname,
      required this.registrationMode});

  @override
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
  String? behalfLname;
  String? behalfFname;
  bool isLoading = false;
  String? token; // Define the 'token' variable here
  String? registrationMode;
  final TextEditingController _qidController = TextEditingController();
  late Future<bool> _qidExistence;
  TextEditingController nationalityController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _healthCardController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? qidLastTwoDigits;
  // Define source items with integer values
  final List<Map<String, dynamic>> sourceItems = [
    {'display': 'family'.tr, 'value': 1, "IscampaignEnabled": "True"},
    {'display': 'friends'.tr, 'value': 2, "IscampaignEnabled": "False"},
    {'display': 'newspaper'.tr, 'value': 3, "IscampaignEnabled": "True"},
    {'display': 'qatarFoundation'.tr, 'value': 4, "IscampaignEnabled": "True"},
    {'display': 'socialMedia'.tr, 'value': 5, "IscampaignEnabled": "True"},
    {'display': 'website'.tr, 'value': 6, "IscampaignEnabled": "True"},
    {'display': 'Fahad Test', 'value': 7, "IscampaignEnabled": "True"},
    {'display': 'Covid 90', 'value': 8, "IscampaignEnabled": "True"},
    {'display': 'Rafiq', 'value': 9, "IscampaignEnabled": "True"},
    {'display': 'Just Testing', 'value': 10, "IscampaignEnabled": "True"},
    {'display': 'UAT QA', 'value': 11, "IscampaignEnabled": "False"},
    {'display': 'other'.tr, 'value': 12, "IscampaignEnabled": "False"},
  ];

  // Define  items with integer values
  final List<Map<String, dynamic>> campaignItems = [
    {'display': 'toBeConfirmed'.tr, 'value': 1},
    {'display': 'Test', 'value': 2},
    {'display': 'Test Fahad Campaign', 'value': 3},
    {'display': 'Test campaign', 'value': 4},
    {'display': 'Ahana Campaign', 'value': 5},
    {'display': 'Covid', 'value': 6},
    {'display': 'New Year', 'value': 7},
    {'display': 'Qatar National Day', 'value': 8},
    {'display': 'Just Test', 'value': 9},
    {'display': 'other'.tr, 'value': 10},
  ];
  String? _qidError;
  int? maritalId; // Added maritalId to store the mapped value
  var gender;
  int? genderId; // Default value for Gender
  String? maritalStatus; // Default value for Marital Status
  // String registrationMode = 'Self'; // Default value for Registration Mode
  DateTime? selectedDate; // Set initially to null
  Register reg = Register();
  String? storedToken;
  bool _qidExists = false;
  int? _sourceController;
  int? _campaignController;
  String? _selectedLivingPeriod;
  int? updatedNationalityId;
  @override
  void initState() {
    super.initState();
    // Call a function to retrieve the token from shared preferences
    _retrieveToken();

    // Print the received values in the initState method
    print('Received behalfFname: ${widget.behalfFname}');
    print('Received behalfLname: ${widget.behalfLname}');
  }

  Future<void> _retrieveToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token').toString();
      print('Tokrn in other screen $token');
      // Rest of the code...
    } catch (e) {
      print('Error retrieving token: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
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
              'register'.tr,
              style: TextStyle(
                color: appbar,
                fontFamily: 'Impact',
              ),
            ),
          ),
        ),
        backgroundColor: textcolor,
      ),
      body: isLoading
          ? Center(
              child: LoaderWidget(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QIDTextField(
                        controller: _qidController,
                        labelText: 'qid'.tr + '*',
                        labelTextColor:
                            const Color.fromARGB(255, 173, 173, 173),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterYourQID'.tr;
                          }
                          return null;
                        },
                        onChanged: (value) async {
                          if (value.length == 11) {
                            // Extract the last two digits of the entered QID
                            qidLastTwoDigits = value.substring(1, 3);

                            // Use FutureBuilder to handle asynchronous API call
                            await FutureBuilder<bool>(
                              future: checkQIDExist(
                                value,
                                context,
                                nationalityController,
                                (int updatedId) {
                                  updatedNationalityId = updatedId;
                                  // Update the nationalityId in your API call
                                },
                              ),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Show loader while waiting for the API result
                                  return LoaderWidget();
                                } else if (snapshot.hasError) {
                                  // Handle error state
                                  return ErrorPopup(
                                    errorMessage: 'Error: ${snapshot.error}',
                                  );
                                } else {
                                  // Handle success state
                                  bool qidExists = snapshot.data ?? false;
                                  if (qidExists) {
                                    // Set the nationalityId in your Register instance
                                    reg.nationalityId = updatedNationalityId;
                                    // Call the registerUser function with the updated Register instance
                                    // ... your logic here ...
                                  }
                                  // Return an empty container or other UI based on your requirements
                                  return Container();
                                }
                              },
                            );

                            // Update the UI based on the result of the API call
                            setState(() {
                              _qidExists = _qidExists;
                            });
                          }
                        },
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildRoundedBorderTextField(
                        labelText: 'firstName'.tr + '*',
                        labelTextColor:
                            const Color.fromARGB(255, 173, 173, 173),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterFName'.tr;
                          }
                          return null;
                        },
                        controller:
                            _firstNameController, // Add this line to associate the controller
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildRoundedBorderTextFieldNoValidation(
                        labelText: 'middleName'.tr,
                        labelTextColor:
                            const Color.fromARGB(255, 173, 173, 173),
                        controller:
                            _middleNameController, // Add this line to associate the controller
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildRoundedBorderTextField(
                          labelText: 'lastName'.tr + '*',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseEnterFName'.tr;
                            }
                            return null;
                          },
                          labelTextColor:
                              const Color.fromARGB(255, 173, 173, 173),
                          controller: _lastNameController),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildRoundedBorderTextFieldNoValidation(
                          labelText: 'healthCardNo'.tr,
                          labelTextColor:
                              const Color.fromARGB(255, 173, 173, 173),
                          controller: _healthCardController),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildRoundedBorderTextFieldNoValidation(
                        labelText: 'nationality'.tr,
                        labelTextColor:
                            const Color.fromARGB(255, 173, 173, 173),
                        controller: nationalityController,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      _buildRoundedBorderTextField(
                          labelText: 'mobileNumber'.tr + '*',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseEnterMobileNUmber'.tr;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          labelTextColor:
                              const Color.fromARGB(255, 173, 173, 173),
                          controller: _mobileNumberController),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildDateTimeField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildDropdownFormField(
                        value: gender, // Use the gender variable here
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                            switch (gender) {
                              case 'male':
                                genderId = 1;
                                break;
                              case 'female':
                                genderId = 2;
                                break;

                              default:
                                genderId = null;
                                break;
                            }
                          });
                        },
                        items: [
                          'male',
                          'female',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value.tr,
                            child: Text(value.tr),
                          );
                        }).toList(),
                        labelText: 'gender'.tr + '*',
                      ),
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
                      const SizedBox(
                        height: 20.0,
                      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'howLong'.tr,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 10.0),
                          _buildDropdownFormField(
                            value: _selectedLivingPeriod,
                            onChanged: (value) {
                              setState(() {
                                // Handle the selected value as needed
                                _selectedLivingPeriod = value;
                              });
                            },
                            items: [
                              for (int i = 1; i <= 14; i++)
                                DropdownMenuItem<String>(
                                  value: i.toString(),
                                  child: Text('$i' + 'years'.tr),
                                ),
                              const DropdownMenuItem<String>(
                                value: '15',
                                child: Text('15+'),
                              ),
                            ],
                            labelText: '${'duration'.tr}*',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ), // Additional Dropdown 1
                      // Dropdown 1
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'howDidYouComeToKnowAboutQBB'.tr,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          _buildDropdownFormField(
                            value: null,
                            onChanged: (value) {
                              setState(() {
                                // Handle the selected value as needed
                                int? intValue = sourceItems.firstWhere((item) =>
                                    item['display'] == value)['value'];
                                // Pass intValue to the API or use it as needed
                                _sourceController = intValue;
                              });
                            },
                            items: sourceItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['display'],
                                child: Text(item['display']),
                              );
                            }).toList(),
                            labelText: 'newspaper'.tr + '*',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Dropdown 2
                      if (_shouldShowCampaignDropdown())
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'campaigns'.tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            _buildDropdownFormField(
                              value: null,
                              onChanged: (value) {
                                setState(() {
                                  // Handle the selected value as needed
                                  int? intValue = campaignItems.firstWhere(
                                      (item) =>
                                          item['display'] == value)['value'];
                                  // Pass intValue to the API or use it as needed
                                  _campaignController = intValue;
                                });
                              },
                              items: campaignItems.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['display'],
                                  child: Text(item['display']),
                                );
                              }).toList(),
                              labelText: 'selectCampaigns'.tr,
                            ),
                          ],
                        ),

                      const SizedBox(height: 20.0),

                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          print('token before calling api $token');
                          if (token != null &&
                              _formKey.currentState!.validate()) {
                            setState(() {
                              isLoading =
                                  true; // Set loading to true when button is pressed
                            });
                            // Create an instance of Register and populate its fields
                            Register reg = Register(
                                qid: int.tryParse(_qidController.text),
                                firstName: _firstNameController.text,
                                middleName: _middleNameController.text,
                                lastName: _lastNameController.text,
                                healthCardNo: _healthCardController.text,
                                nationalityId: updatedNationalityId,
                                recoveryMobile: _mobileNumberController.text,
                                dob: selectedDate != null
                                    ? dateFormat.format(selectedDate!)
                                    : null,
                                gender: genderId,
                                maritalId: maritalId,
                                recoverEmail: _emailController.text,
                                livingPeriodId: _selectedLivingPeriod,
                                registrationSourceID: _sourceController,
                                campain: _campaignController,
                                isSelfRegistred: registrationMode,
                                referralPersonFirstName: widget.behalfFname,
                                referralPersonLastName: widget.behalfLname);
                            print(widget.behalfFname);
                            print(widget.behalfLname);
                            // Call the API with the populated Register instance
                            await RegisterApi.signup(
                              reg,
                              context,
                              token,
                              onApiComplete: () {
                                setState(() {
                                  isLoading =
                                      false; // Set loading to false when API call is complete
                                });
                              },
                            );

                            // Add debug statements for tracking
                            print('token from form $token');
                            print('QID: ${reg.qid}');
                            print('DOB: ${reg.dob}');
                            // Add more debug statements as needed
                          } else {
                            print(
                                'Token is null. Check token retrieval or storage.');
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                primaryColor), // Set background color
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      20.0), // Rounded border at bottom-left
                                ),
                              ),
                            )),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                          child: Text(
                            'tutorialContinueButton'.tr,
                            style: TextStyle(
                              color: textcolor,
                            ),
                          ),
                        ),
                      ),
                      //copy
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  bool _shouldShowCampaignDropdown() {
    // Check if the selected value from the source dropdown has IscampaignEnabled set to True
    return sourceItems.any((item) =>
        item['value'] == _sourceController &&
        item['IscampaignEnabled'] == 'True');
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
        errorStyle: TextStyle(
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

  Widget _buildRoundedBorderTextFieldNoValidation({
    required String labelText,
    Color? labelTextColor, // Added labelTextColor parameter
    TextEditingController? controller, // Accept the controller parameter
    void Function(String)? onChanged, // Accept the onChanged callback
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        errorStyle: TextStyle(
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
            errorStyle: TextStyle(
              // Add your style properties here
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
            labelText: labelText,
            labelStyle: TextStyle(
                color: const Color.fromARGB(255, 173, 173, 173), fontSize: 12),
            // Set the label text color

            // Label text color
            border: InputBorder.none, // Remove the default border
          ),
          validator: (value) {
            if (selectedDate == null) {
              return 'Please select a value'; // Validation error message
            }
            return null; // No error
          },
        ),
      ),
    );
  }

  Widget _buildRadioListTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: registrationMode,
      onChanged: (newValue) {
        setState(() {
          registrationMode = newValue!;
        });
      },
      activeColor: primaryColor,
    );
  }

//
  Widget _buildDateTimeField() {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    // Variable to hold the label text
    String labelText = '${'selectDate'.tr}*';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning text
        if (_qidError != null)
          Text(
            _qidError!,
            style: const TextStyle(color: primaryColor),
          ),

        TextFormField(
          decoration: InputDecoration(
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            labelText: labelText,
            labelStyle: const TextStyle(
                color: Color.fromARGB(255, 173, 173, 173),
                fontSize: 12 // Label text color
                ),
            errorStyle: TextStyle(
              // Add your style properties here
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(20.0), // Rounded border at bottom-left
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 173, 173, 173),
                width: 1.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Color.fromARGB(255, 173, 173, 173),
              ),
              onPressed: () async {
                // Wait for the user to select a date
                await _selectDate(context);

                // Update the label text using the TextEditingController
                if (selectedDate != null) {
                  _dateTimeController.text = dateFormat.format(selectedDate!);
                }

                // Check if the last two digits of QID match the last two digits of the year
                if (qidLastTwoDigits != null &&
                    selectedDate != null &&
                    qidLastTwoDigits !=
                        selectedDate!.year.toString().substring(2, 4)) {
                  setState(() {
                    // Set an error message or take appropriate action
                    _qidError = 'QID and Date of Birth do not match';
                  });
                  return;
                }

                setState(() {
                  _qidError = null;
                });
              },
            ),
          ),
          readOnly: true,
          onTap: () async {
            // Wait for the user to select a date
            await _selectDate(context);

            // Check if the last two digits of QID match the last two digits of the year
            if (qidLastTwoDigits != null &&
                selectedDate != null &&
                qidLastTwoDigits !=
                    selectedDate!.year.toString().substring(2, 4)) {
              setState(() {
                // Set an error message or take appropriate action
                _qidError = 'QID and Date of Birth do not match';
              });
              return;
            }

            // Update the label text using the TextEditingController
            if (selectedDate != null) {
              _dateTimeController.text = dateFormat.format(selectedDate!);
            }

            setState(() {
              _qidError = null;
            });
          },
          controller: _dateTimeController,
          validator: (value) {
            if (selectedDate == null) {
              return 'pleaseSelectDate'.tr;
            }
            return null;
          },
          onSaved: (value) {
            // You can add saving logic here if needed
          },
        ),
      ],
    );
  }
}

class QIDTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged; // Added onChanged
  final String labelText;
  final FormFieldValidator<String> validator;
  final Color? labelTextColor;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onFieldSubmitted; // Added onFieldSubmitted
  const QIDTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted, // Added onFieldSubmitted
    required this.labelText,
    required this.validator,
    this.labelTextColor,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
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
      keyboardType: keyboardType,
    );
  }
}
