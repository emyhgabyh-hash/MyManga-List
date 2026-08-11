import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/manga.dart';
import 'controllers/manga_controller.dart';


class ReadingProgressPage extends StatefulWidget {
  final String mangaTitle;

  const ReadingProgressPage({
    super.key,
    required this.mangaTitle,
  });


  @override
  State<ReadingProgressPage> createState() => _ReadingProgressPageState();
}


class _ReadingProgressPageState extends State<ReadingProgressPage> {

  // Controller usado para acessar o banco de dados
  final MangaController _mangaController = MangaController();

  // Controladores pra gerenciar o texto digitado INPUT
  // Controla os capítulos lidos
  final TextEditingController _readController = TextEditingController();

  // Controla o total dos capítulos
  final TextEditingController _totalController = TextEditingController();


  // Variáveis de estado para armazenar o progresso calculado INPUT
  double _progress = 0;
  double _percentage = 0;


  // Carrega o progresso que já está salvo no banco
  Future<void> _carregarProgresso() async {

    // Busca todos os mangás cadastrados
    final mangas = await _mangaController.listarMangas();

    // Procura o mangá que foi selecionado
    for (final manga in mangas) {

      if (manga.titulo == widget.mangaTitle) {

        setState(() {
          // Pega o progresso salvo no banco
          _percentage = manga.progresso.toDouble();

          // Converte a porcentagem para o valor usado pela barra
          _progress = _percentage / 100;
        });

        break;
      }
    }
  }


  @override
  void initState() {
    super.initState();

    // Carrega o progresso salvo assim que a tela abre
    _carregarProgresso();
  }


  // Cálculo do progresso da leitura
  Future<void> _calculateProgress() async {

    // Pega o que foi digitado e transforma em número.
    // Se estiver vazio ele deixa 0 INPUT
    int read = int.tryParse(_readController.text) ?? 0;
    int total = int.tryParse(_totalController.text) ?? 0;


    // Validação dos campos
    if (total > 0 && read >= 0 && read <= total) {

      // Calcula o progresso da leitura
      double progress = read / total;

      // Transforma o resultado em porcentagem
      double percentage = progress * 100;


      // Busca os mangás cadastrados no banco
      final mangas = await _mangaController.listarMangas();


      // Procura o mangá selecionado
      for (final manga in mangas) {

        if (manga.titulo == widget.mangaTitle) {

          // Cria o mangá atualizado
          final mangaAtualizado = Manga(
            id: manga.id,
            titulo: manga.titulo,
            nota: manga.nota,
            progresso: percentage.round(),
          );


          // Atualiza o progresso no banco de dados
          await _mangaController.atualizarManga(mangaAtualizado);

          break;
        }
      }


      // Atualiza a tela INPUT
      // O setState atualiza a tela quando o usuário calcula o progresso.
      setState(() {
        _progress = progress;
        _percentage = percentage;
      });


      // Mostra uma mensagem avisando que o progresso foi salvo
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Progresso salvo com sucesso!",
            ),
          ),
        );
      }

    } else {

      // Mostra uma mensagem se os valores estiverem errados LAYOUT
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Informe valores válidos!",
          ),
        ),
      );
    }
  }


  @override
  void dispose() {

    // Libera a memória limpando os controladores ao fechar a tela
    _readController.dispose();
    _totalController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold( // Estrutura básica da página LAYOUT

      appBar: AppBar( // Barra superior da tela LAYOUT

        title: Text(
          "Acompanhar Leitura",
          style: GoogleFonts.modak(), // Fonte padronizada LAYOUT
        ),

        centerTitle: true, // Centraliza o título da barra LAYOUT

        backgroundColor: const Color(0xFF7E57C2), // Cor roxa do tema LAYOUT
      ),


      body: Padding( // Adiciona espaçamento nas bordas internas LAYOUT

        padding: const EdgeInsets.all(20),

        child: Column( // Organiza os elementos verticalmente LAYOUT

          children: [

            Text(
              widget.mangaTitle, // Exibe o título dinâmico recebido LAYOUT

              style: GoogleFonts.modak(
                fontSize: 30,
                color: const Color(0xFF7E57C2),
              ),
            ),


            const SizedBox(height: 30), // Espaçamento vertical LAYOUT


            TextField( // Campo de entrada para capítulos lidos INPUT

              controller: _readController,

              keyboardType: TextInputType.number, // Abre teclado numérico LAYOUT

              decoration: const InputDecoration(
                labelText: "Capítulos lidos",
                border: OutlineInputBorder(), // Borda estilizada em volta LAYOUT
              ),
            ),


            const SizedBox(height: 20),


            TextField( // Campo de entrada para total de capítulos INPUT

              controller: _totalController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Total de capítulos",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 25),


            ElevatedButton( // Botão para disparar o cálculo INPUT

              onPressed: _calculateProgress, // Aciona a função ao clicar

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E57C2),
              ),

              child: const Text(
                "Calcular progresso",
                style: TextStyle(color: Colors.white),
              ),
            ),


            const SizedBox(height: 35),


            // Animação automática ANIMAÇÃO
            TweenAnimationBuilder<double>(

              // Define o início e fim da animação ANIMAÇÃO
              tween: Tween(
                begin: 0,
                end: _progress,
              ),

              // Duração da transição da barra de progresso ANIMAÇÃO
              duration: const Duration(milliseconds: 900),

              // Muda visualmente a animação conforme o valor muda ANIMAÇÃO
              builder: (context, value, child) {

                return Column(

                  children: [

                    LinearProgressIndicator( // Cria a barra de progresso na tela LAYOUT

                      value: value, // Faz com que a barra aumente aos poucos ANIMAÇÃO

                      minHeight: 18,

                      borderRadius: BorderRadius.circular(15),

                      backgroundColor: Colors.grey.shade300,

                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7E57C2),
                      ),
                    ),


                    const SizedBox(height: 15),


                    Text( // Exibe o texto percentual atualizado LAYOUT

                      "${_percentage.toStringAsFixed(1)}%",

                      style: GoogleFonts.modak(
                        fontSize: 28,
                        color: const Color(0xFF7E57C2),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}