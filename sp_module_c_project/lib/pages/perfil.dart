import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_module_c_project/controllers/app.dart';
import 'package:sp_module_c_project/styles/styles.dart';
import 'package:sp_module_c_project/widgets/toast.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  List itens = [
    {'titulo': 'Tema Escuro', 'icon': Icons.dark_mode, 'value': false},
    {'titulo': 'Alto Contraste', 'icon': Icons.contrast, 'value': false},
    {
      'titulo': 'Idioma: Português (automático)',
      'icon': Icons.language,
      'value': null,
    },
    {'titulo': 'Notificações', 'icon': Icons.notifications, 'value': false},
  ];

  File? img;

  foto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);

    if (photo != null) {
      img = File(photo.path);
    } else {
      MyToast.get('Nenhuma foto selecionada');
    }

    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        backgroundColor: Cores.branco,
        leading: IconButton(
          onPressed: () {
            App.page.value++;
            App.paginaAtual = App.ultimaPagina;
          },
          icon: Icon(Icons.arrow_back_ios, color: Cores.preto),
        ),
        title: Text('Perfil', style: TextStyle(color: Cores.preto)),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              width: 150,
              height: 150,
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Cores.preto),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(999),
                      child: img != null
                          ? Image.file(img!, fit: BoxFit.cover)
                          : Image.asset('assets/perfil.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cores.azulClaro,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Cores.branco,
                            content: Text(
                              'Selecione uma opção',
                              style: TextStyle(color: Cores.preto),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => foto(ImageSource.camera),
                                child: Text('Tirar foto'),
                              ),

                              TextButton(
                                onPressed: () => foto(ImageSource.gallery),
                                child: Text('Escolher da galeria'),
                              ),
                            ],
                          ),
                        ),
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => (),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  backgroundColor: Cores.azulMedio,
                ),
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text(
                  'Editar Perfil',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Text(
              'Configurações',
              style: TextStyle(
                color: Cores.preto,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (var item in itens)
              ListTile(
                title: Text(
                  item['titulo'],
                  style: TextStyle(color: Cores.preto),
                ),
                leading: Icon(item['icon'], color: Cores.preto),
                trailing: item['value'] != null
                    ? Switch(
                        value: item['value'],
                        onChanged: (value) {
                          item['value'] = !item['value'];

                          if (item['titulo'] == 'Tema Escuro') {
                            if (item['value']) {
                              Cores.preto = Color(0xFFFCFCFC);
                              Cores.branco = Color(0xFF101010);
                            } else {
                              Cores.preto = Color(0xFF101010);
                              Cores.branco = Color(0xFFFCFCFC);
                            }
                          }
                          App.page.value++;
                          setState(() {});
                        },
                      )
                    : Icon(Icons.arrow_forward_ios_rounded),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  backgroundColor: Cores.azulMedio,
                ),
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'Sair',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
