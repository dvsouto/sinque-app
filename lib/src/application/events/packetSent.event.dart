import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/PingSent.event.dart';
import 'package:sinque/src/application/events/pongSent.event.dart';
import 'package:sinque/src/application/events/textSent.event.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/Packet.dart';

class PacketSentEvent extends EventEmiter<PacketSentEvent> {
  final Packet? _packet;

  PacketSentEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    if (packet.getType() == PacketType.textSent) {
      SyncedItem item = SyncedItem(
        type: 'text',
        content: packet.getMessage(),
        uuid: packet.getUuid(),
        device: packet.getDevice(),
      );

      TextSentEvent(packet: packet, item: item).dispatch();
    }

    if (packet.getType() == PacketType.ping) {
      PingSentEvent(packet: packet).dispatch();
    }

    if (packet.getType() == PacketType.pong) {
      PongSentEvent(packet: packet).dispatch();
    }
  }

  Packet get packet => _packet!;
}
