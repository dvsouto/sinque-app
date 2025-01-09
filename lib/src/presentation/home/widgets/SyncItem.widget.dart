import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';

import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/SyncedItem.dart';
import 'package:sinque/src/presentation/home/widgets/ActionTimeDisplay.widget.dart';
import 'package:sinque/src/presentation/home/widgets/ItemActions.widget.dart';
import 'package:sinque/src/presentation/themes/appTheme.dart';
import 'package:sinque/src/shared/device.util.dart';
import 'package:sinque/src/shared/network.util.dart';

class SyncItem extends StatelessWidget {
  final SyncedItem item;

  const SyncItem({super.key, required this.item});

  final double _boxHeight = 82.0;

  void handleItemPress() async {
    final devices = NetworkDevicesService().read();
    print("@devices: ${devices.map((d) => d.encode())}");
    print("me: ${(await NetworkUtil.retrieve()).encode()}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: SizedBox(
        height: _boxHeight,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.dark,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                _LeftSyncItem(
                    boxHeight: _boxHeight,
                    item: item,
                    handleItemPress: handleItemPress),
                _RightSyncItem(item: item, handleItemPress: handleItemPress)
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
  final Function handleItemPress;

  const _LeftSyncItem({
    required this.boxHeight,
    required this.item,
    required this.handleItemPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxHeight - (DeviceUtil.isMobile() ? 36.0 : 12.0),
      child: InkWell(
        onTap: () => handleItemPress(),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(
            Icons.title,
            size: DeviceUtil.isMobile() ? 20.0 : 28.0,
          ),
        ),
      ),
    );
  }
}

class _RightSyncItem extends StatelessWidget {
  final SyncedItem item;
  final Function handleItemPress;

  const _RightSyncItem({required this.item, required this.handleItemPress});

  @override
  Widget build(BuildContext context) {
    IconData syncItemIcon = Icons.desktop_windows;

    if (item.device.getType() == DeviceType.Desktop) {
      syncItemIcon = Icons.desktop_windows;
    }

    if (item.device.getType() == DeviceType.Mobile) {
      syncItemIcon = Icons.smartphone_outlined;
    }

    if (item.device.getType() == DeviceType.Web) {
      syncItemIcon = Icons.public;
    }

    int maxTextLength = DeviceUtil.isDesktop() ? 240 : 60;

    String textContent = item.content.length > maxTextLength
        ? item.content.substring(0, maxTextLength)
        : item.content;

    return Flexible(
      fit: FlexFit.tight,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          child: InkWell(
            onTap: () => handleItemPress(),
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
                                Visibility(
                                  visible: DeviceUtil.isDesktop(),
                                  child: Text(
                                    'sended a text',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Wrap(
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: DeviceUtil.isMobile() ? 1 : 2,
                                  textContent,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ActionTimeDisplay(actionTime: item.syncedAt),
                      Expanded(
                        child: ItemActions(item: item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
