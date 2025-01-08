import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/PingReceived.event.dart';
import 'package:sinque/src/application/events/pongReceived.event.dart';
import 'package:sinque/src/application/events/textReceived.event.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/Packet.dart';

class PacketReceivedEvent extends EventEmiter<PacketReceivedEvent> {
  final Packet? _packet;

  PacketReceivedEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    if (packet.getType() == PacketType.textSent) {
      SyncedItem item = SyncedItem(
        type: 'text',
        content: packet.getMessage(),
        uuid: packet.getUuid(),
        device: packet.getDevice(),
      );

      TextReceivedEvent(packet: packet, item: item).dispatch();
    }

    if (packet.getType() == PacketType.ping) {
      PingReceivedEvent(packet: packet).dispatch();
    }

    if (packet.getType() == PacketType.pong) {
      PongReceivedEvent(packet: packet).dispatch();
    }
  }

  Packet get packet => _packet!;
}
