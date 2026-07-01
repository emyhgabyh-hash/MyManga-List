import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatefulWidget {
  final String mangaTitle;

  const ReviewPage({super.key, required this.mangaTitle});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // INPUT: Gerenciamento dos dados digitados e selecionados
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LAYOUT: Estrutura base e organização visual da tela
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliar ${widget.mangaTitle}', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sua nota:',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // INPUT: Interação nativa com estrelas usando IconButton e setState
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              'Seu comentário:',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // INPUT: Captura de texto do usuário
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'O que você achou deste mangá?',
              ),
            ),
            const SizedBox(height: 24),
            
            // INPUT: Botão de ação para envio dos dados
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () {
                  if (_selectedRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, selecione uma nota!')),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Avaliação salva com sucesso!')),
                  );

                  // NAVEGAÇÃO: Retorno nativo desempilhando a tela
                  Navigator.pop(context);
                },
                child: Text(
                  'Enviar Avaliação',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}