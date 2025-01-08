import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/presentation/home/widgets/ActionButton.widget.dart';
import 'package:sinque/src/presentation/home/widgets/BlinkingIcon.widget.dart';
import 'package:sinque/src/presentation/home/widgets/InputTextDialog.widget.dart';
import 'package:sinque/src/presentation/home/widgets/ListSyncedItem.widget.dart';
import 'package:sinque/src/presentation/keyboardHandler/keyboardHandler.widget.dart';

class HomeView extends ConsumerWidget {
  HomeView({super.key});

  // Widget _preview() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.asset(
  //           "assets/images/drag-and-drop.png",
  //           height: 512,
  //           width: 512,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = NetworkStatusService().watch(ref);
    final int networkDevicesCount =
        NetworkDevicesService().watch(ref).length + 1;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: Builder(
          builder: (context) => Padding(
            padding:
                Platform.isMacOS ? EdgeInsets.only(top: 16.0) : EdgeInsets.zero,
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sinque",
              style: TextStyle(fontWeight: FontWeight.w100),
            )
          ],
        ),
        actions: [
          Padding(
            padding: Platform.isWindows || Platform.isLinux
                ? EdgeInsets.only(right: 30.0)
                : EdgeInsets.zero,
            child: Row(
              children: [
                BlinkingIcon(
                  blinkActive: true,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Tooltip(
                      message:
                          "${networkStatus.isConnected() ? 'Connected' : 'Connecting'} to wifi server",
                      child: Icon(Icons.wifi),
                    ),
                  ),
                ),
                BlinkingIcon(
                  blinkActive: !networkStatus.isConnected(),
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Tooltip(
                        message:
                            "${networkStatus.isConnected() ? 'Connected' : 'Connecting'} to local network",
                        child: Badge(
                          label: Text(networkDevicesCount.toString()),
                          child: Icon(Icons.wifi_tethering),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: KeyboardHandler(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListSyncedItem(),
                ),
              ),
              Container(
                height: 140.0,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: ActionButton(
                        text: "Sync File",
                        icon: Icons.file_copy,
                        onPressed: () {
                          //   multicast.sendPacket(
                          //     PacketType.fileSent,
                          //     "Sync file..",
                          //   );

                          //   ref.read(syncedItemNotifierProvider.notifier).add(
                          //       SyncedItem(type: 'file', content: 'Lorem ipsum'));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: ActionButton(
                        text: "Sync Text",
                        icon: Icons.text_format,
                        onPressed: () => InputTextDialog.show(context),
                        // PacketService().sendTextToAllDevices("My text"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
