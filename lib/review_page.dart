import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatefulWidget {
  final String mangaTitle;

  const ReviewPage({super.key, required this.mangaTitle});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedRating = 0; // Armazena a nota de 1 a 5
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Avaliar",
          style: GoogleFonts.modak(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.mangaTitle,
                textAlign: Center,
                style: GoogleFonts.modak(
                  fontSize: 28,
                  color: const Color.fromARGB(255, 81, 49, 134),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "O que você achou deste mangá?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),

              // Sistema de Estrelas Nativo (INPUT)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int starValue = index + 1;
                  return IconButton(
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        _selectedRating = starValue;
                      });
                    },
                    icon: Icon(
                      starValue <= _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color.fromARGB(255, 255, 191, 0),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // Campo de texto para comentário (INPUT)
              TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Escreva sua avaliação (opcional)",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 40),

              // Botão para salvar avaliação (INPUT)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Executa a ação de salvar e volta para a listagem
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Avaliação de '${widget.mangaTitle}' salva com sucesso!"),
                        backgroundColor: const Color.fromARGB(255, 31, 92, 33),
                      ),
                    );
                    Navigator.pop(context); // Retorna à HomeMangaPage NAVEGAÇÃO
                  },
                  child: const Text("Salvar Avaliação"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}