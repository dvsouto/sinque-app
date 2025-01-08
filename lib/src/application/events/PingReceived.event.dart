import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/packet.service.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';

class PingReceivedEvent extends EventEmiter<PingReceivedEvent> {
  final Packet? _packet;

  PingReceivedEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    final packetService = PacketService();

    packetService.pong(DeviceConnection(
      device: packet.getDevice(),
      network: packet.getNetwork(),
    ));
  }

  Packet get packet => _packet!;
}
