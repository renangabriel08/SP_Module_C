import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_module_c_project/styles/styles.dart';
import 'package:sp_module_c_project/widgets/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List inputs = [
    {'controller': TextEditingController(), 'focus': FocusNode()},
    {'controller': TextEditingController(), 'focus': FocusNode()},
    {'controller': TextEditingController(), 'focus': FocusNode()},
    {'controller': TextEditingController(), 'focus': FocusNode()},
  ];

  var formKey = GlobalKey<FormState>();

  Color cor = Cores.preto;

  logar() {
    if (formKey.currentState!.validate()) {
      String pin = '';
      for (var i in inputs) {
        pin += i['controller'].text;
      }

      if (pin == '3245') {
        MyToast.get('Login realizado com sucesso');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        MyToast.get('Pin incorreto');
        cor = Colors.red;
        setState(() {});

        Future.delayed(
          const Duration(seconds: 1),
          () => setState(() {
            cor = Cores.preto;
          }),
        );

        for (var i in inputs) {
          i['controller'].clear();
        }
      }
    } else {
      MyToast.get('Todos os campos são obrigatórios');
    }
  }

  startApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tempo', 3);
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => FocusScope.of(context).requestFocus(inputs.first['focus']),
    );
    startApp();
    super.initState();
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
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 150),
                Container(height: 8),
                Text(
                  'Digite seu PIN de acesso',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Cores.preto,
                  ),
                ),
                Container(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var input in inputs)
                      Container(
                        width: 60,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Cores.preto),
                          controller: input['controller'],
                          focusNode: input['focus'],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 1,
                          buildCounter:
                              (
                                context, {
                                required currentLength,
                                required isFocused,
                                required maxLength,
                              }) => null,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '!';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: cor),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Container(height: 16),
                ElevatedButton(
                  onPressed: () => logar(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    backgroundColor: Cores.azulClaro,
                  ),
                  child: Text('Entrar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
