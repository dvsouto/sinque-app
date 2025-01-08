import 'dart:convert';

import 'package:sinque/src/shared/network.util.dart';

class Network {
  final String? _uuid;
  final String _address;
  final String _hostname;
  final String? _macAddress;
  final int _serverPort;

  Network({
    uuid,
    required String address,
    required String hostname,
    String? macAddress,
    required int serverPort,
  })  : _uuid = uuid,
        _address = address,
        _hostname = hostname,
        _macAddress = macAddress,
        _serverPort = serverPort;

  Map<String, dynamic> toMap() {
    return {
      'uuid': _uuid ?? 'unknown',
      'address': _address,
      'hostname': _hostname,
      'mac_address': _macAddress,
      'server_port': _serverPort,
    };
  }

  String encode() {
    return jsonEncode(toMap());
  }

  String? getUuid() {
    return _uuid;
  }

  String getAddress() {
    return _address;
  }

  String getHostname() {
    return _hostname;
  }

  String? getMacAddress() {
    return _macAddress;
  }

  int getServerPort() {
    return _serverPort;
  }

  bool itsMe() {
    return NetworkUtil.retrieveUuidSync() == _uuid;
  }

  static Network decode(dynamic object) {
    final serverPort = object['server_port'];

    return Network(
      uuid: object['uuid'],
      address: object['address'] as String,
      hostname: object['hostname'] as String,
      serverPort:
          (serverPort is String) ? int.parse(serverPort) : serverPort as int,
      // macAddress: object['mac_address'],
    );
  }
}
