import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/core/connectionChecker.dart';
import 'package:sinque/src/application/core/eventListener.dart';
import 'package:sinque/src/application/repository/network.repository.dart';
import 'package:sinque/src/infra/bonsoir/bonsoir.dart';
import 'package:sinque/src/infra/database/drift/appDatabase.dart';
import 'package:sinque/src/infra/database/drift/repository/network.repository.dart';
import 'package:sinque/src/infra/multicast/multicast.dart';
import 'package:sinque/src/infra/server/tcpServer.dart';

// Application
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final multicastProvider = Provider<Multicast>((ref) => Multicast());
final bonsoirProvider = Provider<Bonsoir>((ref) => Bonsoir());
final tcpServerProvider = Provider<TCPServer>((ref) => TCPServer());
final eventBusProvider = Provider<EventBus>((ref) => EventBus());
final eventListenerProvider = Provider<EventListener>((ref) => EventListener());
final connectionCheckerProvider =
    Provider<ConnectionChecker>((ref) => ConnectionChecker());

// Repositories
final networkRepositoryProvider =
    Provider<NetworkRepository>((ref) => NetworkRepositoryDraft());

// final multicastProvider = Provider<Multicast>((ref) =>
//     Multicast(networkRepository: ref.watch(networkRepositoryProvider)));
