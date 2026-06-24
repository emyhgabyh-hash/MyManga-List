import 'package:flutter/material.dart';   // Biblioteca principal do Flutter (widgets, botões, telas, ícones)
import 'package:google_fonts/google_fonts.dart';   // Pacote usado para aplicar fontes personalizadas
import 'login_page.dart'; // Importa a tela de login para navegação

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget { // Widget sem alteração dinâmica
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

        home: HomePage(), // Define a tela inicial NAVEGAÇÃO
      );
    }
  }

  class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

      return Scaffold( // Estrutura principal da tela LAYOUT

        appBar: AppBar( // Barra superior LAYOUT

          title: Text(
            "MyManga List",

            style: GoogleFonts.modak( // Fonte personalizada LAYOUT
              fontSize: 24,
              color: const Color.fromARGB(255, 241, 233, 218),
            ),
          ),
        ),

        body: Center( // Centraliza os elementos LAYOUT

          child: Column( // Organiza widgets verticalmente LAYOUT

            mainAxisAlignment: MainAxisAlignment.center, // Centraliza os widgets na tela

            children: [

              Icon(
                Icons.menu_book, // Ícone da biblioteca Material Icons LAYOUT
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

              SizedBox(height: 40), // Espaçamento LAYOUT

              ElevatedButton( // Botão clicável INPUT

                onPressed: () {

                  Navigator.push( // Navegação para outra tela NAVEGAÇÃO

                    context,

                    MaterialPageRoute( // Define a rota da próxima página NAVEGAÇÃO

                      builder: (context) => LoginPage(), // Abre a LoginPage NAVEGAÇÃO
                    ),
                  );
                },

                child: Text("Entrar"),
              ),

              SizedBox(height: 20),

              ElevatedButton( // Segundo botão clicável INPUT

                onPressed: () {

                },
                child: Text("Criar Conta"),
              ),
            ],
          ),
        ),
      );
    }
  }