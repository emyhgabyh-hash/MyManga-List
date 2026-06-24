import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMangaPage extends StatelessWidget {
  const HomeMangaPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<String> mangas = [ // Lista de mangás que aparece na tela
      "One Piece",
      "Naruto",
      "Attack on Titan",
      "Demon Slayer",
      "Jujutsu Kaisen",
    ];

    return Scaffold( // Estrutura principal da tela LAYOUT

      appBar: AppBar( // Barra superior LAYOUT

        automaticallyImplyLeading: false, // Remove seta automática de voltar LAYOUT

        title: Text(
          "Meus Mangás",
          style: GoogleFonts.modak(), // Fonte personalizada LAYOUT
        ),

        actions: [ // Widgets no canto direito da AppBar LAYOUT

          IconButton( // Botão clicável de logout INPUT
            onPressed: () {

              Navigator.pop(context); // Volta para tela anterior NAVEGAÇÃO
            },

            icon: const Icon(Icons.logout), // Ícone de logout LAYOUT
          ),
        ],
      ),

      body: Padding( // Espaçamento interno nas bordas LAYOUT

        padding: const EdgeInsets.all(16),

        child: ListView.builder(// Cria lista dinâmica LAYOUT

          itemCount: mangas.length,// Quantidade de itens LAYOUT

          itemBuilder: (context, index) {// Constrói cada item da lista LAYOUT 

            return Card( // Card visual para cada mangá LAYOUT

              margin: const EdgeInsets.only(bottom: 15), // Espaçamento entre os cards LAYOUT

              child: ListTile( // Widget pronto para aparecer na lista LAYOUT
                leading: const Icon(

                  Icons.menu_book, // Ícone do mangá LAYOUT
                  color: Color.fromARGB(255, 81, 49, 134),
                ),

                title: Text(
                  mangas[index], // Mostra o nome do mangá LAYOUT
                ),

                subtitle: const Text( // Texto abaixo do titulo LAYOUT
                  "Mangá adicionado à lista",
                ),

                trailing: Row( // Organiza widgets horizontalmente LAYOUT

                  mainAxisSize: MainAxisSize.min, // Faz Row ocupar apenas espaço necessário

                  children: [

                    IconButton( // Botão favorito INPUT

                      onPressed: () {

                      },

                      icon: const Icon( // Icone de estrela INPUT
                        Icons.star,
                        color: Color.fromARGB(255, 255, 191, 0),
                      ),
                    ),

                    IconButton(// Botão de leitura INPUT

                      onPressed: () {

                      },

                      icon: const Icon( // Icone de livro INPUT
                        Icons.auto_stories,
                        color: Color.fromARGB(255, 31, 92, 33),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton( // Botão de adicionar INPUT

        backgroundColor: const Color.fromARGB(255, 81, 49, 134),
        
        onPressed: () {

        },

        child: const Icon( // Ícone de adicionar LAYOUT
          Icons.add, 
          color: Colors.white,
        ),
      ),
    );
  }
}