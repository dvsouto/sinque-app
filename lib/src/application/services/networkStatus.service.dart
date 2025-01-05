import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/networkStatus.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class NetworkStatusService {
  late final ProviderContainer _container;

  NetworkStatusService() {
    _container = AppLocator().container;
  }

  void setStatus(NetworkStatusType status) {
    _container.read(networkStatusNotifierProvider.notifier).setStatus(status);
  }

  NetworkStatus read() {
    return _container.read(networkStatusNotifierProvider);
  }

  NetworkStatus watch(WidgetRef ref) {
    return ref.watch(networkStatusNotifierProvider);
  }
}
