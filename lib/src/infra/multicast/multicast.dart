import 'dart:io';
import 'dart:convert';

import 'package:sinque/src/application/events/packetReceived.event.dart';
import 'package:sinque/src/application/events/packetSent.event.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/core/packetMessage.dart';
import 'package:sinque/src/domain/EmptyMessage.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';
import 'package:sinque/src/domain/Packet.dart';
import 'package:sinque/src/domain/Network.dart';
import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/shared/network.util.dart';

class Multicast {
  final String multicastAddress = '233.0.0.1';
  final int multicastPort = 44294;

  static late RawDatagramSocket _socket;
  static late InternetAddress _multicastAddressInstance;
  static bool _connected = false;
  static final bool _retryConnect = true;
  static final int _retryAfterSeconds = 10;
  static late String _uuid;

  static late Network _network;
  static late Device _device;

  Future<bool> open() async {
    final networkStatusService = NetworkStatusService();

    if (_connected) {
      print("Multicast already opened");

      return true;
    }

    // networkStatusService.setStatus(NetworkStatusType.connecting);

    final localIpAddress = await NetworkUtil.retrieveLocalIpAddress();
    final localInterface = await NetworkUtil.retrieveLocalNetworkInterface();

    print("Connecting multicast...");
    print("@local ip: ${localIpAddress}");
    print("@interface: ${localInterface}");

    final networkInterfaces = await NetworkInterface.list();
    for (var interface in networkInterfaces) {
      print('Interface: ${interface.name}, Addresses: ${interface.addresses}');
    }

    try {
      _socket = await RawDatagramSocket.bind(
        // InternetAddress('192.168.0.0'),
        // bindNetworkInterface.addresses.first,
        InternetAddress.anyIPv4,
        // bindNetworkInterface?.addresses.first ?? InternetAddress.anyIPv4,
        multicastPort,
        reuseAddress: true,
        reusePort: true,
      );

      _multicastAddressInstance = InternetAddress(multicastAddress);

      // _socket.setRawOption(RawSocketOption(RawSocketOption.levelIPv4, 12, UIint8List.fromList()))
      _socket.joinMulticast(_multicastAddressInstance, localInterface);

      _socket.multicastHops = 50;
      _socket.broadcastEnabled = true;
      _socket.writeEventsEnabled = true;
      _socket.readEventsEnabled = true;
      _socket.multicastLoopback = true; // @TODO check this
      _socket.listen(_listen, onError: _onError, onDone: _onDone);

      await _getUserInfo();

      _connected = true;

      // networkStatusService.setStatus(NetworkStatusType.connected);

      print('Multicast connected at $multicastAddress:$multicastPort');
    } catch (err, stackTrace) {
      _connected = false;

      // networkStatusService.setStatus(NetworkStatusType.idle);

      _onError(err, stackTrace);
    }

    // Retry connect if fail
    if (!_connected && _retryConnect) {
      print("Connection fail, we retry connect after ${_retryAfterSeconds}s");

      Future.delayed(Duration(seconds: _retryAfterSeconds), open);
    }

    return _connected;
  }

  void close() {
    if (!_connected) {
      print("Multicast already closed");

      return;
    }

    _socket.close();
    _connected = false;

    // NetworkStatusService().setStatus(NetworkStatusType.idle);
  }

  Future<void> _getUserInfo() async {
    _uuid = await NetworkUtil.retrieveUuid();

    final localNetworkAddress = await NetworkUtil.retrieveLocalIpAddress();

    _network = Network(
      uuid: _uuid,
      address: localNetworkAddress.address,
      hostname: Platform.localHostname,
      serverPort: 9999,
    );

    print('@network: ${_network.toMap()}');
    _device = await Device.detect();
  }

  void _listen(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final Datagram? datagram = _socket.receive();

      if (datagram != null) {
        final message = utf8.decode(datagram.data);
        final decoded = Packet.decode(message);

        // Call handler only if the uuid of message belongs to someone else
        // if (decoded.getNetwork().getUuid() != _uuid) {
        _onMessage(datagram, decoded);
        // }
      }
    }

    if (event == RawSocketEvent.write) {
      _onSend();
    }

    if (event == RawSocketEvent.readClosed) {
      _onClose();
    }
  }

  int sendPacket(PacketType type, PacketMessage? data) {
    Packet packet = Packet(
      network: _network,
      device: _device,
      type: type,
      data: data ?? EmptyMessage(),
    );

    try {
      return _socket.send(
        utf8.encode(packet.encode()),
        // InternetAddress('192.168.1.3'),
        _multicastAddressInstance,
        multicastPort,
      );
    } catch (err, stackTrace) {
      _onError(err, stackTrace);

      // @TODO check this
      // if (err is SocketException) {
      //   _onClose();
      // }

      return -1;
    }
  }

  void _onMessage(Datagram datagram, Packet packet) {
    if (packet.itsMe()) {
      PacketSentEvent(packet: packet).dispatch();
    } else {
      PacketReceivedEvent(packet: packet).dispatch();
    }
  }

  void _onSend() {
    print('Sended message');
  }

  void _onDone() {
    print('Connection lost');

    _onClose();
  }

  void _onClose() {
    try {
      _socket.close();
      // ignore: empty_catches
    } catch (err) {}

    _connected = false;

    // NetworkStatusService().setStatus(NetworkStatusType.idle);

    if (_retryConnect) {
      open();
    }
  }

  void _onError(Object error, [StackTrace? stackTrace]) {
    print('Multicast error: $error');

    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }

  bool isConnected() {
    return _connected;
  }

  RawDatagramSocket getSocket() {
    return _socket;
  }

  // @TODO
  // InternetAddress getInternetAddress() {
  //   return _internetAddress;
  // }

  String getUuid() {
    return _uuid;
  }

  Network getNetwork() {
    return _network;
  }

  Device getDevice() {
    return _device;
  }
}
