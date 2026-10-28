import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/manga.dart';
import 'controllers/manga_controller.dart';
import 'manga/MangaUI.dart';
import 'colecao_manga_page.dart';

class HomeMangaPage extends StatefulWidget {
  const HomeMangaPage({super.key});
  @override
  State<HomeMangaPage> createState() => _HomeMangaPageState();
}

class _HomeMangaPageState extends State<HomeMangaPage> {
  final MangaController _controller = MangaController();
  List<Manga> mangas = [];

  @override
  void initState() { super.initState(); _carregarMangas(); }

  Future<void> _carregarMangas() async {
    final lista = await _controller.listarMangas();
    if (mounted) setState(() => mangas = lista);
  }

  Future<void> _dialogoManga({Manga? manga}) async {
    final tituloController = TextEditingController(text: manga?.titulo ?? '');
    final titulo = await showDialog<String>(context: context, builder: (dialogContext) =>
      AlertDialog(title: Text(manga == null ? 'Adicionar mangá' : 'Editar mangá',
        style: GoogleFonts.modak()),
        content: TextField(controller: tituloController, autofocus: true,
          decoration: const InputDecoration(labelText: 'Nome do mangá',
            border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () {
            if (tituloController.text.trim().isNotEmpty) {
              Navigator.pop(dialogContext, tituloController.text.trim());
            }
          }, child: const Text('Salvar')),
        ]));
    tituloController.dispose();
    if (titulo == null) return;
    if (manga == null) {
      await _controller.adicionarManga(Manga(titulo: titulo));
    } else {
      await _controller.atualizarManga(Manga(id: manga.id, titulo: titulo,
        nota: manga.nota, progresso: manga.progresso, capa: manga.capa,
        anotacoes: manga.anotacoes));
    }
    await _carregarMangas();
  }

  Future<void> _excluirManga(Manga manga) async {
    if (manga.id == null) return;
    await _controller.excluirManga(manga.id!);
    await _carregarMangas();
  }

  @override
  Widget build(BuildContext context) {
    const roxo = Color.fromARGB(255, 81, 49, 134);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text('Meus Mangás', style: GoogleFonts.modak()), actions: [
          IconButton(icon: const Icon(Icons.search), tooltip: 'Buscar na Kitsu',
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const MangaUI()));
              await _carregarMangas();
            }),
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Sair',
            onPressed: () => Navigator.pop(context)),
        ]),
      body: mangas.isEmpty
        ? const Center(child: Text('Nenhum mangá adicionado. Use + ou a pesquisa.'))
        : ListView.builder(padding: const EdgeInsets.all(12), itemCount: mangas.length,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              return Card(margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  // NAVEGAÇÃO: abre a coleção particular deste mangá
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => ColecaoMangaPage(manga: manga)));
                    await _carregarMangas();
                  },
                  child: Padding(padding: const EdgeInsets.all(10), child: Row(children: [
                    // LAYOUT: capinha salva no SQLite
                    SizedBox(width: 65, height: 92,
                      child: manga.capa == null || manga.capa!.isEmpty
                        ? const Icon(Icons.menu_book, size: 42, color: roxo)
                        : ClipRRect(borderRadius: BorderRadius.circular(5),
                            child: Image.network(manga.capa!, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, color: roxo)))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(manga.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text('Nota: ${manga.nota} | Leitura: ${manga.progresso}%'),
                        const SizedBox(height: 5),
                        const Text('Toque para abrir a coleção',
                          style: TextStyle(color: roxo, fontSize: 12)),
                      ])),
                    Column(children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar', onPressed: () => _dialogoManga(manga: manga)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Excluir', onPressed: () => _excluirManga(manga)),
                    ]),
                  ]))));
            }),
      floatingActionButton: FloatingActionButton(backgroundColor: roxo,
        onPressed: () => _dialogoManga(),
        child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}