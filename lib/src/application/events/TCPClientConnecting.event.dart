import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class TCPClientConnectingEvent extends EventEmiter<TCPClientConnectingEvent> {
  late final DeviceConnection _clientDevice;

  TCPClientConnectingEvent({DeviceConnection? clientDevice})
      : _clientDevice = clientDevice!;

  @override
  void listen() {}

  DeviceConnection get clientDevice => _clientDevice;
}
