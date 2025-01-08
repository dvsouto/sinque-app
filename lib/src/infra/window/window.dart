import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:window_manager/window_manager.dart';

class Window {
  Future<void> initialize() async {
    if (Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isFuchsia) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
        size: Size(800, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        windowButtonVisibility: true,
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}
