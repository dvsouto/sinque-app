import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/syncedItem.service.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/domain/Packet.dart';

class SyncedItemsReceivedEvent extends EventEmiter<SyncedItemsReceivedEvent> {
  final Packet? _packet;
  final List<SyncedItem>? _items;

  SyncedItemsReceivedEvent({Packet? packet, List<SyncedItem>? items})
      : _packet = packet,
        _items = items;

  @override
  void listen() {
    final syncedItemService = SyncedItemService();

    syncedItemService.sync(items);
  }

  Packet get packet => _packet!;
  List<SyncedItem> get items => _items!;
}
