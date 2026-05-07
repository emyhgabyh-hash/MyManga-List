import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'MyManga List',

      theme: ThemeData(

        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 233, 218),

        primaryColor: Color(0xFF7E57C2),

        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 81, 49, 134),
          foregroundColor: const Color.fromARGB(255, 241, 233, 218),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(

          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 81, 49, 134),
            foregroundColor:const Color.fromARGB(255, 241, 233, 218),
          ),
        ),
      ),

      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "MyManga List",
          style: GoogleFonts.modak(
            fontSize: 24,
            color: const Color.fromARGB(255, 241, 233, 218),
          ),
        ),
      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.menu_book,
              size: 100,
              color: Color.fromARGB(255, 81, 49, 134),
            ),

            SizedBox(height: 20),

            Text(

              "MyManga List",

              style: GoogleFonts.modak(
                fontSize: 42,
                color: Color.fromARGB(255, 81, 49, 134),
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text("Entrar"),
            ),

            SizedBox(height: 20),

            ElevatedButton(

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