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
  final _controller = MangaController();
  final _buscaController = TextEditingController();
  List<MangaModel> mangas = [];
  final Map<String, String> sinopses = {};
  bool carregando = false;
  String? erro;
  int _numeroBusca = 0;

  Future<void> _buscarMangas() async {
    final texto = _buscaController.text.trim();
    if (texto.isEmpty || carregando) return;
    final numero = ++_numeroBusca;
    setState(() { carregando = true; erro = null; mangas = []; sinopses.clear(); });
    try {
      final json = await Remote.get(EndPoints.buscarMangas(texto));
      final lista = MangaListModel.fromJson(json);
      if (!mounted || numero != _numeroBusca) return;
      setState(() => mangas = lista.mangas);
      for (final manga in lista.mangas) {
        Traducao.traduzir(manga.sinopse).then((texto) {
          if (mounted && numero == _numeroBusca) {
            setState(() => sinopses[manga.id] = texto);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  Future<void> _adicionarManga(MangaModel manga) async {
    try {
      await _controller.adicionarManga(Manga(titulo: manga.titulo, capa: manga.capa));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${manga.titulo} adicionado à biblioteca!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  void dispose() { _buscaController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const roxo = Color.fromARGB(255, 81, 49, 134);
    return Scaffold(appBar: AppBar(title: Text('Buscar mangás', style: GoogleFonts.modak())),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: _buscaController, onSubmitted: (_) => _buscarMangas(),
          decoration: const InputDecoration(labelText: 'Nome do mangá',
            prefixIcon: Icon(Icons.search), border: OutlineInputBorder())),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: carregando ? null : _buscarMangas, child: const Text('Pesquisar'))),
        if (carregando) const LinearProgressIndicator(),
        if (erro != null) Text(erro!, style: const TextStyle(color: Colors.red)),
        Expanded(child: ListView.builder(itemCount: mangas.length, itemBuilder: (context, index) {
          final manga = mangas[index];
          return Card(margin: const EdgeInsets.only(top: 10),
            child: Padding(padding: const EdgeInsets.all(10), child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 75, height: 110, child: manga.capa == null
                ? const Icon(Icons.menu_book, size: 42)
                : Image.network(manga.capa!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, size: 42))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => MangaUISingle(id: manga.id))),
                  child: Text(manga.titulo,
                    style: GoogleFonts.modak(fontSize: 19, color: roxo))),
                Text('Nota: ${manga.score?.toStringAsFixed(1) ?? '-'} | Capítulos: ${manga.capitulos ?? '?'}'),
                const SizedBox(height: 5),
                Text(sinopses[manga.id] ?? 'Traduzindo sinopse…',
                  maxLines: 4, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                ElevatedButton.icon(onPressed: () => _adicionarManga(manga),
                  icon: const Icon(Icons.add), label: const Text('Adicionar')),
              ])),
            ])));
        })),
      ])));
  }
}