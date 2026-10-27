import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../conexao/EndPoints.dart';
import '../conexao/remote.dart';
import '../conexao/traducao.dart';
import '../models/manga.dart';
import '../controllers/manga_controller.dart';
import 'MangaListModel.dart';
import 'MangaModel.dart';
import 'MangaUISingle.dart';

class MangaUI extends StatefulWidget {
  const MangaUI({super.key});
  @override
  State<MangaUI> createState() => _MangaUIState();
}

class _MangaUIState extends State<MangaUI> {
  final MangaController _mangaController = MangaController();
  final TextEditingController _buscaController = TextEditingController();
  List<MangaModel> mangas = [];
  final Map<String, String> sinopses = {};
  bool carregando = false;
  String? erro;

  // Pesquisa os mangás na API Kitsu
  Future<void> _buscarMangas() async {
    final texto = _buscaController.text.trim();
    if (texto.isEmpty || carregando) return;
    setState(() { carregando = true; erro = null; mangas = []; sinopses.clear(); });
    try {
      final json = await Remote.get(EndPoints.buscarMangas(texto));
      final lista = MangaListModel.fromJson(json);
      if (!mounted) return;
      setState(() { mangas = lista.mangas; carregando = false; });
      // Traduz as sinopses sem travar a exibição dos resultados
      for (final manga in lista.mangas) {
        Traducao.traduzir(manga.sinopse).then((traduzida) {
          if (mounted) setState(() => sinopses[manga.id] = traduzida);
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { erro = e.toString().replaceFirst('Exception: ', ''); mangas = []; });
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  // Salva o título e a capa no SQLite
  Future<void> _adicionarManga(MangaModel manga) async {
    try {
      await _mangaController.adicionarManga(Manga(titulo: manga.titulo, capa: manga.capa));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${manga.titulo} foi adicionado à biblioteca!')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível adicionar o mangá.')),
      );
    }
  }

  @override
  void dispose() { _buscaController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar mangás', style: GoogleFonts.modak())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Campo de pesquisa INPUT
          TextField(
            controller: _buscaController,
            decoration: const InputDecoration(
              labelText: 'Nome do mangá', border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (_) => _buscarMangas(),
          ),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: carregando ? null : _buscarMangas,
            child: const Text('Pesquisar'),
          )),
          const SizedBox(height: 12),
          if (carregando) const CircularProgressIndicator(),
          if (erro != null) Text(erro!, style: const TextStyle(color: Colors.red)),
          Expanded(child: ListView.builder(
            itemCount: mangas.length,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Capa recebida da API LAYOUT
                    SizedBox(width: 75, height: 105, child: manga.capa == null
                      ? const Icon(Icons.menu_book, size: 45)
                      : Image.network(manga.capa!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, size: 45))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Abre a página de detalhes NAVEGAÇÃO
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MangaUISingle(id: manga.id),
                        )),
                        child: Text(manga.titulo, style: GoogleFonts.modak(
                          fontSize: 19, color: const Color.fromARGB(255, 81, 49, 134),
                        )),
                      ),
                      const SizedBox(height: 4),
                      Text('Nota: ${manga.score?.toStringAsFixed(1) ?? '-'} | Capítulos: ${manga.capitulos ?? '?'}'),
                      const SizedBox(height: 5),
                      Text(sinopses[manga.id] ?? 'Traduzindo sinopse…',
                        maxLines: 4, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _adicionarManga(manga),
                        icon: const Icon(Icons.add), label: const Text('Adicionar'),
                      ),
                    ])),
                  ]),
                ),
              );
            },
          )),
        ]),
      ),
    );
  }
}
