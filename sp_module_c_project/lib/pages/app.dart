import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_module_c_project/controllers/app.dart';
import 'package:sp_module_c_project/pages/audio.dart';
import 'package:sp_module_c_project/pages/home.dart';
import 'package:sp_module_c_project/pages/perfil.dart';
import 'package:sp_module_c_project/styles/styles.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  startApp() async {
    await [Permission.microphone].request();

    String jsonArtigos = await rootBundle.loadString('assets/artigos.json');
    String detalhes = await rootBundle.loadString('assets/detalhes.json');

    App.artigos = jsonDecode(jsonArtigos);
    App.artigo = jsonDecode(detalhes);

    setState(() {});
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: App.artigos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: App.page,
              builder: (context, value, child) => IndexedStack(
                index: App.paginaAtual,
                children: [Home(), Audio(), Perfil()],
              ),
            ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: App.page,
        builder: (context, value, child) => BottomNavigationBar(
          currentIndex: App.paginaAtual,
          onTap: (value) => setState(() {
            App.ultimaPagina = App.paginaAtual;
            App.paginaAtual = value;
            App.page.value++;
          }),
          backgroundColor: Cores.branco,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Cores.azulClaro,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Resumos'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
