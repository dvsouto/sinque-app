// ignore: file_names

import 'dart:async';
import 'dart:io';

import 'package:sinque/src/application/repository/network.repository.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/core/providers.dart';
import 'package:sinque/src/domain/Network.dart';

class NetworkUtil {
  static String? _networkUuid;
  static int? _serverPort;

  static int maxLostPackages = 3;

  static Future<String> retrieveUuid() async {
    if (_networkUuid != null) {
      return _networkUuid!;
    }

    NetworkRepository networkRepository =
        AppLocator().container.read(networkRepositoryProvider);

    _networkUuid = await networkRepository.retrieveUuid();

    return _networkUuid!;
  }

  static String retrieveUuidSync() {
    return _networkUuid!;
  }

  static retrieveLocalNetworkInterface() async {
    final networkInterfaces = await NetworkInterface.list();

    final retrievedInterface = networkInterfaces.firstWhere(
        (i) => i.name.contains('en0'),
        orElse: () => networkInterfaces.first);

    return retrievedInterface;
  }

  static Future<InternetAddress> retrieveLocalIpAddress() async {
    return (await NetworkUtil.retrieveLocalNetworkInterface()).addresses.first;
  }

  static Future<int> retrieveServerPort({bool retry = false}) async {
    if (_serverPort != null) {
      return _serverPort!;
    }

    int port = 44400;
    int max = 44999;

    // if (Platform.isAndroid || Platform.isAndroid) {
    //   return port;
    // }

    // if desktop, verify if port is available

    bool portInUse = true;

    while (portInUse) {
      portInUse = await isPortInUse(port);

      if (portInUse) {
        port++;
      }

      if (port >= max) {
        break;
      }
    }

    _serverPort = port;

    return port;
  }

  static Future<bool> isPortInUse(int port) async {
    try {
      final ipAddress = await retrieveLocalIpAddress();
      final socket = await Socket.connect(ipAddress.address, port);

      socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Network> retrieve() async {
    final uuid = await NetworkUtil.retrieveUuid();
    final localNetworkAddress = await NetworkUtil.retrieveLocalIpAddress();
    final serverPort = await NetworkUtil.retrieveServerPort();

    return Network(
      uuid: uuid,
      address: localNetworkAddress.address,
      hostname: Platform.localHostname,
      serverPort: serverPort,
    );
  }
}
