import 'package:event_bus/event_bus.dart';
import 'package:sinque/src/application/events/packetReceived.event.dart';
import 'package:sinque/src/application/events/packetSent.event.dart';
import 'package:sinque/src/application/events/textReceived.event.dart';
import 'package:sinque/src/application/events/textSent.event.dart';
import 'package:sinque/src/core/appLocator.dart';

class EventListener {
  void listen() {
    final EventBus eventBus = AppLocator().eventBus;

    eventBus.on<PacketReceivedEvent>().listen((event) => event.listen());
    eventBus.on<PacketSentEvent>().listen((event) => event.listen());
    eventBus.on<TextReceivedEvent>().listen((event) => event.listen());
    eventBus.on<TextSentEvent>().listen((event) => event.listen());
  }

  cancel() {
    final EventBus eventBus = AppLocator().eventBus;

    eventBus.destroy();
  }
}
