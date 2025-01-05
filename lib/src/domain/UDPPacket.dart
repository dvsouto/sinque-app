import 'package:sinque/src/domain/Network.dart';
import 'dart:convert';

import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/shared/enum.util.dart';
import 'package:sinque/src/shared/network.util.dart';
import 'package:uuid/uuid.dart';

class UDPPacket {
  late final String _uuid;
  final Network _network;
  final Device _device;

  UDPPacketType _type;
  String _data;

  UDPPacket({
    String? uuid,
    required Network network,
    required Device device,
    required UDPPacketType type,
    required String data,
  })  : _network = network,
        _device = device,
        _type = type,
        _data = data,
        _uuid = uuid ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'uuid': _uuid,
      'network': _network.toMap(),
      'device': _device.toMap(),
      'type': _type.toString(),
      'data': _data,
    };
  }

  String encode() {
    return jsonEncode(toMap());
  }

  void setMessage(String data) {
    this._data = data;
  }

  String getMessage() {
    return _data;
  }

  void setType(UDPPacketType type) {
    _type = type;
  }

  UDPPacketType getType() {
    return _type;
  }

  Network getNetwork() {
    return _network;
  }

  Device getDevice() {
    return _device;
  }

  String getUuid() {
    return _uuid;
  }

  bool itsMe() {
    return NetworkUtil.retrieveUuidSync() == _network.getUuid();
  }

  static UDPPacket decode(String data) {
    final Map<String, dynamic> object = jsonDecode(data);

    return UDPPacket(
      uuid: object['uuid'],
      network: Network.decode(object['network']),
      device: Device.decode(object['device']),
      type:
          EnumUtil.namedBy<UDPPacketType>(UDPPacketType.values, object['type']),
      data: object['data'] as String,
    );
  }
}

enum UDPPacketType {
  userConnected,
  userDisconnected,
  fileSent,
  textSent,
}
