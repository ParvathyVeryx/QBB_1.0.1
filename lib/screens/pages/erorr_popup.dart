import 'package:QBB/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPopup extends StatelessWidget {
  final String errorMessage;

  const ErrorPopup({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      title: const Text(
        'Alert',
        style: TextStyle(color: primaryColor),
      ),
      content: Text(
        errorMessage,
        style: const TextStyle(color: primaryColor),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child:  Text('ok'.tr),
        ),
      ],
    );
  }
}
