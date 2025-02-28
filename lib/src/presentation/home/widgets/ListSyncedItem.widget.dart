import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/services/syncedItem.service.dart';
import 'package:sinque/src/presentation/home/widgets/SyncItem.widget.dart';

class ListSyncedItem extends ConsumerWidget {
  const ListSyncedItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncedItens = SyncedItemService().watch(ref).reversed.toList();

    if (syncedItens.isEmpty) {
      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Text("No data shared"),
        ),
      );
    }

    return ListView.builder(
      itemCount: syncedItens.length,
      itemBuilder: (context, index) {
        final item = syncedItens[index];

        return SyncItem(item: item);
      },
    );
  }
}
