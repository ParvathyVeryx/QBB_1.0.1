import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/screens/api/check_qid.dart';
import 'package:QBB/screens/api/register_api.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterUser extends StatefulWidget {
  final bool? isSelf;
  final String? behalfFname;
  final String? behalfLname;
  final String registrationMode;
  const RegisterUser(
      {super.key,
      this.isSelf,
      this.behalfFname,
      this.behalfLname,
      required this.registrationMode});

  @override
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
  bool? isSelf;
  String? behalfLname;
  String? behalfFname;
  bool isLoading = false;
  String? token; // Define the 'token' variable here
  String? registrationMode;
  final TextEditingController _qidController = TextEditingController();
  late Future<bool> _qidExistence;
  TextEditingController nationalityController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController otherSource = TextEditingController();
  final TextEditingController otherCampaign = TextEditingController();

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
  // final List<Map<String, dynamic>> sourceItems = [
  //   {'display': 'family'.tr, 'value': 1, "IscampaignEnabled": "True"},
  //   {'display': 'friends'.tr, 'value': 2, "IscampaignEnabled": "False"},
  //   {'display': 'newspaper'.tr, 'value': 3, "IscampaignEnabled": "True"},
  //   {'display': 'qatarFoundation'.tr, 'value': 4, "IscampaignEnabled": "True"},
  //   {'display': 'socialMedia'.tr, 'value': 5, "IscampaignEnabled": "True"},
  //   {'display': 'website'.tr, 'value': 6, "IscampaignEnabled": "True"},
  //   {'display': 'Fahad Test', 'value': 7, "IscampaignEnabled": "True"},
  //   {'display': 'Covid 90', 'value': 8, "IscampaignEnabled": "True"},
  //   {'display': 'Rafiq', 'value': 9, "IscampaignEnabled": "True"},
  //   {'display': 'Just Testing', 'value': 10, "IscampaignEnabled": "True"},
  //   {'display': 'UAT QA', 'value': 11, "IscampaignEnabled": "False"},
  //   {'display': 'other'.tr, 'value': 12, "IscampaignEnabled": "False"},
  // ];

  // Define  items with integer values
  // final List<Map<String, dynamic>> campaignItems = [
  //   {'display': 'toBeConfirmed'.tr, 'value': 1},
  //   {'display': 'Test', 'value': 2},
  //   {'display': 'Test Fahad Campaign', 'value': 3},
  //   {'display': 'Test campaign', 'value': 4},
  //   {'display': 'Ahana Campaign', 'value': 5},
  //   {'display': 'Covid', 'value': 6},
  //   {'display': 'New Year', 'value': 7},
  //   {'display': 'Qatar National Day', 'value': 8},
  //   {'display': 'Just Test', 'value': 9},
  //   {'display': 'other'.tr, 'value': 10},
  // ];
  List<Map<String, dynamic>> sourceItems = [];
  List<Map<String, dynamic>> sourceItemOther = [
    {'Id': 100, 'Name': 'Other', 'IscampaignEnabled': 'False'}
  ];
  List<Map<String, dynamic>> campaignItems = [];
  List<Map<String, dynamic>> campaignItemsOther = [];
  String? _qidError;
  int? maritalId; // Added maritalId to store the mapped value
  var gender;
  String? genderId; // Default value for Gender
  String? maritalStatus; // Default value for Marital Status
  // String registrationMode = 'Self'; // Default value for Registration Mode
  DateTime? selectedDate; // Set initially to null
  Register reg = Register();
  String? storedToken;
  bool _qidExists = false;
  int? _sourceController;
  int? _campaignController;
  String? _selectedLivingPeriod;
  String? nullValue;
  int? updatedNationalityId;
  String errorText = '';
  String? campaignList;

  Future<List<Map<String, dynamic>>> fetchSource() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String qid = pref.getString("userQID").toString();

    try {
      // Get the token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          ''; // Replace 'auth_token' with your actual key

      // Check if the token is available
      if (token.isEmpty) {
        return [];
      }

      // Construct the request URL
      String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/QBBStudySourceAPI?id=1&language=$lang';

      // Make the GET request with the token in the headers
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );

      print(response.body);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and handle the response body
        var responseBody = json.decode(response.body);
        setState(() {
          sourceItems = List<Map<String, dynamic>>.from(responseBody);
          sourceItems.addAll(sourceItemOther);
        });

        print(sourceItems);
        return sourceItems;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  Future<List<Map<String, dynamic>>> fetchCampaignList(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String qid = pref.getString("userQID").toString();
    campaignItemsOther = [
      {'Id': 101, 'StudySourceId': id, 'Name': 'Other'}
    ];
    try {
      // Get the token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          ''; // Replace 'auth_token' with your actual key

      // Check if the token is available
      if (token.isEmpty) {
        return [];
      }

      // Construct the request URL
      String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/QBBCampaignAPI?id=$id&language=$lang';

      // Make the GET request with the token in the headers
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );

      print(response.body);

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and handle the response body
        var responseBody = json.decode(response.body);
        setState(() {
          campaignItems = List<Map<String, dynamic>>.from(responseBody);
          campaignItems.addAll(campaignItemsOther);
        });

        print(campaignItems);
        return campaignItems;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  int id = 43;
  @override
  void initState() {
    super.initState();
    // Call a function to retrieve the token from shared preferences
    _retrieveToken();
    _qidController.addListener(_validateInput);
    fetchSource();
    fetchCampaignList(id);
  }

  void _validateInput() {
    setState(() {
      if (_qidController.text.isEmpty) {
        errorText = '';
      } else if (!RegExp(r'^[0-9]*$').hasMatch(_qidController.text)) {
        errorText = 'pleaseEnterValidQatarID'.tr;
      } else {
        errorText = '';
      }
    });
  }

  Future<void> _retrieveToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token').toString();
      // Rest of the code...
    } catch (e) {}
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
            padding: const EdgeInsets.only(right: 40.0),
            child: Text(
              'register'.tr,
              style: const TextStyle(
                  color: appbar, fontFamily: 'Impact', fontSize: 16),
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
                        keyboardType: TextInputType.number,
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
                              return 'pleaseEnterLName'.tr;
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
                          print("Selected gender: $value");
                          setState(() {
                            gender = value;
                            switch (value) {
                              case 'Male':
                                genderId = "1";
                                break;
                              case 'Female':
                                genderId = "2";
                                break;
                            }
                            print("Updated genderId: $genderId");
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
                        value: maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            maritalStatus = value!;
                            switch (maritalStatus) {
                              case 'Single':
                                maritalId = 2;
                                break;
                              case 'Married':
                                maritalId = 1;
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
                            style: const TextStyle(
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
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          _buildDropdownFormField(
                            value: campaignList,
                            onChanged: (value) {
                              setState(() {
                                // Handle the selected value as needed
                                int? intValue = sourceItems.firstWhere(
                                    (item) => item['Name'] == value)['Id'];

                                // Pass intValue to the API or use it as needed
                                _sourceController = intValue;
                                fetchCampaignList(intValue);
                              });
                            },
                            items: sourceItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['Name'],
                                child: Text(item['Name']),
                                
                              );
                            }).toList(),
                            labelText: 'newspaper'.tr + '*',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      if (_shouldShowOtherSource())
                        _buildRoundedBorderTextField(
                          labelText: 'otherPleaseSpecify'.tr + '*',
                          labelTextColor:
                              const Color.fromARGB(255, 173, 173, 173),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'otherPleaseSpecify'.tr;
                            }
                            return null;
                          },
                          controller:
                              otherSource, // Add this line to associate the controller
                        ),
                      // Dropdown 2
                      if (_shouldShowCampaignDropdown())
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'campaigns'.tr,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            _buildDropdownFormField(
                              value: campaignList,
                              onChanged: (value) {
                                setState(() {
                                  // Handle the selected value as needed
                                  int? intValue = campaignItems.firstWhere(
                                      (item) => item['Name'] == value)['Id'];
                                  // Pass intValue to the API or use it as needed
                                  _campaignController = intValue;
                                });
                              },
                              items: campaignItems.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['Name'],
                                  child: Text(item['Name']),
                                );
                              }).toList(),
                              labelText: 'selectCampaigns'.tr,
                            ),
                          ],
                        ),
                      const SizedBox(height: 20.0),
                      if (_shouldShowOtherCampaign())
                        _buildRoundedBorderTextField(
                          labelText: 'otherPleaseSpecify'.tr + '*',
                          labelTextColor:
                              const Color.fromARGB(255, 173, 173, 173),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'otherPleaseSpecify'.tr;
                            }
                            return null;
                          },
                          controller:
                              otherCampaign, // Add this line to associate the controller
                        ),

                      

                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              _qidController.clear();
                              _firstNameController.clear();
                              _lastNameController.clear();
                              _middleNameController.clear();
                              _emailController.clear();
                              _dateTimeController.clear();
                              otherCampaign.clear();
                              otherSource.clear();
                              _healthCardController.clear();
                              nationalityController.clear();
                              _mobileNumberController.clear();
                              setState(() {
                                maritalStatus = nullValue;
                                _selectedLivingPeriod = nullValue;
                                gender = nullValue;
                                campaignList = nullValue;
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        textcolor), // Set background color
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          secondaryColor, // Replace with your desired border color
                                      width:
                                          1.0, // Replace with your desired border width
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          20.0), // Rounded border at bottom-left
                                    ),
                                  ),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 0, 30.0, 0),
                              child: Text(
                                'clear'.tr,
                                style: const TextStyle(
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          ElevatedButton(
                            onPressed: () async {
                              if (token != null &&
                                  _formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading =
                                      true; // Set loading to true when button is pressed
                                });
                                // Create an instance of Register and populate its fields
                                Register reg = Register(
                                    // qid: int.tryParse(_qidController.text),
                                    qid: _qidController.text,
                                    firstName: _firstNameController.text,
                                    middleName: _middleNameController.text,
                                    lastName: _lastNameController.text,
                                    healthCardNo: _healthCardController.text,
                                    nationalityId: updatedNationalityId,
                                    recoveryMobile:
                                        _mobileNumberController.text,
                                    dob: selectedDate != null
                                        ? dateFormat.format(selectedDate!)
                                        : null,
                                    gender: genderId,
                                    maritalId: maritalId,
                                    recoverEmail: _emailController.text,
                                    livingPeriodId: _selectedLivingPeriod,
                                    registrationSourceID: _sourceController,
                                    campain: _campaignController,
                                    isSelfRegistred: widget.isSelf.toString(),
                                    referralPersonFirstName: widget.behalfFname,
                                    referralPersonLastName: widget.behalfLname);

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

                                // Add more debug statements as needed
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 0, 30.0, 0),
                              child: Text(
                                'tutorialContinueButton'.tr,
                                style: const TextStyle(
                                  color: textcolor,
                                ),
                              ),
                            ),
                          ),
                        ],
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
        item['Id'] == _sourceController && item['IscampaignEnabled'] == 'True');
  }

  bool _shouldShowOtherSource() {
    // Check if the selected value from the source dropdown has IscampaignEnabled set to True
    return sourceItems.any(
        (item) => item['Id'] == _sourceController && item['Name'] == 'Other');
  }

  bool _shouldShowOtherCampaign() {
    // Check if the selected value from the source dropdown has IscampaignEnabled set to True
    return campaignItems.any(
        (item) => item['Id'] == _campaignController && item['Name'] == 'Other');
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
            if (selectedDate == null) {
              return 'pleaseSelectaValue'.tr; // Validation error message
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
            errorStyle: const TextStyle(
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
                    _qidError = 'validQid'.tr;
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
                _qidError = 'validQid'.tr;
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
        errorStyle: const TextStyle(
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
