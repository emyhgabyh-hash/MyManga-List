import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Aguarda alguns segundos antes de abrir a tela de login
    Future.delayed(const Duration(seconds: 2), () {

      // Verifica se a tela ainda está aberta antes de navegar
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(), // Abre a tela de login NAVEGAÇÃO
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( // Estrutura principal da tela LAYOUT

      body: Center( // Centraliza os elementos LAYOUT

        child: Column( // Organiza os widgets verticalmente LAYOUT
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os widgets na tela

          children: [

            Icon(
              Icons.menu_book, // Ícone do aplicativo LAYOUT
              size: 100,
              color: Color.fromARGB(255, 81, 49, 134),
            ),

            SizedBox(height: 20), // Espaçamento entre widgets LAYOUT

            Text(
              "MyManga List",
              style: GoogleFonts.modak( // Fonte personalizada LAYOUT
                fontSize: 42,
                color: Color.fromARGB(255, 81, 49, 134),
              ),
            ),

            SizedBox(height: 10), // Espaçamento LAYOUT

            Text(
              "Sua biblioteca de mangás",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 81, 49, 134),
              ),
            ),
          ],
        ),
      ),
    );
  }
}