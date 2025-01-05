import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/events/textReceived.event.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/UDPPacket.dart';

class PacketReceivedEvent extends EventEmiter<PacketReceivedEvent> {
  final UDPPacket? _packet;

  PacketReceivedEvent({UDPPacket? packet}) : _packet = packet;

  @override
  void listen() {
    if (packet.getType() == UDPPacketType.textSent) {
      SyncedItem item = SyncedItem(
        type: 'text',
        content: packet.getMessage(),
        uuid: packet.getUuid(),
        device: packet.getDevice(),
      );

      TextReceivedEvent(packet: packet, item: item).dispatch();
    }
  }

  UDPPacket get packet => _packet!;
}
