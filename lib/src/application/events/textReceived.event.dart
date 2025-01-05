import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/syncedItem.service.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/UDPPacket.dart';

class TextReceivedEvent extends EventEmiter<TextReceivedEvent> {
  final UDPPacket? _packet;
  final SyncedItem? _item;

  TextReceivedEvent({UDPPacket? packet, SyncedItem? item})
      : _packet = packet,
        _item = item;

  @override
  void listen() {
    print("TextReceivedEvent.listen");

    SyncedItemService().add(item);
  }

  UDPPacket get packet => _packet!;
  SyncedItem get item => _item!;
}
