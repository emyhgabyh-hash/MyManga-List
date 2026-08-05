import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barra superior
        title: Text(
          "Cadastrar",
          style: GoogleFonts.modak(), // Fonte personalizada LATOUT
        ),
      ),

      body: Padding(
        // Espaçamento interno LAYOUT
        padding: const EdgeInsets.all(24.0),

        child: Column(
          // Organiza os widgets na vertical  LAYOUT
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

            // Campo Nome INPUT
            TextField(
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Campo Email INPUT
            TextField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Campo Senha INPUT
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
                  // Depois vamos salvar os dados no SharedPreferences
                },

                child: const Text("Cadastrar"),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pop(context); // NAVEGAÇÃO
              },

              child: const Text("Já possui uma conta? Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}