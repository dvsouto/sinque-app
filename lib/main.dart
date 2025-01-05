import 'package:flutter/material.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/presentation/app/app.widget.dart';
import 'package:sinque/src/infra/window/window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Window().initialize();

  await AppLocator().initialize();

  runApp(const App());
}
