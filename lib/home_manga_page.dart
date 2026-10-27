import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'review_page.dart'; // Tela de avaliação
import 'reading_page.dart'; // Tela de progresso
import 'models/manga.dart'; // Model do banco
import 'controllers/manga_controller.dart'; // Controller do banco
import 'manga/MangaUI.dart'; // Busca pela API Kitsu

class HomeMangaPage extends StatefulWidget {
  const HomeMangaPage({super.key});
  @override
  State<HomeMangaPage> createState() => _HomeMangaPageState();
}

class _HomeMangaPageState extends State<HomeMangaPage> {
  final MangaController _mangaController = MangaController();
  List<Manga> mangas = [];

  // Carrega os mangás salvos no SQLite
  Future<void> _carregarMangas() async {
    final lista = await _mangaController.listarMangas();
    if (!mounted) return;
    setState(() => mangas = lista);
  }

  @override
  void initState() { super.initState(); _carregarMangas(); }

  // Adiciona um mangá digitado manualmente INPUT
  void _adicionarManga() {
    final tituloController = TextEditingController();
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      title: Text('Adicionar Mangá', style: GoogleFonts.modak()),
      content: TextField(controller: tituloController,
        decoration: const InputDecoration(labelText: 'Nome do mangá', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          final titulo = tituloController.text.trim();
          if (titulo.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Digite o nome do mangá!')));
            return;
          }
          await _mangaController.adicionarManga(Manga(titulo: titulo));
          if (!mounted) return;
          if (dialogContext.mounted) Navigator.pop(dialogContext);
          _carregarMangas();
        }, child: const Text('Adicionar')),
      ],
    ));
  }

  // Edita o nome sem perder a capa, nota ou progresso
  void _editarManga(Manga manga) {
    final tituloController = TextEditingController(text: manga.titulo);
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      title: Text('Editar Mangá', style: GoogleFonts.modak()),
      content: TextField(controller: tituloController,
        decoration: const InputDecoration(labelText: 'Nome do mangá', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () async {
          final titulo = tituloController.text.trim();
          if (titulo.isEmpty) return;
          await _mangaController.atualizarManga(Manga(
            id: manga.id, titulo: titulo, nota: manga.nota,
            progresso: manga.progresso, capa: manga.capa,
          ));
          if (!mounted) return;
          if (dialogContext.mounted) Navigator.pop(dialogContext);
          _carregarMangas();
        }, child: const Text('Salvar')),
      ],
    ));
  }

  // Exclui um mangá do SQLite
  Future<void> _excluirManga(Manga manga) async {
    if (manga.id == null) return;
    await _mangaController.excluirManga(manga.id!);
    if (!mounted) return;
    _carregarMangas();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mangá excluído com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Meus Mangás', style: GoogleFonts.modak()),
        actions: [
          // Abre a pesquisa da API NAVEGAÇÃO
          IconButton(icon: const Icon(Icons.search), tooltip: 'Buscar mangás', onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MangaUI()))
              .then((_) => _carregarMangas());
          }),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: mangas.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.menu_book, size: 80, color: Color.fromARGB(255, 81, 49, 134)),
              const SizedBox(height: 20),
              Text('Nenhum mangá adicionado', style: GoogleFonts.modak(
                fontSize: 24, color: const Color.fromARGB(255, 81, 49, 134))),
              const SizedBox(height: 10),
              const Text('Clique no botão + para adicionar um mangá.'),
            ]))
          : ListView.builder(
              itemCount: mangas.length,
              itemBuilder: (context, index) {
                final manga = mangas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      // Capinha salva no SQLite LAYOUT
                      Padding(padding: const EdgeInsets.only(left: 8), child: SizedBox(
                        width: 55, height: 78,
                        child: manga.capa == null || manga.capa!.isEmpty
                          ? const Icon(Icons.menu_book, size: 35,
                              color: Color.fromARGB(255, 81, 49, 134))
                          : ClipRRect(borderRadius: BorderRadius.circular(5),
                              child: Image.network(manga.capa!, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.menu_book))),
                      )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(manga.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text('Nota: ${manga.nota} | Progresso: ${manga.progresso}%'),
                          // Wrap evita que os botões ultrapassem a tela do celular
                          Wrap(spacing: 0, runSpacing: 0, children: [
                            IconButton(tooltip: 'Avaliar', icon: const Icon(Icons.star, color: Color.fromARGB(255, 255, 191, 0)),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => ReviewPage(mangaTitle: manga.titulo)))
                                .then((_) => _carregarMangas())),
                            IconButton(tooltip: 'Acompanhar leitura', icon: const Icon(Icons.auto_stories, color: Color.fromARGB(255, 31, 92, 33)),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => ReadingProgressPage(mangaTitle: manga.titulo)))
                                .then((_) => _carregarMangas())),
                            IconButton(tooltip: 'Editar', icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarManga(manga)),
                            IconButton(tooltip: 'Excluir', icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirManga(manga)),
                          ]),
                        ]),
                      )),
                    ]),
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 81, 49, 134),
        onPressed: _adicionarManga,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
