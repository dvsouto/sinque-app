import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:sinque/src/application/events/broadcastServiceOpening.event.dart';
import 'package:sinque/src/application/events/broadcastServiceStarted.event.dart';
import 'package:sinque/src/application/events/broadcastServiceStopped.event.dart';
import 'package:sinque/src/application/events/discoveryServiceReceivedDevice.event.dart';
import 'package:sinque/src/application/events/discoveryServiceOpening.event.dart';
import 'package:sinque/src/application/events/discoveryServiceStopped.event.dart';
import 'package:sinque/src/application/events/discoveryServiceStarted.event.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Network.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';
import 'package:sinque/src/shared/device.util.dart';
import 'package:sinque/src/shared/network.util.dart';

class Bonsoir {
  final String serviceName = 'sinque';
  final String serviceType = '_sinque-app._tcp';
  final int servicePort = 44319;

  late BonsoirService _service;
  late BonsoirBroadcast _broadcast;
  late BonsoirDiscovery _discovery;
  late String serviceUuid;

  List<String> discoveredServices = [];

  static late DeviceConnection _myDeviceConnection;

  Future<bool> initialize() async {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setDeviceStatus(NetworkStatusType.connecting);

    _myDeviceConnection = DeviceConnection(
      device: await DeviceUtil.retrieve(),
      network: await NetworkUtil.retrieve(),
    );

    serviceUuid = _myDeviceConnection.network.getUuid()!;

    _service = BonsoirService(
      name: '$serviceName-$serviceUuid',
      type: serviceType,
      port: servicePort,
      attributes: _encodeDeviceConnectionAttributes(
        _myDeviceConnection.network,
        _myDeviceConnection.device,
      ),
    );

    print("@my uuid: ${_service.attributes['service_uuid']}");

    _broadcast = BonsoirBroadcast(service: _service);
    _discovery = BonsoirDiscovery(type: serviceType);

    return start();
  }

  Map<String, String> _encodeDeviceConnectionAttributes(
      Network network, Device device) {
    final networkMap = network.toMap().map((itNetworkKey, itNetworkValue) =>
        MapEntry('network_$itNetworkKey', itNetworkValue.toString()));
    final deviceMap = device.toMap().map((itDeviceKey, itDeviceValue) =>
        MapEntry('device_$itDeviceKey', itDeviceValue.toString()));

    return {"service_uuid": serviceUuid, ...networkMap, ...deviceMap};
  }

  DeviceConnection _decodeDeviceConnectionAttributes(
      Map<String, String> attributes) {
    Map<String, String> networkAttributes = {};
    Map<String, String> deviceAttributes = {};

    attributes.forEach((key, value) {
      if (key.startsWith('network_')) {
        networkAttributes[key.substring(8)] = value;
      }

      if (key.startsWith('device_')) {
        deviceAttributes[key.substring(7)] = value;
      }
    });

    return DeviceConnection(
      device: Device.decode(deviceAttributes),
      network: Network.decode(networkAttributes),
    );
  }

  String _decodeServiceUuuid(Map<String, String> attributes) {
    return attributes['service_uuid']!;
  }

  Future<bool> start() async {
    await Future.microtask(() => _startDiscovery());
    await Future.microtask(() => _startBroadcast());

    return true;
  }

  Future<bool> _startBroadcast() async {
    BroadcastServiceOpeningEvent(broadcast: _broadcast).dispatch();

    await _broadcast.ready;
    await _broadcast.start();

    if (_broadcast.isStopped) {
      return false;
    }

    BroadcastServiceStartedEvent(broadcast: _broadcast).listen();

    return true;
  }

  Future<bool> _startDiscovery() async {
    DiscoveryServiceOpeningEvent(discovery: _discovery).dispatch();

    discoveredServices = [];

    await _discovery.ready;

    _discovery.eventStream!.listen(_discoveryServiceListen);

    await _discovery.start();

    if (_discovery.isStopped) {
      return false;
    }

    DiscoveryServiceStartedEvent(discovery: _discovery).dispatch();

    return true;
  }

  Future<void> _discoveryServiceListen(BonsoirDiscoveryEvent event) async {
    // Should be called when the user wants to connect to this service.
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      event.service!.resolve(
        _discovery.serviceResolver,
      );

      return;
    }

    DeviceConnection? deviceConnection;
    String? serviceUuid;
    bool shouldNotify = false;

    if (event.service != null && event.service!.attributes != {}) {
      try {
        deviceConnection =
            _decodeDeviceConnectionAttributes(event.service!.attributes);

        serviceUuid = _decodeServiceUuuid(event.service!.attributes);
      } catch (err, stackTrace) {
        // print(
        //     "A device has connected but cannot discovered!\nAttrs:${event.service!.attributes}\nErr: $err\nStack trace: $stackTrace");
        // "A device has connected but cannot discovered!");
      }
    }

    if (serviceUuid != null && !discoveredServices.contains(serviceUuid)) {
      shouldNotify = true;
      discoveredServices.add(serviceUuid);
    }

    if (deviceConnection != null && shouldNotify) {
      DiscoveryServiceReceivedDeviceEvent(
        device: deviceConnection,
        discovery: _discovery,
        event: event,
      ).dispatch();
    }
  }

  Future<bool> stop() async {
    final NetworkStatusService networkStatusService = NetworkStatusService();

    List<bool> status = await Future.wait([
      _stopDiscovery(),
      _stopBroadcast(),
    ]);

    networkStatusService.setDeviceStatus(NetworkStatusType.idle);

    return status.every((itStatus) => itStatus == true);
  }

  Future<bool> _stopBroadcast() async {
    if (!_broadcast.isStopped) {
      await _broadcast.stop();
    }

    BroadcastServiceStoppedEvent(broadcast: _broadcast).dispatch();

    return true;
  }

  Future<bool> _stopDiscovery() async {
    if (!_discovery.isStopped) {
      await _discovery.stop();
    }

    discoveredServices = [];

    DiscoveryServiceStoppedEvent(discovery: _discovery).dispatch();

    return true;
  }
}
