import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class TCPClientDisconnectedEvent
    extends EventEmiter<TCPClientDisconnectedEvent> {
  late final DeviceConnection _clientDevice;

  TCPClientDisconnectedEvent({DeviceConnection? clientDevice})
      : _clientDevice = clientDevice!;

  @override
  void listen() {}

  DeviceConnection get clientDevice => _clientDevice;
}
