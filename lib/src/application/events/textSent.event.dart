import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/syncedItem.service.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/Packet.dart';

class TextSentEvent extends EventEmiter<TextSentEvent> {
  final Packet? _packet;
  final SyncedItem? _item;

  TextSentEvent({Packet? packet, SyncedItem? item})
      : _packet = packet,
        _item = item;

  @override
  void listen() {
    print('TextSentEvent.listen: ${packet.encode()}');

    SyncedItemService().add(item);
  }

  Packet get packet => _packet!;
  SyncedItem get item => _item!;
}
