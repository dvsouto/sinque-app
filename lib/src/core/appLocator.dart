import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/core/connectionChecker.dart';
import 'package:sinque/src/application/core/eventListener.dart';
import 'package:sinque/src/core/providers.dart';
import 'package:sinque/src/infra/bonsoir/bonsoir.dart';
import 'package:sinque/src/infra/database/drift/appDatabase.dart';
import 'package:sinque/src/infra/multicast/multicast.dart';
import 'package:sinque/src/infra/server/tcpServer.dart';

class AppLocator {
  static final AppLocator _instance = AppLocator._internal();

  late final AppDatabase _database;
  late final Multicast _multicast;
  late final Bonsoir _bonsoir;
  late final TCPServer _tcpServer;
  late final EventBus _eventBus;
  late final EventListener _eventListener;
  late final ProviderContainer _container;
  late final ConnectionChecker _connectionChecker;

  factory AppLocator() => _instance;

  // Initialize dependencies
  AppLocator._internal() {
    _container = ProviderContainer();

    _database = container.read(appDatabaseProvider);
    _multicast = container.read(multicastProvider);
    _bonsoir = container.read(bonsoirProvider);
    _tcpServer = container.read(tcpServerProvider);
    _eventBus = container.read(eventBusProvider);
    _eventListener = container.read(eventListenerProvider);
    _connectionChecker = container.read(connectionCheckerProvider);
  }

  AppDatabase get database => _database;
  Multicast get multicast => _multicast;
  Bonsoir get bonsoir => _bonsoir;
  TCPServer get tcpServer => _tcpServer;
  EventBus get eventBus => _eventBus;
  EventListener get eventListener => _eventListener;
  ProviderContainer get container => _container;
  ConnectionChecker get connectionChecker => _connectionChecker;

  // Initialize dependences
  Future<void> initialize() async {
    await Future.microtask(() => _eventListener.listen());
    await Future.microtask(() => _bonsoir.initialize());
    await Future.microtask(() => _tcpServer.initialize());

    Future.microtask(() => _connectionChecker.initialize());

    // _multicast.open();
  }
}
