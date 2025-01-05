import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/core/eventListener.dart';
import 'package:sinque/src/application/repository/network.repository.dart';
import 'package:sinque/src/infra/database/drift/appDatabase.dart';
import 'package:sinque/src/infra/database/drift/repository/network.repository.dart';
import 'package:sinque/src/infra/multicast/multicast.dart';

// Application
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final multicastProvider = Provider<Multicast>((ref) => Multicast());
final eventBusProvider = Provider<EventBus>((ref) => EventBus());
final eventListenerProvider = Provider<EventListener>((ref) => EventListener());

// Repositories
final networkRepositoryProvider =
    Provider<NetworkRepository>((ref) => NetworkRepositoryDraft());

// final multicastProvider = Provider<Multicast>((ref) =>
//     Multicast(networkRepository: ref.watch(networkRepositoryProvider)));
