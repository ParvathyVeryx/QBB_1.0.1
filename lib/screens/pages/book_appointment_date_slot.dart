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
