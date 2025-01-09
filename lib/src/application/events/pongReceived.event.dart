import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/deviceConnected.event.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/Packet.dart';

class PongReceivedEvent extends EventEmiter<PongReceivedEvent> {
  final Packet? _packet;

  PongReceivedEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    // print("@pong");

    final networkDevicesService = NetworkDevicesService();

    // If it was removed for some reason but received a pong, then add it back to the list
    if (networkDevicesService.add(packet.deviceConnection)) {
      DeviceConnectedEvent(deviceConnection: packet.deviceConnection)
          .dispatch();
    }

    networkDevicesService.pong(packet.deviceConnection);
  }

  Packet get packet => _packet!;
}
