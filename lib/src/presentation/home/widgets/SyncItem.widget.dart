import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/SyncedItem.dart';

class SyncItem extends StatelessWidget {
  final SyncedItem item;

  const SyncItem({super.key, required this.item});

  final double _boxHeight = 82.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: SizedBox(
        height: _boxHeight,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF474747),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                _LeftSyncItem(boxHeight: _boxHeight, item: item),
                _RightSyncItem(item: item)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeftSyncItem extends StatelessWidget {
  final double boxHeight;
  final SyncedItem item;

  const _LeftSyncItem({super.key, required this.boxHeight, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxHeight - 12.0,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(
          Icons.title,
          size: 28.0,
        ),
      ),
    );
  }
}

class _RightSyncItem extends StatelessWidget {
  final SyncedItem item;

  const _RightSyncItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    IconData syncItemIcon = Icons.desktop_windows;
    final String syncedAt = DateFormat.yMd().add_jm().format(item.syncedAt);

    if (item.device.getType() == DeviceType.Desktop) {
      syncItemIcon = Icons.desktop_windows;
    }

    if (item.device.getType() == DeviceType.Mobile) {
      syncItemIcon = Icons.smartphone_outlined;
    }

    if (item.device.getType() == DeviceType.Web) {
      syncItemIcon = Icons.public;
    }

    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                flex: 70,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(
                              syncItemIcon,
                              size: 14.0,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              item.device.getName() ??
                                  item.device.getModel() ??
                                  'unknown',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              'sended a text',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w100,
                              ),
                            )
                          ],
                        ),
                        Text(
                          item.content,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 30,
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    syncedAt,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
