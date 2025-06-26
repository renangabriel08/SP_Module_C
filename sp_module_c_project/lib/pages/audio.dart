import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:sp_module_c_project/controllers/app.dart';
import 'package:sp_module_c_project/styles/styles.dart';
import 'package:sp_module_c_project/widgets/toast.dart';

class Audio extends StatefulWidget {
  const Audio({super.key});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  FlutterSoundPlayer player = FlutterSoundPlayer();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();

  Timer? timer;
  int tempo = 0;

  gravarAudio() async {
    if (recorder.isRecording) {
      timer?.cancel();

      String audio = await recorder.stopRecorder() ?? '';
      App.audios.insert(0, {
        'titulo': DateTime.now().millisecondsSinceEpoch.toString(),
        'desc': 'Descrição do audio',
        'path': audio,
      });

      setState(() {});
    } else {
      tempo = 0;

      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        tempo++;
        setState(() {});

        if (tempo == 60) {
          timer.cancel();

          String audio = await recorder.stopRecorder() ?? '';
          App.audios.insert(0, {
            'titulo': DateTime.now().millisecondsSinceEpoch.toString(),
            'desc': 'Descrição do audio',
            'path': audio,
          });

          setState(() {});
        }
      });

      await recorder.startRecorder(
        codec: Codec.aacMP4,
        toFile: '${DateTime.now().millisecondsSinceEpoch}.aac',
      );

      setState(() {});
    }
  }

  reproduzirAudio(String path) async {
    if (player.isPlaying) {
      MyToast.get('Não pode ouvir dois');
    } else {
      await player.startPlayer(codec: Codec.aacMP4, fromURI: path);
    }
  }

  @override
  void initState() {
    player.openPlayer();
    recorder.openRecorder();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Cores.branco,
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: App.audios.isEmpty
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (App.audios.isNotEmpty) Container(height: 24),
              LinearProgressIndicator(
                color: Cores.azulClaro,
                minHeight: 10,
                borderRadius: BorderRadius.circular(999),
                value: tempo / 60,
              ),
              Container(height: 16),
              if (App.audios.isEmpty)
                Text(
                  'Grave seus resumos e salve aqui',
                  style: TextStyle(color: Cores.preto, fontSize: 20),
                )
              else
                for (var audio in App.audios)
                  ListTile(
                    leading: IconButton(
                      onPressed: () => reproduzirAudio(audio['path']),
                      icon: Icon(Icons.play_arrow, color: Cores.preto),
                    ),
                    title: Text(
                      audio['titulo'],
                      style: TextStyle(color: Cores.preto),
                    ),
                    subtitle: Text(
                      audio['desc'],
                      style: TextStyle(color: Cores.preto),
                    ),
                    trailing: Icon(Icons.delete, color: Cores.preto),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => gravarAudio(),
        backgroundColor: Cores.azulClaro,
        child: Icon(
          Icons.mic,
          color: recorder.isRecording ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}
