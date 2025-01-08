import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';

class PingSentEvent extends EventEmiter<PingSentEvent> {
  final Packet? _packet;

  PingSentEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    print("@sended ping");

    final networkDevicesService = NetworkDevicesService();

    networkDevicesService.pingAll();

    final lostDevices = networkDevicesService.lostDevices();

    for (DeviceConnection lostDevice in lostDevices) {
      networkDevicesService.remove(lostDevice);
    }
  }

  Packet get packet => _packet!;
}
