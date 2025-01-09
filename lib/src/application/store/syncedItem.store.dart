import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/shared/sync.util.dart';

class SyncedItemNotifier extends StateNotifier<List<SyncedItem>> {
  SyncedItemNotifier() : super(List.empty());

  void add(SyncedItem item) {
    final updatedState = [...state, item];

    if (updatedState.length > SyncUtil.maxSyncItens) {
      updatedState.removeAt(0);
    }

    state = updatedState;
  }

  void addMany(List<SyncedItem> itens) {
    final updatedState = [...state, ...itens];

    if (updatedState.length > SyncUtil.maxSyncItens) {
      updatedState.removeRange(0, updatedState.length - SyncUtil.maxSyncItens);
    }

    state = updatedState;
  }

  void sync(List<SyncedItem> clientItens) {
    List<SyncedItem> toAdd = [];

    for (SyncedItem clientItem in clientItens) {
      if (!exists(clientItem)) {
        toAdd.add(clientItem);
      }
    }

    if (toAdd.isNotEmpty) {
      addMany(clientItens);
    }
  }

  bool exists(SyncedItem item) {
    return state.any((itItem) => itItem.equals(item));
  }
}

final syncedItemNotifierProvider =
    StateNotifierProvider<SyncedItemNotifier, List<SyncedItem>>(
        (ref) => SyncedItemNotifier());
