import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/textSent.event.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/UDPPacket.dart';

class PacketSentEvent extends EventEmiter<PacketSentEvent> {
  final UDPPacket? _packet;

  PacketSentEvent({UDPPacket? packet}) : _packet = packet;

  @override
  void listen() {
    if (packet.getType() == UDPPacketType.textSent) {
      SyncedItem item = SyncedItem(
        type: 'text',
        content: packet.getMessage(),
        uuid: packet.getUuid(),
        device: packet.getDevice(),
      );

      TextSentEvent(packet: packet, item: item).dispatch();
    }
  }

  UDPPacket get packet => _packet!;
}
