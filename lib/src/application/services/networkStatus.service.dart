import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/networkStatus.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class NetworkStatusService {
  late final ProviderContainer _container;

  NetworkStatusService() {
    _container = AppLocator().container;
  }

  /// Sets the broadcast service status
  void setBroadcastStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setBroadcastStatus(status);
  }

  /// Sets the discovery service status
  void setDiscoveryStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setDiscoverystatus(status);
  }

  /// Sets the wifi hotspot status
  void setDeviceStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setDeviceStatus(status);
  }

  // Sets the TCP Server status
  void setServerStatus(NetworkStatusType status) {
    _container
        .read(networkStatusNotifierProvider.notifier)
        .setServerStatus(status);
  }

  /// Read the notifier
  NetworkStatus read() {
    return _container.read(networkStatusNotifierProvider);
  }

  /// Watch the notifier
  NetworkStatus watch(WidgetRef ref) {
    return ref.watch(networkStatusNotifierProvider);
  }

  /// Notifier state
  NetworkStatus get state => read();
}
