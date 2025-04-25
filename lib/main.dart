import 'package:flutter/material.dart';

import 'package:bands_name/pages/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bands Name App',
      initialRoute: 'home',
      routes: {'home': (_) => HomePage()},
    );
  }
}
