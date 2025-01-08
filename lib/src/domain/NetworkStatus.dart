class NetworkStatus {
  DateTime lastStatusDate = DateTime.now();

  NetworkStatusType broadcastStatus = NetworkStatusType.idle;
  NetworkStatusType discoveryStatus = NetworkStatusType.idle;
  NetworkStatusType deviceStatus = NetworkStatusType.idle;
  NetworkStatusType serverStatus = NetworkStatusType.idle;
  NetworkStatusType clientStatus = NetworkStatusType.idle;

  NetworkStatus({
    required this.broadcastStatus,
    required this.discoveryStatus,
    required this.deviceStatus,
    required this.serverStatus,
    required this.lastStatusDate,
  });

  bool isConnected() {
    return broadcastStatus == NetworkStatusType.connected &&
        discoveryStatus == NetworkStatusType.connected &&
        deviceStatus == NetworkStatusType.connected &&
        serverStatus == NetworkStatusType.connected;
  }
}

enum NetworkStatusType {
  idle,
  connecting,
  connected,
}
