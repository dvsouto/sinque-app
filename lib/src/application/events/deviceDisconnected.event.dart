import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Network.dart';

class DeviceDisconnectedEvent extends EventEmiter<DeviceDisconnectedEvent> {
  late final DeviceConnection _deviceConnection;

  DeviceDisconnectedEvent({DeviceConnection? deviceConnection})
      : _deviceConnection = deviceConnection!;

  @override
  void listen() {
    print("-- device disconnected:");
    print("@device: ${device.encode()}");
    print("@network: ${network.encode()}");

    final NetworkDevicesService networkDevicesService = NetworkDevicesService();

    networkDevicesService.remove(deviceConnection);
  }

  DeviceConnection get deviceConnection => _deviceConnection;
  Device get device => _deviceConnection.device;
  Network get network => _deviceConnection.network;
}
