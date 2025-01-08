import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/networkStatus.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class NetworkStatusService {
  late final ProviderContainer _container;

  NetworkStatusService() {
    _container = AppLocator().container;
  }

  void setBroadcastStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setBroadcastStatus(status);
  }

  void setDiscoveryStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setDiscoverystatus(status);
  }

  void setDeviceStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setDeviceStatus(status);
  }

  void setServerStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setServerStatus(status);
  }

  NetworkStatus read() {
    return _container.read(networkStatusNotifierProvider);
  }

  NetworkStatus watch(WidgetRef ref) {
    return ref.watch(networkStatusNotifierProvider);
  }

  NetworkStatus get state => read();
}
