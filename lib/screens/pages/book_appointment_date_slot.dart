import 'package:QBB/nirmal_api.dart/Booking_get_slots.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentBookingPage extends StatefulWidget {
  final ApiResponse apiResponse;

  const AppointmentBookingPage({Key? key, required this.apiResponse})
      : super(key: key);

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  String _selectedTimeSlot = '10:00 AM'; // Default time slot
  List<String> availableTimeSlots = [];
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void printApiResponse() {
      print('Api in slot : ${widget.apiResponse}');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book an Appointment',
          style: TextStyle(fontFamily: 'impact', color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                  _dateController.text =
                      '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}';
                });
              },
            ),
            const Center(
              child: Text(
                'Available Time Slot:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: DropdownButton<String>(
                value: _selectedTimeSlot,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _selectTimeSlot(newValue);
                  }
                },
                items: availableTimeSlots.map((String timeSlot) {
                  return DropdownMenuItem<String>(
                    value: timeSlot,
                    child: Center(
                      child: Text(timeSlot),
                    ),
                  );
                }).toList(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                underline: Container(),
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.deepPurple),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                      ),
                      onPressed: _confirmAppointment,
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
        // TODO: Fetch available time slots for the selected date from the API
        // Replace the following line with the actual logic to get time slots
        availableTimeSlots = ['05:00 PM-06:00 PM'];
      });
    }
  }

  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  void _confirmAppointment() {
    // Implement appointment confirmation logic here
    print('Appointment confirmed for $_selectedDate at $_selectedTimeSlot');
    // You can navigate to another screen, show a confirmation dialog, etc.
  }
}
import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  String _selectedTimeSlot = '10:00 AM';
  List<String> availableTimeSlots = [];
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  List<String> availableDates = [];
  List<String> nextAvailableDates = [];

  @override
  void initState() {
    super.initState();
    fetchApiResponseFromSharedPrefs();
  }

  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        availableDates = List<String>.from(jsonResponse['datelist']);
        nextAvailableDates =
            List<String>.from(jsonResponse['nextAvilableDateList']);
        print(availableDates);
        print(nextAvailableDates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book an Appointment',
          style: TextStyle(fontFamily: 'impact', color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const SwipableDateRow(),
            const SizedBox(height: 10.0),
            const SizedBox(height: 30.0),
            const Center(
              child: Text('Swipe right to view more slots'),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(height: 200, child: SwipableFourColumnWidget()),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.deepPurple),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                      ),
                      onPressed: _confirmAppointment,
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
        availableTimeSlots = ['05:00 PM-06:00 PM'];
      });
    }
  }

  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  void _confirmAppointment() {
    print('Appointment confirmed for $_selectedDate at $_selectedTimeSlot');
  }
}

class SwipableDateRow extends StatefulWidget {
  const SwipableDateRow({Key? key}) : super(key: key);

  @override
  _SwipableDateRowState createState() => _SwipableDateRowState();
}

class _SwipableDateRowState extends State<SwipableDateRow> {
  late PageController _pageController;
  late List<String> availableDates;
  late List<String> nextAvailableDates;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    availableDates = [];
    nextAvailableDates = [];
    fetchApiResponseFromSharedPrefs();
  }

  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        availableDates = List<String>.from(jsonResponse['datelist']);
        nextAvailableDates =
            List<String>.from(jsonResponse['nextAvilableDateList']);
        print(availableDates);
        print(nextAvailableDates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  moveToAvailableDates();
                },
                icon: const Icon(Icons.arrow_back),
                color: appbar,
              ),
              const Center(
                child: Text(
                  'Next Available Dates',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () {
                  moveToNextAvailableDates();
                },
                icon: const Icon(Icons.arrow_forward),
                color: appbar,
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Center(
            child: Text(
              'Swipe right to view more details',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 80.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: availableDates.length + nextAvailableDates.length,
              itemBuilder: (context, index) {
                String date = index < availableDates.length
                    ? availableDates[index]
                    : nextAvailableDates[index - availableDates.length];

                return Container(
                  width: 100.0, // Adjust the width as needed
                  height: 80.0, // Adjust the height as needed
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void moveToNextAvailableDates() {
    _pageController.jumpToPage(availableDates.length);
  }

  void moveToAvailableDates() {
    _pageController.jumpToPage(0);
  }
}

class SwipableFourColumnWidget extends StatefulWidget {
  SwipableFourColumnWidget({Key? key}) : super(key: key);

  @override
  State<SwipableFourColumnWidget> createState() =>
      _SwipableFourColumnWidgetState();
}

class _SwipableFourColumnWidgetState extends State<SwipableFourColumnWidget> {
  final List<String> daysAndDates = [
    'Monday, 10 Jan',
    'Tuesday, 11 Jan',
    'Wednesday, 12 Jan',
  ];

  final List<String> availabilityStatus = [
    'Available',
    'Not Available',
    'Available',
  ];

  late List<String> timeList;

  // late List<String> nextAvailableDates;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController();
    timeList = [];
    // nextAvailableDates = [];
    fetchApiResponseFromSharedPrefs();
  }

  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        timeList = List<String>.from(jsonResponse['timelist']);
        // nextAvailableDates =
        //     List<String>.from(jsonResponse['nextAvilableDateList']);
        // print(availab / eDates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Time Slot',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                timeList.first,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: PageView.builder(
              itemCount: daysAndDates.length,
              itemBuilder: (context, pageIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      daysAndDates[pageIndex],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: availabilityStatus[pageIndex] == 'Available'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
