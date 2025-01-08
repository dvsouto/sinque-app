import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class NetworkStatusNotifier extends StateNotifier<NetworkStatus> {
  NetworkStatusNotifier()
      : super(NetworkStatus(
          deviceStatus: NetworkStatusType.idle,
          broadcastStatus: NetworkStatusType.idle,
          discoveryStatus: NetworkStatusType.idle,
          serverStatus: NetworkStatusType.idle,
          lastStatusDate: DateTime.now(),
        ));

  void setBroadcastStatus(NetworkStatusType status) {
    state = NetworkStatus(
      broadcastStatus: status,
      discoveryStatus: state.discoveryStatus,
      deviceStatus: state.deviceStatus,
      serverStatus: state.serverStatus,
      lastStatusDate: DateTime.now(),
    );
  }

  void setDiscoverystatus(NetworkStatusType status) {
    state = NetworkStatus(
      discoveryStatus: status,
      broadcastStatus: state.broadcastStatus,
      deviceStatus: state.deviceStatus,
      serverStatus: state.serverStatus,
      lastStatusDate: DateTime.now(),
    );
  }

  void setDeviceStatus(NetworkStatusType status) {
    state = NetworkStatus(
      deviceStatus: status,
      discoveryStatus: state.discoveryStatus,
      broadcastStatus: state.broadcastStatus,
      serverStatus: state.serverStatus,
      lastStatusDate: DateTime.now(),
    );
  }

  void setServerStatus(NetworkStatusType status) {
    state = NetworkStatus(
      serverStatus: status,
      deviceStatus: state.deviceStatus,
      discoveryStatus: state.discoveryStatus,
      broadcastStatus: state.broadcastStatus,
      lastStatusDate: DateTime.now(),
    );
  }
}

final networkStatusNotifierProvider =
    StateNotifierProvider<NetworkStatusNotifier, NetworkStatus>(
        (ref) => NetworkStatusNotifier());
