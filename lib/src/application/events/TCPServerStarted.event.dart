import 'dart:io';

import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class TCPServerStartedEvent extends EventEmiter<TCPServerStartedEvent> {
  late final ServerSocket _server;

  TCPServerStartedEvent({ServerSocket? server}) : _server = server!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setServerStatus(NetworkStatusType.connected);

    print(
        "TCP Server service started on port ${server.address.address}:${server.port}!");
  }

  ServerSocket get server => _server;
}
