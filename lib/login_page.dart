import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_manga_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Entrar",
          style: GoogleFonts.modak(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              "MyManga List",
              style: GoogleFonts.modak(
                fontSize: 36,
                color: const Color.fromARGB(255, 81, 49, 134),
              ),
            ),

            const SizedBox(height: 40),

            TextField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (context) => const HomeMangaPage(),
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