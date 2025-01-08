import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Network.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class MyDeviceConnectedEvent extends EventEmiter<MyDeviceConnectedEvent> {
  late final DeviceConnection _deviceConnection;

  MyDeviceConnectedEvent({DeviceConnection? deviceConnection})
      : _deviceConnection = deviceConnection!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    if (networkStatusService.state.deviceStatus == NetworkStatusType.idle ||
        networkStatusService.state.deviceStatus ==
            NetworkStatusType.connecting) {
      networkStatusService.setDeviceStatus(NetworkStatusType.connected);

      print("-- your device has connected:");
    }
  }

  DeviceConnection get deviceConnection => _deviceConnection;
  Device get device => _deviceConnection.device;
  Network get network => _deviceConnection.network;
}
