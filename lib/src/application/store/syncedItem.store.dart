import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/domain/SyncedItem.dart';

class SyncedItemNotifier extends StateNotifier<List<SyncedItem>> {
  SyncedItemNotifier() : super(List.empty());

  void add(SyncedItem item) {
    state = [...state, item];
  }
}

final syncedItemNotifierProvider =
    StateNotifierProvider<SyncedItemNotifier, List<SyncedItem>>(
        (ref) => SyncedItemNotifier());
