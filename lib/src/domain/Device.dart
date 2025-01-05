import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:sinque/src/shared/enum.util.dart';

class Device {
  final DeviceType _type;
  final DeviceOS _os;

  final String? _name;
  final String? _manufacturer;
  final String? _model;

  Device({
    String? name,
    String? manufacturer,
    String? model,
    required DeviceType type,
    required DeviceOS os,
  })  : _name = name,
        _manufacturer = manufacturer,
        _model = model,
        _type = type,
        _os = os;

  static Future<Device> detect() async {
    String name = 'Unknown';
    String manufacturer = 'Unknown';
    String? model;
    DeviceType type = DeviceType.Unknown;
    DeviceOS os = DeviceOS.Unknown;

    if (Platform.isAndroid) {
      type = DeviceType.Mobile;
      os = DeviceOS.Android;

      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      name = androidInfo.device;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
    }

    if (Platform.isIOS) {
      type = DeviceType.Mobile;
      os = DeviceOS.IOS;

      IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;

      name = iosInfo.name;
      manufacturer = 'Apple';
      model = iosInfo.model;
    }

    if (Platform.isWindows) {
      type = DeviceType.Desktop;
      os = DeviceOS.Windows;

      WindowsDeviceInfo windowsInfo = await DeviceInfoPlugin().windowsInfo;

      name = windowsInfo.computerName;
      manufacturer = 'Microsoft';
      model = null;
    }

    if (Platform.isMacOS) {
      type = DeviceType.Desktop;
      os = DeviceOS.MacOS;

      MacOsDeviceInfo macInfo = await DeviceInfoPlugin().macOsInfo;

      name = macInfo.computerName;
      manufacturer = 'Apple';
      model = macInfo.osRelease;
    }

    if (Platform.isLinux) {
      type = DeviceType.Desktop;
      os = DeviceOS.Linux;

      LinuxDeviceInfo linuxInfo = await DeviceInfoPlugin().linuxInfo;

      name = linuxInfo.prettyName;
      manufacturer = 'Linux';
      model = linuxInfo.variantId;
    }

    return Device(
      name: name,
      manufacturer: manufacturer,
      model: model,
      type: type,
      os: os,
    );
  }

  DeviceType getType() {
    return _type;
  }

  DeviceOS getOs() {
    return _os;
  }

  String? getName() {
    return _name;
  }

  String? getManufacturer() {
    return _manufacturer;
  }

  String? getModel() {
    return _model;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'manufacturer': _manufacturer,
      'model': _model,
      'type': _type.toString(),
      'os': _os.toString(),
    };
  }

  static Device decode(dynamic object) {
    return Device(
      name: object['name'] as String,
      manufacturer: object['manufacturer'],
      model: object['model'],
      type: EnumUtil.namedBy<DeviceType>(DeviceType.values, object['type']),
      os: EnumUtil.namedBy<DeviceOS>(DeviceOS.values, object['os']),
    );
  }
}

// ignore: constant_identifier_names
enum DeviceOS { Android, IOS, Windows, MacOS, Linux, Unknown }

// ignore: constant_identifier_names
enum DeviceType { Mobile, Desktop, Web, Unknown }
