
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../conexao/EndPoints.dart';
import '../conexao/remote.dart';
import '../conexao/traducao.dart';
import '../models/manga.dart';
import '../controllers/manga_controller.dart';
import 'MangaModel.dart';

class MangaUISingle extends StatefulWidget {
  // Recebe o ID do mangá selecionado na pesquisa
  final String id;

  const MangaUISingle({super.key, required this.id});

  @override
  State<MangaUISingle> createState() => _MangaUISingleState();
}

class _MangaUISingleState extends State<MangaUISingle> {
  late final Future<MangaModel> _mangaFuture;

  @override
  void initState() {
    super.initState();

    // Carrega os detalhes do mangá quando a tela abre
    _mangaFuture = _carregar();
  }

  // Busca um mangá específico na Kitsu pelo ID API
  Future<MangaModel> _carregar() async {
    final json = await Remote.get(EndPoints.mangaPorId(widget.id));

    // Converte os dados recebidos para MangaModel
    return MangaModel.fromJson(
      json['data'] as Map<String, dynamic>,
    );
  }

  // Salva o mangá e sua capa no SQLite
  Future<void> _adicionarManga(MangaModel manga) async {
    try {
      await MangaController().adicionarManga(
        Manga(titulo: manga.titulo, capa: manga.capa),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mangá adicionado à biblioteca!')),
      );
    } catch (e) {
      // Mostra uma mensagem caso aconteça um erro ao salvar
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const roxo = Color.fromARGB(255, 81, 49, 134);

    return Scaffold(
      // Barra superior da página LAYOUT
      appBar: AppBar(
        title: Text(
          'Detalhes do mangá',
          style: GoogleFonts.modak(),
        ),
      ),

      // Aguarda os dados recebidos da API
      body: FutureBuilder<MangaModel>(
        future: _mangaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostra uma mensagem caso não consiga carregar os dados
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Erro ao carregar: ${snapshot.error ?? 'sem dados'}',
              ),
            );
          }

          final manga = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Mostra a capa recebida da Kitsu
                if (manga.capa != null)
                  Image.network(
                    manga.capa!,
                    height: 250,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.menu_book, size: 100),
                  ),

                const SizedBox(height: 16),

                // Mostra o título do mangá
                Text(
                  manga.titulo,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.modak(
                    fontSize: 26,
                    color: roxo,
                  ),
                ),

                const SizedBox(height: 8),

                // Mostra a nota e a quantidade de capítulos
                Text(
                  'Nota: ${manga.score?.toStringAsFixed(1) ?? '-'}'
                  ' | Capítulos: ${manga.capitulos ?? '?'}',
                ),

                const SizedBox(height: 16),

                // Tenta traduzir e mostrar a sinopse
                FutureBuilder<String>(
                  future: Traducao.traduzir(manga.sinopse),
                  builder: (context, traducao) {
                    return Text(
                      traducao.data ?? 'Traduzindo sinopse…',
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Botão para adicionar à biblioteca INPUT
                ElevatedButton.icon(
                  onPressed: () => _adicionarManga(manga),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar à minha lista'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
