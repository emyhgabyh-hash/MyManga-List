import 'package:flutter/material.dart';   // Biblioteca principal do Flutter (widgets, botões, telas, ícones)
import 'package:google_fonts/google_fonts.dart';  // Pacote usado para aplicar fontes personalizadas
import 'splash_screen.dart'; // Importa a SplashScreen para iniciar o aplicativo


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget sem alteração dinâmica
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Cria a estrutura principal da tela LAYOUT
      debugShowCheckedModeBanner: false,

      title: 'MyManga List',

      theme: ThemeData( // Tema global do aplicativo LAYOUT
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 233, 218), // Cor de fundo das telas

        primaryColor: Color(0xFF7E57C2), // Cor principal do app

        appBarTheme: AppBarTheme( // Tema da AppBar padrão LAYOUT
          backgroundColor: Color.fromARGB(255, 81, 49, 134), // Fundo da AppBar
          foregroundColor: const Color.fromARGB(255, 241, 233, 218), // Cor dos textos e ícones
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom( // Estilo padrão dos botões LAYOUT
            backgroundColor: Color.fromARGB(255, 81, 49, 134),
            foregroundColor: const Color.fromARGB(255, 241, 233, 218),
          ),
        ),
      ),

      home: const SplashScreen(), // Define a SplashScreen como primeira tela NAVEGAÇÃO
    );
  }
}