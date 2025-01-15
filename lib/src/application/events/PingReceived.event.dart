import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/deviceConnected.event.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/application/services/packet.service.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';

class PingReceivedEvent extends EventEmiter<PingReceivedEvent> {
  final Packet? _packet;

  PingReceivedEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    final packetService = PacketService();
    final networkDevicesService = NetworkDevicesService();

    // print("@PingReceivedEvent");

    // If it was removed for some reason but received a pong, then add it back to the list
    if (networkDevicesService.add(packet.deviceConnection)) {
      DeviceConnectedEvent(deviceConnection: packet.deviceConnection)
          .dispatch();
    }

    packetService.pong(DeviceConnection(
      device: packet.getDevice(),
      network: packet.getNetwork(),
    ));
  }

  Packet get packet => _packet!;
}
