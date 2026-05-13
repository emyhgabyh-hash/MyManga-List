import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMangaPage extends StatelessWidget {
  const HomeMangaPage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> mangas = [
      "One Piece",
      "Naruto",
      "Attack on Titan",
      "Demon Slayer",
      "Jujutsu Kaisen",
    ];

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "Meus Mangás",
          style: GoogleFonts.modak(),
        ),

        actions: [

          IconButton(

            onPressed: () {

              Navigator.pop(context);

            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView.builder(

          itemCount: mangas.length,

          itemBuilder: (context, index) {

            return Card(

              margin: const EdgeInsets.only(bottom: 15),

              child: ListTile(

                leading: const Icon(
                  Icons.menu_book,
                  color: Color.fromARGB(255, 81, 49, 134),
                ),

                title: Text(
                  mangas[index],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                subtitle: const Text("Mangá adicionado à lista"),

              ),
            );
          },
        ),
      ),
    );
  }
}