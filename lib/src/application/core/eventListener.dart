import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/PingReceived.event.dart';
import 'package:sinque/src/application/events/PingSent.event.dart';
import 'package:sinque/src/application/events/TCPClientConnected.event.dart';
import 'package:sinque/src/application/events/TCPClientConnecting.event.dart';
import 'package:sinque/src/application/events/TCPClientDisconnected.event.dart';
import 'package:sinque/src/application/events/TCPServerOpening.event.dart';
import 'package:sinque/src/application/events/TCPServerStarted.event.dart';
import 'package:sinque/src/application/events/TCPServerStopped.event.dart';
import 'package:sinque/src/application/events/broadcastServiceOpening.event.dart';
import 'package:sinque/src/application/events/broadcastServiceStarted.event.dart';
import 'package:sinque/src/application/events/broadcastServiceStopped.event.dart';
import 'package:sinque/src/application/events/deviceConnected.event.dart';
import 'package:sinque/src/application/events/deviceDisconnected.event.dart';
import 'package:sinque/src/application/events/discoveryServiceOpening.event.dart';
import 'package:sinque/src/application/events/discoveryServiceReceivedDevice.event.dart';
import 'package:sinque/src/application/events/discoveryServiceStarted.event.dart';
import 'package:sinque/src/application/events/discoveryServiceStopped.event.dart';
import 'package:sinque/src/application/events/myDeviceConnected.event.dart';
import 'package:sinque/src/application/events/packetReceived.event.dart';
import 'package:sinque/src/application/events/packetSent.event.dart';
import 'package:sinque/src/application/events/pongReceived.event.dart';
import 'package:sinque/src/application/events/pongSent.event.dart';
import 'package:sinque/src/application/events/syncedItemsReceived.event.dart';
import 'package:sinque/src/application/events/textReceived.event.dart';
import 'package:sinque/src/application/events/textSent.event.dart';
import 'package:sinque/src/core/appLocator.dart';

class EventListener {
  late EventBus _eventBus;
  late List<StreamSubscription> _listeningEvents = [];

  void register() {
    _eventBus = AppLocator().eventBus;
  }

  Future<void> listen() async {
    register();

    _handleEvent<BroadcastServiceOpeningEvent>();
    _handleEvent<BroadcastServiceStartedEvent>();
    _handleEvent<BroadcastServiceStoppedEvent>();

    _handleEvent<DeviceConnectedEvent>();
    _handleEvent<DeviceDisconnectedEvent>();

    _handleEvent<DiscoveryServiceOpeningEvent>();
    _handleEvent<DiscoveryServiceReceivedDeviceEvent>();
    _handleEvent<DiscoveryServiceStartedEvent>();
    _handleEvent<DiscoveryServiceStoppedEvent>();

    _handleEvent<MyDeviceConnectedEvent>();

    _handleEvent<TCPServerOpeningEvent>();
    _handleEvent<TCPServerStartedEvent>();
    _handleEvent<TCPServerStoppedEvent>();

    _handleEvent<TCPClientConnectedEvent>();
    _handleEvent<TCPClientConnectingEvent>();
    _handleEvent<TCPClientDisconnectedEvent>();

    _handleEvent<PacketReceivedEvent>();
    _handleEvent<PacketSentEvent>();

    _handleEvent<TextReceivedEvent>();
    _handleEvent<TextSentEvent>();

    _handleEvent<PingReceivedEvent>();
    _handleEvent<PingSentEvent>();
    _handleEvent<PongReceivedEvent>();
    _handleEvent<PongSentEvent>();

    _handleEvent<SyncedItemsReceivedEvent>();

    // Old method --
    // eventBus.on<TextReceivedEvent>().listen((event) => event.listen());
    // eventBus.on<TextSentEvent>().listen((event) => event.listen());
  }

  void _handleEvent<T extends EventEmiter>() {
    StreamSubscription eventStreamSubscription =
        _eventBus.on<T>().listen((event) => event.listen());

    _listeningEvents.add(eventStreamSubscription);
  }

  dispose() {
    for (StreamSubscription eventStream in _listeningEvents) {
      eventStream.cancel();
    }

    _listeningEvents = [];
  }
}
