import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<void> getDeviceType() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo;
  IosDeviceInfo iosInfo;

  try {
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      print('Device Type: ${androidInfo.model}');
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
      print('Device Type: ${iosInfo.utsname.machine}');
    }
  } catch (e) {
    print('Error getting device type: $e');
  }
}
