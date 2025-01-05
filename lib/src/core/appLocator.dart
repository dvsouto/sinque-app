import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/core/eventListener.dart';
import 'package:sinque/src/core/providers.dart';
import 'package:sinque/src/infra/database/drift/appDatabase.dart';
import 'package:sinque/src/infra/multicast/multicast.dart';

class AppLocator {
  static final AppLocator _instance = AppLocator._internal();

  late final AppDatabase _database;
  late final Multicast _multicast;
  late final EventBus _eventBus;
  late final EventListener _eventListener;
  late final ProviderContainer _container;

  factory AppLocator() => _instance;

  // Initialize dependencies
  AppLocator._internal() {
    print('@locator');

    _container = ProviderContainer();

    _database = container.read(appDatabaseProvider);
    _multicast = container.read(multicastProvider);
    _eventBus = container.read(eventBusProvider);
    _eventListener = container.read(eventListenerProvider);
  }

  AppDatabase get database => _database;
  Multicast get multicast => _multicast;
  EventBus get eventBus => _eventBus;
  EventListener get eventListener => _eventListener;
  ProviderContainer get container => _container;

  // Initialize dependences
  Future<void> initialize() async {
    _eventListener.listen();

    _multicast.open();
  }
}
