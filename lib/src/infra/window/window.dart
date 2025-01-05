import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

class Window {
  void initialize() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Sinque");
      setWindowMinSize(Size(800, 600));
    }
  }
}
