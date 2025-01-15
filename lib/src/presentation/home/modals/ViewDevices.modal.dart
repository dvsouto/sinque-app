import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/Device.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/shared/device.util.dart';
import 'package:sinque/src/shared/network.util.dart';

class ViewDevicesModal extends ConsumerWidget {
  const ViewDevicesModal({super.key});

  static show(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 0,
            ),
            child: ViewDevicesModal(),
          );
        },
      );
    }
    // }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: ViewDevicesModal(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMobile = DeviceUtil.isMobile();

    double modalWidth = isMobile
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.75;

    double modalHeight = MediaQuery.of(context).size.height * 0.80;

    double modalBorderRadius = 16.0;

    return Container(
      height: modalHeight,
      width: modalWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(modalBorderRadius),
          topRight: Radius.circular(modalBorderRadius),
          bottomLeft:
              isMobile ? Radius.zero : Radius.circular(modalBorderRadius),
          bottomRight:
              isMobile ? Radius.zero : Radius.circular(modalBorderRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 80.0,
                    child: _top(),
                  ),
                  Expanded(
                    child: _content(),
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Placeholder(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _top() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(Icons.wifi_tethering),
        ),
        Text(
          "Hotspot",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _content() {
    return FutureBuilder<DeviceConnection>(
      future: _getMyDevice(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        }

        List<DeviceConnection> devices = [
          snapshot.data!,
          ...NetworkDevicesService().read(),
        ];

        // devices.adrd(snapshot.data!);

        return ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            DeviceConnection device = devices[index];
            IconData deviceIcon = Icons.desktop_windows;

            if (device.device.getType() == DeviceType.Desktop) {
              deviceIcon = Icons.desktop_windows;
            }

            if (device.device.getType() == DeviceType.Mobile) {
              deviceIcon = Icons.smartphone_outlined;
            }

            if (device.device.getType() == DeviceType.Web) {
              deviceIcon = Icons.public;
            }

            return SizedBox(
              height: 82.0,
              width: 100.0,
              child: Row(
                children: [
                  SizedBox(
                    width: 80.0,
                    child: Center(
                      child: Icon(deviceIcon),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                device.device.getName() ??
                                    device.network.getHostname(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                )),
                            Text(
                              device.network.getAddress(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<DeviceConnection> _getMyDevice() async {
    return DeviceConnection(
      device: await DeviceUtil.retrieve(),
      network: await NetworkUtil.retrieve(),
    );
  }
}
