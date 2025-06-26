import 'package:flutter/material.dart';

class App {
  static List artigos = [];
  static List audios = [];
  static Map artigo = {};

  static int ultimaPagina = 0;
  static int paginaAtual = 0;

  static ValueNotifier page = ValueNotifier(0);
}
