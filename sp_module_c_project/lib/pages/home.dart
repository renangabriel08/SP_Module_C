import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_module_c_project/controllers/app.dart';
import 'package:sp_module_c_project/styles/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int slide = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        backgroundColor: Cores.branco,
        title: Text('Olá, Estudante!'),
        actions: [
          IconButton(onPressed: () => (), icon: Icon(Icons.notifications)),
        ],
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: height * .23,
              child: Column(
                children: [
                  CarouselSlider(
                    items: [
                      for (var artigo in App.artigos)
                        Container(
                          width: width,
                          height: height * .18,
                          color: Cores.azulClaro,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                artigo['titulo'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Container(height: 16),
                              ElevatedButton(
                                onPressed: () => (),
                                child: Text('Começar agora'),
                              ),
                            ],
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      height: height * .18,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      onPageChanged: (index, reason) => setState(() {
                        slide = index;
                      }),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Container(height: 10),
                  DotsIndicator(
                    dotsCount: App.artigos.length,
                    position: slide.toDouble(),
                    decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: Cores.azulClaro,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              width: width,
              height: height * .53,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Artigos',
                      style: TextStyle(color: Cores.preto, fontSize: 24),
                    ),
                    for (var artigo in App.artigos)
                      ListTile(
                        onTap: () => Navigator.pushNamed(context, '/detalhes'),
                        title: Text(
                          artigo['titulo'],
                          style: TextStyle(color: Cores.preto),
                        ),
                        subtitle: Text(
                          artigo['descricao'],
                          style: TextStyle(color: Cores.preto),
                        ),
                        trailing: Text(
                          artigo['data'],
                          style: TextStyle(color: Cores.preto),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
