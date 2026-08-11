import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/manga.dart';
import 'controllers/manga_controller.dart';


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

  // Controller usado para acessar o banco de dados
  final MangaController _mangaController = MangaController();

  // Gerenciamento dos dados selecionados INPUT
  int _selectedRating = 0;

  // Controller usado para capturar o comentário INPUT
  final TextEditingController _reviewController =
      TextEditingController();


  // Carrega a nota que já está salva no banco
  Future<void> _carregarNota() async {

    // Busca os mangás cadastrados no banco
    final mangas = await _mangaController.listarMangas();

    // Procura o mangá selecionado
    for (final manga in mangas) {

      if (manga.titulo == widget.mangaTitle) {

        setState(() {
          // Pega a nota salva no banco
          _selectedRating = manga.nota;
        });

        break;
      }
    }
  }


  @override
  void initState() {
    super.initState();

    // Carrega a nota salva assim que a tela abre
    _carregarNota();
  }


  @override
  void dispose() {

    // Libera a memória limpando o controller
    _reviewController.dispose();

    super.dispose();
  }


  // Salva a avaliação no banco de dados
  Future<void> _salvarAvaliacao() async {

    // Verifica se alguma estrela foi selecionada
    if (_selectedRating == 0) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecione uma nota!',
          ),
        ),
      );

      return;
    }


    // Busca os mangás cadastrados
    final mangas = await _mangaController.listarMangas();


    // Procura o mangá que está sendo avaliado
    for (final manga in mangas) {

      if (manga.titulo == widget.mangaTitle) {

        // Cria o mangá atualizado
        final mangaAtualizado = Manga(
          id: manga.id,
          titulo: manga.titulo,
          nota: _selectedRating,
          progresso: manga.progresso,
        );


        // Atualiza a nota no banco de dados
        await _mangaController.atualizarManga(mangaAtualizado);

        break;
      }
    }


    // Mostra uma mensagem avisando que foi salvo
    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Avaliação salva com sucesso!',
          ),
        ),
      );


      // Volta para a tela anterior NAVEGAÇÃO
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {

    // Estrutura base e organização visual da tela LAYOUT
    return Scaffold(

      appBar: AppBar(

        title: Text(
          'Avaliar ${widget.mangaTitle}',
          style: GoogleFonts.poppins(),
        ),

        backgroundColor: Colors.deepPurple,
      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              'Sua nota:',

              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 8),


            // Interação com as estrelas INPUT
            Row(

              children: List.generate(5, (index) {

                return IconButton(

                  icon: Icon(

                    index < _selectedRating
                        ? Icons.star
                        : Icons.star_border,

                    color: Colors.amber,

                    size: 36,
                  ),


                  onPressed: () {

                    // O setState é usado pra escolher uma nota.
                    // Quando clicar na estrela vai atualizar e mostrar a quantidade de estrelas preenchidas.
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

              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 8),


            // Captura de texto do usuário INPUT
            TextField(

              controller: _reviewController,

              maxLines: 4,

              decoration: const InputDecoration(

                border: OutlineInputBorder(),

                hintText: 'O que você achou deste mangá?',
              ),
            ),


            const SizedBox(height: 24),


            // Botão de envio dos dados INPUT
            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                onPressed: _salvarAvaliacao,

                child: Text(
                  'Enviar Avaliação',

                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}