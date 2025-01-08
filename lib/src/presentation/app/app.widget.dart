import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinque/src/core/appLocator.dart';

import 'package:sinque/src/presentation/home/home.view.dart';
import 'package:sinque/src/presentation/themes/appTheme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      parent: AppLocator().container,
      child: MaterialApp(
        title: "Sinque",
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: HomeView(),
        ),
      ),
    );
  }
}
