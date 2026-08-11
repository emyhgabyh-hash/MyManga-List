import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_manga_page.dart';
import 'register_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  // Controladores para capturar os dados digitados INPUT
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {

    // Libera a memória limpando os controladores
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }


  // Verifica os dados do usuário no SharedPreferences
  Future<void> _entrar() async {

    // Pega os dados digitados
    final String email = _emailController.text.trim();
    final String senha = _passwordController.text;


    // Verifica se os campos estão preenchidos
    if (email.isEmpty || senha.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Preencha o email e a senha!",
          ),
        ),
      );

      return;
    }


    // Abre o SharedPreferences
    final prefs = await SharedPreferences.getInstance();


    // Pega os dados que foram salvos no cadastro
    final String? emailSalvo = prefs.getString('email');
    final String? senhaSalva = prefs.getString('senha');


    // Verifica se o email e a senha estão corretos
    if (email == emailSalvo && senha == senhaSalva) {

      // Se estiverem corretos, abre a HomeMangaPage NAVEGAÇÃO
      if (mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeMangaPage(),
          ),
        );
      }

    } else {

      // Mostra uma mensagem caso os dados estejam incorretos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email ou senha incorretos!",
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold( // Estrutura principal da tela LAYOUT

      appBar: AppBar( // Barra superior LAYOUT

        title: Text(
          "Entrar",
          style: GoogleFonts.modak(), // Fonte personalizada LAYOUT
        ),
      ),


      body: Padding( // Espaçamento interno LAYOUT

        padding: const EdgeInsets.all(24.0),

        child: Column( // Organiza widgets verticalmente LAYOUT

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              "MyManga List",

              style: GoogleFonts.modak( // Fonte personalizada LAYOUT
                fontSize: 36,
                color: const Color.fromARGB(255, 81, 49, 134),
              ),
            ),


            const SizedBox(height: 40),


            // Campo de texto para email INPUT
            TextField(

              controller: _emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(

                labelText: "Email", // Nome do campo INPUT

                border: OutlineInputBorder(), // Borda do campo LAYOUT
              ),
            ),


            const SizedBox(height: 20),


            // Campo de senha INPUT
            TextField(

              controller: _passwordController,

              obscureText: true, // Esconde os caracteres digitados INPUT

              decoration: const InputDecoration(

                labelText: "Senha",

                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 30),


            SizedBox(

              width: double.infinity,

              child: ElevatedButton( // Botão clicável INPUT

                onPressed: _entrar,

                child: const Text("Entrar"),
              ),
            ),


            const SizedBox(height: 15),


            TextButton( // Botão para ir para a tela de cadastro INPUT

              onPressed: () {

                Navigator.push( // Navega para tela de cadastro NAVEGAÇÃO

                  context,

                  MaterialPageRoute(

                    builder: (context) => const RegisterPage(), // Abre a RegisterPage NAVEGAÇÃO

                  ),
                );
              },

              child: const Text("Criar uma conta"),
            ),
          ],
        ),
      ),
    );
  }
}