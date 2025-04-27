import 'package:bands_name/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bands_name/pages/home.dart';
import 'package:bands_name/pages/status.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bands Name App',
        initialRoute: 'status',
        routes: {
          'home': (_) => const HomePage(),
          'status': (_) => const StatusPage(),
        },
      ),
    );
  }
}
