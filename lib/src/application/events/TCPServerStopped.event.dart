import 'dart:io';

import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class TCPServerStoppedEvent extends EventEmiter<TCPServerStoppedEvent> {
  late final ServerSocket _server;

  TCPServerStoppedEvent({ServerSocket? server}) : _server = server!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setServerStatus(NetworkStatusType.idle);

    print("TCP Server service stopped.");
  }

  ServerSocket get server => _server;
}
