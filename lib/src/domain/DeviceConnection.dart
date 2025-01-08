import 'dart:convert';

import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/Network.dart';
import 'package:sinque/src/shared/network.util.dart';

class DeviceConnection {
  final Device device;
  final Network network;

  int lostPackages = 0;

  DeviceConnection({required this.device, required this.network});

  Map<String, dynamic> toMap() {
    return {
      'device': device.toMap(),
      'network': network.toMap(),
    };
  }

  void ping() {
    lostPackages++;
  }

  void pong() {
    lostPackages = 0;
  }

  bool losted() {
    return lostPackages >= NetworkUtil.maxLostPackages;
  }

  String encode() {
    return jsonEncode(toMap());
  }

  bool equals(DeviceConnection otherDevice) {
    return network.getUuid() == otherDevice.network.getUuid();
  }
}
