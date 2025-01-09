import 'package:sinque/src/core/packetMessage.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/EmptyMessage.dart';
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
  PacketMessage _data;

  Packet({
    String? uuid,
    required Network network,
    required Device device,
    required PacketType type,
    required PacketMessage data,
  })  : _network = network,
        _device = device,
        _type = type,
        _data = data,
        _uuid = uuid ?? Uuid().v4();

  static Future<Packet> create<T>({
    PacketMessage? data,
    required PacketType type,
    Network? network,
    Device? device,
  }) async {
    return Packet(
      data: data ?? EmptyMessage(),
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
      'data': jsonEncode(_data.encodeMessage()),
    };
  }

  String encode() {
    return jsonEncode(toMap());
  }

  void setMessage(dynamic data) {
    _data = data;
  }

  T getMessage<T extends PacketMessage>() {
    return _data as T;
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

  static Packet decode<T>(String data) {
    final Map<String, dynamic> object = jsonDecode(data);
    final PacketType packetType =
        EnumUtil.namedBy<PacketType>(PacketType.values, object['type']);

    return Packet(
      uuid: object['uuid'],
      network: Network.decode(object['network']),
      device: Device.decode(object['device']),
      type: EnumUtil.namedBy<PacketType>(PacketType.values, object['type']),
      data: PacketMessage.applyDecode(
        data: jsonDecode(object['data']),
        packetType: packetType,
      ),
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

  sync,
}
