import 'dart:io';

import 'package:drift/drift.dart';
import 'package:sinque/src/application/events/TCPClientConnecting.event.dart';
import 'package:sinque/src/application/events/TCPClientConnected.event.dart';
import 'package:sinque/src/application/events/TCPClientDisconnected.event.dart';
import 'package:sinque/src/application/events/packetSent.event.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';
import 'package:sinque/src/shared/device.util.dart';
import 'package:sinque/src/shared/network.util.dart';
import 'package:uuid/uuid.dart';

class TCPClient {
  late final String host;
  late final DeviceConnection clientDevice;
  late final int port;

  bool _connected = false;
  bool _retryConnect = false;
  final int _retryAfterSeconds = 10;

  late Socket _client;

  TCPClient({required this.clientDevice}) {
    host = clientDevice.network.getAddress();
    port = clientDevice.network.getServerPort();
  }

  Future<bool> connect() async {
    if (_connected) {
      print("TCP Client already oppened!");

      return false;
    }

    TCPClientConnectingEvent(clientDevice: clientDevice).dispatch();

    try {
      _client = await Socket.connect(host, port);

      _client.listen(
        _listen,
        onDone: _onDone,
        onError: _onError,
      );

      TCPClientConnectedEvent(clientDevice: clientDevice).dispatch();

      _connected = true;
    } catch (err) {
      print("Error trying start TCP Client: $err");

      _connected = false;

      return false;
    }

    // Retry connect if fail
    if (!_connected && _retryConnect) {
      _retryStart();
    }

    return true;
  }

  Future<bool> send(
    Packet packet, {
    bool autoConnect = true,
    bool autoDisconnect = true,
  }) async {
    if (autoConnect && !_connected) {
      await connect();
    }

    if (_connected) {
      bool success = false;

      try {
        _client.write(packet.encode());

        success = true;
      } catch (err) {
        print("Error trying send message to TCP Server: $err");

        success = false;
      } finally {
        if (autoDisconnect) {
          await disconnect();
        }
      }

      return success;
    }

    return false;
  }

  void _retryStart() {
    print(
        "TCP Client connection fail, retrying connect after ${_retryAfterSeconds}s");

    Future.delayed(Duration(seconds: _retryAfterSeconds), connect);
  }

  void _listen(Uint8List data) {
    String message = String.fromCharCodes(data);

    // print('@Message received from server: $message');
  }

  Future<bool> disconnect() async {
    if (!_connected) {
      print("TCP Client already closed");

      return false;
    }

    return _client.close().then((_) {
      _connected = false;

      TCPClientDisconnectedEvent(clientDevice: clientDevice).dispatch();

      return true;
    }).catchError((error) {
      print("Error trying close TCP Client: $error");

      return false;
    });
  }

  _onDone() {
    _connected = false;

    TCPClientDisconnectedEvent(clientDevice: clientDevice).dispatch();

    if (_retryConnect) {
      connect();
    }
  }

  _onError(error) {
    print("@TCP Client error: $error");
  }

  destroy() async {
    _retryConnect = false;

    if (_connected) {
      await disconnect();
    }

    _client.destroy();
  }
}
