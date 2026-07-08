import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  // Controladores para capturar e gerenciar o texto digitado INPUT
  final TextEditingController _readController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  // Variáveis de estado para armazenar o progresso calculado INPUT
  double _progress = 0;
  double _percentage = 0;

  // Cálculo do progresso da leitura
  void _calculateProgress() {
    // Pega o que foi digitado e tranforma em numero. Se for vazio ele deixa 0 INPUT
    int read = int.tryParse(_readController.text) ?? 0;
    int total = int.tryParse(_totalController.text) ?? 0;

    // Validação dos campos (ve se são validos)
    if (total > 0 && read <= total) {

      // Atualiza a tela INPUT
      // O setState() atualiza a tela quando o usuário calcula o progresso da leitura.
      // Depois que os capítulos são informados, a barra de progresso e 
      // a porcentagem são atualizadas automaticamente.

      setState(() {
        _progress = read / total; // Divide os capítulos lidos pelo total
        _percentage = (_progress * 100); // Transforma o resultado em porcentagem
      });
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

            // Construtor de animação implícita nativa do Flutter ANIMAÇÃO
            TweenAnimationBuilder<double>(
              // Define o intervalo de início e fim da animação ANIMAÇÃO
              tween: Tween(begin: 0, end: _progress),
              // Duração da transição da barra de progresso ANIMAÇÃO
              duration: const Duration(milliseconds: 900),
              // Constrói visualmente a animação conforme o valor muda ANIMAÇÃO
              builder: (context, value, child) {
                return Column(
                  children: [
                    LinearProgressIndicator( // Barra de progresso gráfica LAYOUT
                      value: value, // Recebe o valor animado corrente ANIMAÇÃO
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