import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/syncedItem.service.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/Packet.dart';

class TextReceivedEvent extends EventEmiter<TextReceivedEvent> {
  final Packet? _packet;
  final SyncedItem? _item;

  TextReceivedEvent({Packet? packet, SyncedItem? item})
      : _packet = packet,
        _item = item;

  @override
  void listen() {
    print("TextReceivedEvent.listen");

    SyncedItemService().add(item);
  }

  Packet get packet => _packet!;
  SyncedItem get item => _item!;
}
