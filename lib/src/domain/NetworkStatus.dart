class NetworkStatus {
  NetworkStatusType status = NetworkStatusType.idle;
  DateTime lastStatusDate = DateTime.now();

  NetworkStatus({required this.status, required this.lastStatusDate});

  bool isConnected() {
    return status == NetworkStatusType.connected;
  }
}

enum NetworkStatusType {
  idle,
  connecting,
  connected,
}
