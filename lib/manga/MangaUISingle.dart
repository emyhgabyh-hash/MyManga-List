import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../conexao/EndPoints.dart';
import '../conexao/remote.dart';
import '../conexao/traducao.dart';
import '../models/manga.dart';
import '../controllers/manga_controller.dart';
import 'MangaModel.dart';

class MangaUISingle extends StatefulWidget {
  final String id;
  const MangaUISingle({super.key, required this.id});
  @override
  State<MangaUISingle> createState() => _MangaUISingleState();
}

class _MangaUISingleState extends State<MangaUISingle> {
  late final Future<MangaModel> _mangaFuture;
  @override
  void initState() { super.initState(); _mangaFuture = _carregar(); }

  // Busca os detalhes na Kitsu
  Future<MangaModel> _carregar() async {
    final json = await Remote.get(EndPoints.mangaPorId(widget.id));
    return MangaModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  // Salva a capa junto com o título
  Future<void> _adicionarManga(MangaModel manga) async {
    try {
      await MangaController().adicionarManga(Manga(titulo: manga.titulo, capa: manga.capa));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mangá adicionado à biblioteca!')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o mangá.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do mangá', style: GoogleFonts.modak())),
      body: FutureBuilder<MangaModel>(
        future: _mangaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Erro ao carregar: ${snapshot.error ?? 'sem dados'}'));
          }
          final manga = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              if (manga.capa != null) ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(manga.capa!, height: 250,
                  errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, size: 100)),
              ),
              const SizedBox(height: 16),
              Text(manga.titulo, textAlign: TextAlign.center, style: GoogleFonts.modak(
                fontSize: 26, color: const Color.fromARGB(255, 81, 49, 134),
              )),
              const SizedBox(height: 8),
              Text('Nota: ${manga.score?.toStringAsFixed(1) ?? '-'} | Capítulos: ${manga.capitulos ?? '?'}'),
              const SizedBox(height: 16),
              // Mostra a tradução quando ficar pronta
              FutureBuilder<String>(
                future: Traducao.traduzir(manga.sinopse),
                builder: (context, traducao) {
                  if (!traducao.hasData) return const Text('Traduzindo sinopse…');
                  return Text(traducao.data!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _adicionarManga(manga),
                icon: const Icon(Icons.add), label: const Text('Adicionar à minha lista'),
              ),
            ]),
          );
        },
      ),
    );
  }
}
