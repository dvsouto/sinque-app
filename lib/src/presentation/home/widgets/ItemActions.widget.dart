import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sinque/src/domain/SyncedItem.dart';

class ItemActions extends StatelessWidget {
  final SyncedItem item;

  const ItemActions({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        _itemActionButton(
          icon: Icons.favorite,
          onPressed: () {},
        ),
        _itemActionButton(
          icon: Icons.download,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _itemActionButton({required onPressed, required IconData icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 11.0,
        constraints: BoxConstraints(maxHeight: 28, maxWidth: 28),
        onPressed: onPressed,
      ),
    );
  }
}
