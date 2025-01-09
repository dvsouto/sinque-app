import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/store/syncedItem.store.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/SyncedItem.dart';

class SyncedItemService {
  late final ProviderContainer _container;

  SyncedItemService() {
    _container = AppLocator().container;
  }

  /// Add shared item
  void add(SyncedItem item) {
    _container.read(syncedItemNotifierProvider.notifier).add(item);
  }

  /// Add many itens to list
  void addMany(List<SyncedItem> clientItens) {
    _container.read(syncedItemNotifierProvider.notifier).addMany(clientItens);
  }

  /// Sync the device itens with the other device itens
  void sync(List<SyncedItem> clientItens) {
    _container.read(syncedItemNotifierProvider.notifier).sync(clientItens);
  }

  /// Returns true if the item exists in the list of synced itens
  bool exists(SyncedItem item) {
    return _container.read(syncedItemNotifierProvider.notifier).exists(item);
  }

  /// Read the notifier
  List<SyncedItem> read() {
    return _container.read(syncedItemNotifierProvider);
  }

  /// Watch the notifier
  List<SyncedItem> watch(WidgetRef ref) {
    return ref.watch(syncedItemNotifierProvider);
  }

  /// State of notifier
  List<SyncedItem> get state => read();
}
