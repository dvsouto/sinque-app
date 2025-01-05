import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/application/services/packet.service.dart';
import 'package:sinque/src/presentation/home/widgets/ActionButton.widget.dart';
import 'package:sinque/src/presentation/home/widgets/BlinkingIcon.widget.dart';
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

  Widget udpConnectionIcon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(Icons.wifi_calling),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = NetworkStatusService().watch(ref);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sinque",
              style: TextStyle(fontWeight: FontWeight.w100),
            ),
          ],
        ),
        actions: [
          BlinkingIcon(
            blinkActive: !networkStatus.isConnected(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Tooltip(
                message: "Connecting to local network",
                child: Icon(Icons.wifi_find_outlined),
              ),
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
                color: Colors.blue,
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
                padding: EdgeInsets.all(8.0),
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
                          //     UDPPacketType.fileSent,
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
                        onPressed: () => PacketService().sendText("My text"),
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
