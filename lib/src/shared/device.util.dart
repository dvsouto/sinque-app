// ignore: file_names
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtil {
  static getHostname() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      return androidInfo.host;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;

      return iosInfo.utsname;
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await DeviceInfoPlugin().windowsInfo;

      return windowsInfo.computerName;
    }

    if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await DeviceInfoPlugin().macOsInfo;

      return macInfo.hostName;
    }

    if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await DeviceInfoPlugin().linuxInfo;

      return linuxInfo.machineId;
    }

    return 'unknown';
  }
}
