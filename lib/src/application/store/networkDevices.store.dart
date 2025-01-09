import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';

class NetworkDevicesNotifier extends StateNotifier<List<DeviceConnection>> {
  NetworkDevicesNotifier() : super(List.empty());

  bool add(DeviceConnection device) {
    if (!exists(device)) {
      state = [...state, device];

      return true;
    }

    return false;
  }

  void remove(DeviceConnection device) {
    state = state
        .where((itDevice) =>
            itDevice.network.getUuid() != device.network.getUuid())
        .toList();
  }

  bool exists(DeviceConnection device) {
    return state.any((stateDevice) =>
        stateDevice.network.getUuid() == device.network.getUuid());
  }

  void ping(DeviceConnection device) {
    state = state.map((itDevice) {
      if (itDevice.equals(device)) {
        itDevice.ping();
      }

      return itDevice;
    }).toList();
  }

  void pingAll() {
    state = state.map((itDevice) {
      itDevice.ping();

      return itDevice;
    }).toList();
  }

  void pong(DeviceConnection device) {
    state = state.map((itDevice) {
      if (itDevice.equals(device)) {
        itDevice.pong();
      }

      return itDevice;
    }).toList();
  }

  List<DeviceConnection> lostDevices() {
    return state.where((itDevice) => itDevice.losted()).toList();
  }

  void clear() {
    state = [];
  }
}

final networkDevicesNotifierProvider =
    StateNotifierProvider<NetworkDevicesNotifier, List<DeviceConnection>>(
        (ref) => NetworkDevicesNotifier());
