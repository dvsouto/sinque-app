import 'package:flutter/material.dart';

import 'package:sinque/src/presentation/home/home.view.dart';
import 'package:sinque/src/presentation/themes/appTheme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sinque",
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
