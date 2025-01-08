import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class TCPServerOpeningEvent extends EventEmiter<TCPServerOpeningEvent> {
  // late final ServerSocket _server;

  TCPServerOpeningEvent();

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setServerStatus(NetworkStatusType.connecting);
  }

  // ServerSocket get server => _server;
}
