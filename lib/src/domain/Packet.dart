import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Network.dart';
import 'dart:convert';

import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/shared/device.util.dart';
import 'package:sinque/src/shared/enum.util.dart';
import 'package:sinque/src/shared/network.util.dart';
import 'package:uuid/uuid.dart';

class Packet {
  late final String _uuid;
  final Network _network;
  final Device _device;

  PacketType _type;
  String _data;

  Packet({
    String? uuid,
    required Network network,
    required Device device,
    required PacketType type,
    required String data,
  })  : _network = network,
        _device = device,
        _type = type,
        _data = data,
        _uuid = uuid ?? Uuid().v4();

  static Future<Packet> create({
    String data = '',
    required PacketType type,
    Network? network,
    Device? device,
  }) async {
    return Packet(
      data: data,
      device: device ?? await DeviceUtil.retrieve(),
      network: network ?? await NetworkUtil.retrieve(),
      type: type,
      uuid: Uuid().v4(),
    );
  }

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

  void setType(PacketType type) {
    _type = type;
  }

  PacketType getType() {
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

  static Packet decode(String data) {
    final Map<String, dynamic> object = jsonDecode(data);

    return Packet(
      uuid: object['uuid'],
      network: Network.decode(object['network']),
      device: Device.decode(object['device']),
      type: EnumUtil.namedBy<PacketType>(PacketType.values, object['type']),
      data: object['data'] as String,
    );
  }

  DeviceConnection get deviceConnection =>
      DeviceConnection(device: _device, network: _network);
}

enum PacketType {
  userConnected,
  userDisconnected,
  fileSent,
  textSent,

  ping,
  pong,
}
