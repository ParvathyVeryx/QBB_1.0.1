import 'package:intl/intl.dart';

String timeExtract(Map<String, dynamic> appointment) {
  // Extract start and end time
  DateTime startTime = DateTime.parse(appointment['StartDate']);
  DateTime endTime = DateTime.parse(appointment['EndDate']);

  // Format the time
  String formattedStartTime = DateFormat('hh:mm a').format(startTime);
  String formattedEndTime = DateFormat('hh:mm a').format(endTime);

  // Return the formatted time
  return '$formattedStartTime - $formattedEndTime';
}

DateTime dateExtract(Map<String, dynamic> appointment) {
  String appointmentDateString = appointment['AppoimentDate'];

  // Parse the string to a DateTime object
  DateTime appointmentDate = DateTime.parse(appointmentDateString);

  // Return the extracted DateTime
  return appointmentDate;
}
