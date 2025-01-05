import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class NetworkStatusNotifier extends StateNotifier<NetworkStatus> {
  NetworkStatusNotifier()
      : super(NetworkStatus(
            status: NetworkStatusType.idle, lastStatusDate: DateTime.now()));

  void setStatus(NetworkStatusType status) {
    state = NetworkStatus(
      status: status,
      lastStatusDate: DateTime.now(),
    );
  }
}

final networkStatusNotifierProvider =
    StateNotifierProvider<NetworkStatusNotifier, NetworkStatus>(
        (ref) => NetworkStatusNotifier());
