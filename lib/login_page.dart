import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_manga_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Estrutura principal da tela

      appBar: AppBar( // Barra superior LAYOUT

        title: Text(
          "Entrar",
          style: GoogleFonts.modak(), // Fonte personalizada LAYOUT
        ),
       ),

      body: Padding( // Espaçamento interno LAYOUT

        padding: const EdgeInsets.all(24.0),

        child: Column( // Organiza widgets verticalmente LAYOUT

          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os widgets LAYOUT

          children: [
            Text(
              "MyManga List",
              style: GoogleFonts.modak( // Fonte personalizada LAYOUT
                fontSize: 36,
                color: const Color.fromARGB(255, 81, 49, 134),
              ),
            ),

            const SizedBox(height: 40), // Espaçamento LAYOUT

            TextField( // Campo de texto para email INPUT

              decoration: const InputDecoration(

                labelText: "Email", // Nome do campo INPUT

                border: OutlineInputBorder(), // Borda do campo LAYOUT
              ),
            ),

            const SizedBox(height: 20), // Espaçamento LAYOUT

            TextField( // Campo de senha INPUT

              obscureText: true, // Esconde os caracteres digitados INPUT

              decoration: const InputDecoration(

                labelText: "Senha",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30), // Espaçamento LAYOUT

            SizedBox( // Define a largura LAYOUT

              width: double.infinity, // Faz o botão ocupar toda largura

              child: ElevatedButton( // Botão clicável INPUT

                onPressed: () {

                  Navigator.push( // Navega para outra tela NAVEGAÇÃO

                    context,

                    MaterialPageRoute( // Define qual tela abrir NAVEGAÇÃO

                      builder: (context) => const HomeMangaPage(), // Abre a HomeMangaPage NAVEGAÇÃO
                    ),
                  );
                },
                child: const Text("Entrar"),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}