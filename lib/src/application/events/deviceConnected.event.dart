import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/application/services/packet.service.dart';
import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Network.dart';

class DeviceConnectedEvent extends EventEmiter<DeviceConnectedEvent> {
  late final DeviceConnection _deviceConnection;

  DeviceConnectedEvent({DeviceConnection? deviceConnection})
      : _deviceConnection = deviceConnection!;

  @override
  void listen() {
    print("-- device discovered:");
    print("@device: ${device.encode()}");
    print("@network: ${network.encode()}");

    final PacketService packetService = PacketService();
    final NetworkDevicesService networkDevicesService = NetworkDevicesService();

    networkDevicesService.add(deviceConnection);
    packetService.singlePing(deviceConnection);
  }

  DeviceConnection get deviceConnection => _deviceConnection;
  Device get device => _deviceConnection.device;
  Network get network => _deviceConnection.network;
}
