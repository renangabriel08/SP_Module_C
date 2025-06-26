import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_module_c_project/styles/styles.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation angle;

  animar() async {
    await rodar(0, 6.28 / 4);
    await Future.delayed(const Duration(milliseconds: 400));
    await rodar(6.28 / 4, ((6.28 / 4) * 2));
    await Future.delayed(const Duration(milliseconds: 400));
    await rodar(6.28 / 2, ((6.28 / 4) * 3));
    await Future.delayed(const Duration(milliseconds: 400));
    await rodar(((6.28 / 4) * 3), 6.28);
  }

  rodar(double begin, double end) async {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    angle = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    controller.addListener(() => setState(() {}));
    await controller.forward();
  }

  startApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int tempo = prefs.getInt('tempo') ?? 5;

    Future.delayed(
      Duration(seconds: tempo),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      ),
    );
  }

  @override
  void initState() {
    animar();
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: SweepGradient(
            transform: GradientRotation(angle.value),
            colors: [Cores.azulClaro, Cores.azulMedio],
          ),
        ),
        child: Center(child: Image.asset('assets/logo2.png', height: 150)),
      ),
    );
  }
}
