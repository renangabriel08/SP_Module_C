import 'package:flutter/material.dart';
import 'package:sp_module_c_project/pages/app.dart';
import 'package:sp_module_c_project/pages/detalhes.dart';
import 'package:sp_module_c_project/pages/login.dart';
import 'package:sp_module_c_project/pages/splash.dart';
import 'package:sp_module_c_project/styles/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Cores.azulClaro),
        fontFamily: 'Montserrat',
      ),
      routes: {
        '/home': (context) => const AppPage(),
        '/login': (context) => const Login(),
        '/splash': (context) => const Splash(),
        '/detalhes': (context) => const Detalhes(),
      },
      initialRoute: '/splash',
    );
  }
}
