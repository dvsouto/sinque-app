class Network {
  final String? _uuid;
  final String _address;
  final String _hostname;
  final String? _macAddress;

  Network({uuid, required address, required hostname, macAddress})
      : _uuid = uuid,
        _address = address,
        _hostname = hostname,
        _macAddress = macAddress;

  Map<String, dynamic> toMap() {
    return {
      'uuid': _uuid ?? 'unknown',
      'address': _address,
      'hostname': _hostname,
      'mac_address': _macAddress,
    };
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

  static Network decode(dynamic object) {
    return Network(
      uuid: object['uuid'],
      address: object['address'] as String,
      hostname: object['hostname'] as String,
      // macAddress: object['mac_address'],
    );
  }
}
