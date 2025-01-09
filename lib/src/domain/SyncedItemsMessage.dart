import 'package:sinque/src/core/packetMessage.dart';
import 'package:sinque/src/domain/SyncedItem.dart';

class SyncedItemsMessage extends PacketMessage<SyncedItemsMessage> {
  final List<SyncedItem> itens;

  SyncedItemsMessage({List<SyncedItem>? itens}) : itens = itens ?? [];

  @override
  Map<String, dynamic> encodeMessage() {
    final itemsMap = itens.map((item) => item.toMap()).toList();

    return {'itens': itemsMap};
  }

  @override
  SyncedItemsMessage decodeMessage(dynamic data) {
    List<SyncedItem> decodedItems = [];

    for (dynamic rawItem in data['itens']) {
      decodedItems.add(SyncedItem.decode(rawItem));
    }

    return SyncedItemsMessage(itens: decodedItems);
  }
}
