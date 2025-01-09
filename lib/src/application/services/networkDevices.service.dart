import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/networkDevices.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class NetworkDevicesService {
  late final ProviderContainer _container;

  NetworkDevicesService() {
    _container = AppLocator().container;
  }

  /// Adds the device if it does not exist in the list. If it has been added, returns true
  bool add(DeviceConnection device) {
    return _container.read(networkDevicesNotifierProvider.notifier).add(device);
  }

  /// Removes device if exists in the list
  void remove(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).remove(device);
  }

  /// Clear devices list
  void clear() {
    _container.read(networkDevicesNotifierProvider.notifier).clear();
  }

  /// Send ping to all devices on the list
  void pingAll() {
    _container.read(networkDevicesNotifierProvider.notifier).pingAll();
  }

  /// Send ping to device
  void ping(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).ping(device);
  }

  /// Send pong to device
  void pong(DeviceConnection device) {
    _container.read(networkDevicesNotifierProvider.notifier).pong(device);
  }

  /// Returns the list of disconnected devices
  List<DeviceConnection> lostDevices() {
    return _container
        .read(networkDevicesNotifierProvider.notifier)
        .lostDevices();
  }

  /// Returns true if the device exists on the list
  bool exists(DeviceConnection device) {
    return _container
        .read(networkDevicesNotifierProvider.notifier)
        .exists(device);
  }

  /// Read notifier
  List<DeviceConnection> read() {
    return _container.read(networkDevicesNotifierProvider);
  }

  /// Watch notifier
  List<DeviceConnection> watch(WidgetRef ref) {
    return ref.watch(networkDevicesNotifierProvider);
  }

  /// Notifier state
  List<DeviceConnection> get state => read();
}
