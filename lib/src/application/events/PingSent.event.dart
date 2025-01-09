import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/deviceDisconnected.event.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';

class PingSentEvent extends EventEmiter<PingSentEvent> {
  final Packet? _packet;

  PingSentEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    // print("@sended ping");

    final networkDevicesService = NetworkDevicesService();

    networkDevicesService.pingAll();

    Future.delayed(Duration(seconds: 1), () {
      final lostDevices = networkDevicesService.lostDevices();

      for (DeviceConnection lostDevice in lostDevices) {
        DeviceDisconnectedEvent(deviceConnection: lostDevice).dispatch();
      }
    });
  }

  Packet get packet => _packet!;
}
