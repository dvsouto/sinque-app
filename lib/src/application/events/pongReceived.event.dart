import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/Packet.dart';

class PongReceivedEvent extends EventEmiter<PongReceivedEvent> {
  final Packet? _packet;

  PongReceivedEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    print("@pong rrrrr");
    final networkDevicesService = NetworkDevicesService();

    networkDevicesService.pong(packet.deviceConnection);
  }

  Packet get packet => _packet!;
}
