import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/manga.dart';
import 'models/item_colecao.dart';
import 'database/database_helper.dart';
import 'review_page.dart';
import 'reading_page.dart';

class ColecaoMangaPage extends StatefulWidget {
  final Manga manga;
  const ColecaoMangaPage({super.key, required this.manga});

  @override
  State<ColecaoMangaPage> createState() => _ColecaoMangaPageState();
}

class _ColecaoMangaPageState extends State<ColecaoMangaPage> {
  final _db = DatabaseHelper.instance;
  final _itemController = TextEditingController();
  final _notasController = TextEditingController();
  List<ItemColecao> _itens = [];
  bool _salvandoNotas = false;
  late Manga _manga;

  @override
  void initState() {
    super.initState();
    _manga = widget.manga;
    _notasController.text = _manga.anotacoes;
    _carregar();
  }

  Future<void> _carregar() async {
    final itens = await _db.listarItens(_manga.id!);
    final mangas = await _db.getMangas();
    if (!mounted) return;
    setState(() {
      _itens = itens;
      for (final m in mangas) {
        if (m.id == _manga.id) { _manga = m; break; }
      }
    });
  }

  Future<void> _adicionarItem() async {
    final descricao = _itemController.text.trim();
    if (descricao.isEmpty) return;
    await _db.adicionarItem(ItemColecao(mangaId: _manga.id!, descricao: descricao));
    _itemController.clear();
    await _carregar();
  }

  Future<void> _marcar(ItemColecao item, bool marcado) async {
    await _db.atualizarItem(ItemColecao(id: item.id, mangaId: item.mangaId,
      descricao: item.descricao, comprado: marcado));
    await _carregar();
  }

  Future<void> _excluir(ItemColecao item) async {
    await _db.excluirItem(item.id!, item.mangaId);
    await _carregar();
  }

  Future<void> _salvarNotas() async {
    setState(() => _salvandoNotas = true);
    try {
      await _db.atualizarAnotacoes(_manga.id!, _notasController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anotações salvas!')));
      await _carregar();
    } finally {
      if (mounted) setState(() => _salvandoNotas = false);
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comprados = _itens.where((i) => i.comprado).length;
    final porcentagem = _itens.isEmpty ? 0.0 : comprados / _itens.length;
    const roxo = Color.fromARGB(255, 81, 49, 134);
    return Scaffold(
      appBar: AppBar(title: Text('Minha coleção', style: GoogleFonts.modak())),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // LAYOUT: capa e dados da coleção
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100, height: 145, child: _manga.capa == null || _manga.capa!.isEmpty
            ? const Icon(Icons.menu_book, size: 70, color: roxo)
            : Image.network(_manga.capa!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, size: 70))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_manga.titulo, style: GoogleFonts.modak(fontSize: 25, color: roxo)),
            const SizedBox(height: 8),
            Text('$comprados de ${_itens.length} itens comprados'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: porcentagem, minHeight: 9,
              backgroundColor: Colors.deepPurple.shade100,
              valueColor: const AlwaysStoppedAnimation(roxo)),
            const SizedBox(height: 8),
            Text('${(porcentagem * 100).round()}% da coleção'),
          ])),
        ]),
        const SizedBox(height: 20),
        // NAVEGAÇÃO: mantém as telas já existentes
        Wrap(spacing: 10, runSpacing: 8, children: [
          OutlinedButton.icon(icon: const Icon(Icons.star), label: const Text('Avaliar'),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                builder: (_) => ReviewPage(mangaTitle: _manga.titulo)));
              await _carregar();
            }),
          OutlinedButton.icon(icon: const Icon(Icons.auto_stories),
            label: const Text('Progresso de leitura'), onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                builder: (_) => ReadingProgressPage(mangaTitle: _manga.titulo)));
              await _carregar();
            }),
        ]),
        const SizedBox(height: 18),
        Text('Lista de compras', style: GoogleFonts.modak(fontSize: 25, color: roxo)),
        const Text('Marque os volumes que você já comprou.'),
        const SizedBox(height: 10),
        // INPUT: adiciona volumes ou edições especiais
        Row(children: [
          Expanded(child: TextField(controller: _itemController,
            textInputAction: TextInputAction.done, onSubmitted: (_) => _adicionarItem(),
            decoration: const InputDecoration(labelText: 'Ex.: Volume 01',
              border: OutlineInputBorder()))),
          const SizedBox(width: 8),
          IconButton(onPressed: _adicionarItem, icon: const Icon(Icons.add_circle, color: roxo),
            tooltip: 'Adicionar volume'),
        ]),
        const SizedBox(height: 10),
        if (_itens.isEmpty) const Padding(padding: EdgeInsets.all(16),
          child: Text('Sua lista está vazia. Adicione o primeiro volume!')),
        ..._itens.map((item) => Card(child: Row(children: [
          Checkbox(value: item.comprado, onChanged: (v) => _marcar(item, v ?? false)),
          Expanded(child: Text(item.descricao,
            style: TextStyle(decoration: item.comprado ? TextDecoration.lineThrough : null))),
          IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Excluir item',
            onPressed: () => _excluir(item)),
        ]))),
        const SizedBox(height: 24),
        Text('Minhas anotações', style: GoogleFonts.modak(fontSize: 25, color: roxo)),
        const SizedBox(height: 8),
        // INPUT: bloco de notas pessoal de cada mangá
        TextField(controller: _notasController, minLines: 5, maxLines: 12,
          decoration: const InputDecoration(
            hintText: 'Preços, lojas, volumes faltantes, edições especiais...',
            border: OutlineInputBorder(), alignLabelWithHint: true)),
        const SizedBox(height: 10),
        ElevatedButton.icon(onPressed: _salvandoNotas ? null : _salvarNotas,
          icon: const Icon(Icons.save), label: const Text('Salvar anotações')),
        const SizedBox(height: 24),
      ]),
    );
  }
}
