import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/deviceConnected.event.dart';
import 'package:sinque/src/application/events/deviceDisconnected.event.dart';
import 'package:sinque/src/application/events/myDeviceConnected.event.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class DiscoveryServiceReceivedDeviceEvent
    extends EventEmiter<DiscoveryServiceReceivedDeviceEvent> {
  late final BonsoirDiscovery _discovery;
  late final DeviceConnection _deviceConnection;
  late final BonsoirDiscoveryEvent _event;

  DiscoveryServiceReceivedDeviceEvent(
      {BonsoirDiscovery? discovery,
      DeviceConnection? device,
      BonsoirDiscoveryEvent? event})
      : _discovery = discovery!,
        _deviceConnection = device!,
        _event = event!;

  @override
  void listen() {
    // User successfully connected to the service
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      deviceConnection.network.itsMe()
          ? MyDeviceConnectedEvent(deviceConnection: deviceConnection)
              .dispatch()
          : DeviceConnectedEvent(deviceConnection: deviceConnection).dispatch();
    }

    // Disconnected
    // @TODO check it
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      DeviceDisconnectedEvent(deviceConnection: deviceConnection).dispatch();
    }
  }

  BonsoirDiscovery get discovery => _discovery;
  DeviceConnection get deviceConnection => _deviceConnection;
  BonsoirDiscoveryEvent get event => _event;
}
