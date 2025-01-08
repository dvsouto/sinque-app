import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/networkDevices.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class NetworkDevicesService {
  late final ProviderContainer _container;

  NetworkDevicesService() {
    _container = AppLocator().container;
  }

  void add(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).add(device);
  }

  void remove(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).remove(device);
  }

  void clear() {
    _container.read(networkDevicesNotifierProvider.notifier).clear();
  }

  void pingAll() {
    _container.read(networkDevicesNotifierProvider.notifier).pingAll();
  }

  void ping(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).ping(device);
  }

  void pong(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).pong(device);
  }

  List<DeviceConnection> lostDevices() {
    return _container
        .read(networkDevicesNotifierProvider.notifier)
        .lostDevices();
  }

  bool exists(DeviceConnection device) {
    return _container
        .read(networkDevicesNotifierProvider.notifier)
        .exists(device);
  }

  List<DeviceConnection> read() {
    return _container.read(networkDevicesNotifierProvider);
  }

  List<DeviceConnection> watch(WidgetRef ref) {
    return ref.watch(networkDevicesNotifierProvider);
  }

  List<DeviceConnection> get state => read();
}
