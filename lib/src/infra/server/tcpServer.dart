import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:sinque/src/application/events/TCPServerOpening.event.dart';
import 'package:sinque/src/application/events/TCPServerStarted.event.dart';
import 'package:sinque/src/application/events/TCPServerStopped.event.dart';
import 'package:sinque/src/application/events/packetReceived.event.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';
import 'package:sinque/src/shared/network.util.dart';

class TCPServer {
  late final String host;
  int port = 44400;

  bool _connected = false;
  final bool _retryConnect = true;
  final int _retryAfterSeconds = 10;

  late ServerSocket _server;

  Future<bool> initialize() async {
    return start();
  }

  Future<bool> start() async {
    host = (await NetworkUtil.retrieveLocalIpAddress()).address;
    port = await NetworkUtil.retrieveServerPort();

    if (_connected) {
      print("TCP Server already oppened!");

      return false;
    }

    TCPServerOpeningEvent().dispatch();

    try {
      _server = await ServerSocket.bind(host, port);

      _server.listen(
        (Socket client) {
          client.listen(
            (data) => _listen(data, client),
            onDone: () => _onClientDone(client),
            onError: (err, stackTrace) =>
                _onClientError(err, stackTrace, client),
          );
        },
        onDone: _onServerDone,
        onError: _onServerError,
      );

      TCPServerStartedEvent(server: _server).dispatch();

      _connected = true;
    } catch (err) {
      print("Error trying start TCP Server: $err");

      _connected = false;

      return false;
    }

    // Retry connect if fail
    if (!_connected && _retryConnect) {
      _retryStart();
    }

    return true;
  }

  void _retryStart() {
    print(
        "TCP Server connection fail, we retry connect after ${_retryAfterSeconds}s");

    Future.delayed(Duration(seconds: _retryAfterSeconds), start);
  }

  void _listen(Uint8List data, Socket client) {
    Future.microtask(() {
      List<int> listenBuffer = [];

      listenBuffer.addAll(data);

      int readed = 0;

      while (listenBuffer.length > 0 || readed > 100) {
        readed++;

        final currentBuffer = Uint8List.fromList(listenBuffer);

        final payloadSize = currentBuffer.buffer.asByteData().getUint32(0);
        final typeHash = currentBuffer.buffer.asByteData().getUint32(8);
        final type = _typeFromHash(typeHash);

        if (listenBuffer.length >= payloadSize) {
          final payloadBytes = currentBuffer.sublist(12, payloadSize);
          final payload = utf8.decode(payloadBytes);

          listenBuffer.removeRange(0, payloadSize);

          Packet packet = Packet.decode(payload);

          PacketReceivedEvent(packet: packet).dispatch();
        } else {
          break;
        }
      }
    });
  }

  String _typeFromHash(int hash) {
    switch (hash) {
      case 0x4a534f4e: // "JSON"
        return "JSON";
      case 0x54455854: // "TEXT"
        return "TEXT";
      case 0x46494c45: // "FILE"
        return "FILE";
      default:
        return "UNKNOWN";
    }
  }

  Future<bool> stop() async {
    if (!_connected) {
      print("TCP Server already closed");

      return false;
    }

    return _server.close().then((_) {
      _connected = false;

      TCPServerStoppedEvent(server: _server).dispatch();

      return true;
    }).catchError((error) {
      print("Error trying close TCP Server: $error");

      return false;
    });
  }

  _onServerDone() {
    _connected = false;

    TCPServerStoppedEvent(server: _server).dispatch();

    if (_retryConnect) {
      start();
    }
  }

  _onClientDone(Socket client) {
    client.destroy();
  }

  _onServerError(error) {
    print("@TCP Server error: $error");
  }

  _onClientError(error, stackTrace, Socket client) {
    print("@TCP Server -> Client error: $error");
  }
}
