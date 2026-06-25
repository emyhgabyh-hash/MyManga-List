import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatefulWidget {
  final String mangaTitle;

  const ReviewPage({
    super.key,
    required this.mangaTitle,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Variáveis de Estado para controlar os inputs nativos
  int _selectedRating = 0; // Armazena a nota selecionada de 1 a 5 INPUT
  final TextEditingController _reviewController = TextEditingController(); // Controlador do campo de texto INPUT

  @override
  void dispose() {
    _reviewController.dispose(); // Descarta o controlador da memória ao fechar a tela LAYOUT
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Estrutura principal da tela de avaliação LAYOUT
      appBar: AppBar( // Barra superior da tela LAYOUT
        title: Text(
          "Avaliar",
          style: GoogleFonts.modak(), // Fonte personalizada combinando com o app LAYOUT
        ),
      ),
      body: Padding( // Espaçamento interno para  não tocar nas bordas LAYOUT
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView( // Permite rolagem caso o teclado apareça sobre a tela LAYOUT
          child: Column( // Organiza os elementos verticalmente LAYOUT
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza os itens na horizontal LAYOUT
            children: [
              Text(
                widget.mangaTitle, // Exibe o título do mangá recebido LAYOUT
                textAlign: TextAlign.center,
                style: GoogleFonts.modak( // Fonte personalizada LAYOUT
                  fontSize: 28,
                  color: const Color.fromARGB(255, 81, 49, 134),
                ),
              ),
              const SizedBox(height: 10), // Espaçamento vertical LAYOUT
              const Text(
                "O que você achou deste mangá?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30), // Espaçamento vertical LAYOUT

              // Paerte da nota com as 5 estrelas
              Row( // Organiza as estrelas horizontalmente LAYOUT
                mainAxisAlignment: MainAxisAlignment.center, // Centraliza as estrelas LAYOUT
                children: List.generate(5, (index) { // Gera 5 estrelas LAYOUT
                  int starValue = index + 1; // Define o valor real da estrela atual (1 a 5)

                  return IconButton( // Botão clicável para registrar a nota INPUT
                    iconSize: 40,
                    onPressed: () {
                      setState(() { // Atualiza a tela com a nova nota INPUT
                        _selectedRating = starValue;
                      });
                    },
                    icon: Icon( // Ícone dinâmico que muda conforme a seleção do usuário LAYOUT
                      starValue <= _selectedRating
                          ? Icons.star // Preenchida se for menor ou igual à nota escolhida LAYOUT
                          : Icons.star_border, // Apenas contorno se for maior LAYOUT
                      color: const Color.fromARGB(255, 255, 191, 0), // Cor da estrela LAYOUT
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30), // Espaçamento vertical LAYOUT

              // Campo de Texto para Comentários
              TextField( // Campo de entrada para a resenha escrita INPUT
                controller: _reviewController, // Vincula o texto digitado ao controlador INPUT
                maxLines: 4, // Permite que o campo tenha várias linhas de escrita LAYOUT
                decoration: const InputDecoration(
                  labelText: "Escreva sua avaliação (opcional)", // Rótulo do campo INPUT
                  border: OutlineInputBorder(), // Borda quadrada LAYOUT
                  alignLabelWithHint: true, // Alinha o texto no topo LAYOUT
                ),
              ),

              const SizedBox(height: 40), // Espaçamento vertical LAYOUT

              // Botão para Salvar
              SizedBox( // Define o tamanho do botão LAYOUT
                width: double.infinity, // Faz o botão ocupar toda a largura disponível LAYOUT
                child: ElevatedButton( // Botão clicável INPUT
                  onPressed: () {
                    // Mostra uma mensagem flutuante de sucesso na tela de forma nativa
                    ScaffoldMessenger.of(context).showSnackBar( // Feedback visual para o usuário LAYOUT
                      SnackBar(
                        content: Text(
                          "Avaliação de '${widget.mangaTitle}' salva com sucesso!",
                        ),
                        backgroundColor: const Color.fromARGB(255, 31, 92, 33), // LAYOUT
                      ),
                    );

                    Navigator.pop(context); // Retornapara a tela anterior NAVEGAÇÃO
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