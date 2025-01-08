import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class TCPClientConnectedEvent extends EventEmiter<TCPClientConnectedEvent> {
  late final DeviceConnection _clientDevice;

  TCPClientConnectedEvent({DeviceConnection? clientDevice})
      : _clientDevice = clientDevice!;

  @override
  void listen() {}

  DeviceConnection get clientDevice => _clientDevice;
}
