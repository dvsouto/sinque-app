import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/syncedItem.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/SyncedItem.dart';

class SyncedItemService {
  late final ProviderContainer _container;

  SyncedItemService() {
    _container = AppLocator().container;
  }

  void add(SyncedItem item) {
    _container.read(syncedItemNotifierProvider.notifier).add(item);
  }

  List<SyncedItem> read() {
    return _container.read(syncedItemNotifierProvider);
  }

  List<SyncedItem> watch(WidgetRef ref) {
    return ref.watch(syncedItemNotifierProvider);
  }
}
