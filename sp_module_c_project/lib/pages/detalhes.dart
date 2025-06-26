import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sp_module_c_project/controllers/app.dart';
import 'package:sp_module_c_project/styles/styles.dart';
import 'package:sp_module_c_project/widgets/toast.dart';
import 'package:video_player/video_player.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  double fontSize = 16;
  late VideoPlayerController _controller;
  ValueNotifier modal = ValueNotifier(0);
  double brilho = 0;

  startApp() async {
    brilho = await ScreenBrightness.instance.system;
    setState(() {});
  }

  @override
  void initState() {
    startApp();
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(brilho);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        backgroundColor: Cores.branco,
        automaticallyImplyLeading: true,
        title: Text(App.artigo['titulo']),
        foregroundColor: Cores.preto,
        actions: [IconButton(onPressed: () => (), icon: Icon(Icons.share))],
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width,
                height: height * .7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            App.artigo['descricao'],
                            style: TextStyle(
                              color: Cores.preto,
                              fontSize: fontSize,
                            ),
                          ),
                          Text(
                            App.artigo['data'],
                            style: TextStyle(
                              color: Cores.preto,
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                      Container(height: 16),
                      SizedBox(
                        width: width,
                        height: height * .22,
                        child: _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                            : Container(),
                      ),
                      Container(height: 16),
                      Text(
                        App.artigo['conteudo'],
                        style: TextStyle(
                          color: Cores.preto,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height * .12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => (),
                          icon: Icon(Icons.settings, color: Cores.preto),
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ValueListenableBuilder(
                              valueListenable: modal,
                              builder: (context, value, child) => AlertDialog(
                                backgroundColor: Cores.branco,
                                content: Text(
                                  'Tamanho da fonte',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Cores.preto,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => setState(() {
                                      fontSize = 14;
                                      modal.value++;
                                    }),
                                    child: Text(
                                      'Pequeno',
                                      style: TextStyle(fontSize: fontSize),
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () => setState(() {
                                      fontSize = 16;
                                      modal.value++;
                                    }),
                                    child: Text(
                                      'Medio',
                                      style: TextStyle(fontSize: fontSize),
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () => setState(() {
                                      fontSize = 20;
                                      modal.value++;
                                    }),
                                    child: Text(
                                      'Grande',
                                      style: TextStyle(fontSize: fontSize),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.text_fields_rounded,
                            color: Cores.preto,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          }),
                          child: Text('Ouvir artigo'),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.dark_mode, color: Cores.preto),
                        Container(
                          width: width * .7,
                          child: Slider(
                            max: 0.7,
                            min: 0,
                            value: brilho,
                            onChanged: (value) async {
                              brilho = value;
                              setState(() {});
                              try {
                                await ScreenBrightness.instance
                                    .setSystemScreenBrightness(brilho);
                              } catch (e) {
                                MyToast.get('Permita alterar o brilho');
                              }
                            },
                          ),
                        ),
                        Icon(Icons.light_mode, color: Cores.preto),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
