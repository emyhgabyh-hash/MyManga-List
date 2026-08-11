import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {

  // Controladores para capturar os dados digitados INPUT
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {

    // Libera a memória limpando os controladores
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }


  // Salva os dados do usuário no SharedPreferences
  Future<void> _cadastrar() async {

    // Pega os dados digitados pelo usuário
    final String nome = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String senha = _passwordController.text;


    // Verifica se os campos estão preenchidos
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Preencha todos os campos!",
          ),
        ),
      );

      return;
    }


    // Abre o SharedPreferences
    final prefs = await SharedPreferences.getInstance();


    // Salva os dados do usuário
    await prefs.setString('nome', nome);
    await prefs.setString('email', email);
    await prefs.setString('senha', senha);


    // Mostra uma mensagem de sucesso
    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Cadastro realizado com sucesso!",
          ),
        ),
      );


      // Volta para a tela de login NAVEGAÇÃO
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold( // Estrutura principal da tela LAYOUT

      appBar: AppBar( // Barra superior LAYOUT

        title: Text(
          "Cadastrar",
          style: GoogleFonts.modak(), // Fonte personalizada LAYOUT
        ),
      ),


      body: Padding(

        // Espaçamento interno LAYOUT
        padding: const EdgeInsets.all(24.0),

        child: Column(

          // Organiza os widgets na vertical LAYOUT
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

              controller: _nameController,

              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 20),


            // Campo Email INPUT
            TextField(

              controller: _emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 20),


            // Campo Senha INPUT
            TextField(

              controller: _passwordController,

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

                // Botão de cadastro INPUT
                onPressed: _cadastrar,

                child: const Text("Cadastrar"),
              ),
            ),


            const SizedBox(height: 15),


            TextButton(

              onPressed: () {

                // Volta para a tela de login NAVEGAÇÃO
                Navigator.pop(context);
              },

              child: const Text(
                "Já possui uma conta? Entrar",
              ),
            ),
          ],
        ),
      ),
    );
  }
}