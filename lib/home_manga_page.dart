
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
  // Controller responsável pelas operações no SQLite
  final MangaController _controller = MangaController();

  // Lista que recebe os mangás cadastrados
  List<Manga> mangas = [];

  @override
  void initState() {
    super.initState();

    // Carrega os mangás salvos quando a tela abre
    _carregarMangas();
  }

  // Busca os mangás cadastrados no banco de dados
  Future<void> _carregarMangas() async {
    final lista = await _controller.listarMangas();

    if (mounted) {
      setState(() => mangas = lista);
    }
  }

  // Abre a janela para adicionar ou editar um mangá INPUT
  Future<void> _dialogoManga({Manga? manga}) async {
    final tituloController = TextEditingController(
      text: manga?.titulo ?? '',
    );

    // Mostra a janela para digitar o título
    final titulo = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          manga == null ? 'Adicionar mangá' : 'Editar mangá',
          style: GoogleFonts.modak(),
        ),

        // Campo para digitar o nome do mangá INPUT
        content: TextField(
          controller: tituloController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome do mangá',
            border: OutlineInputBorder(),
          ),
        ),

        actions: [
          // Fecha a janela sem salvar
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),

          // Retorna o título digitado
          ElevatedButton(
            onPressed: () {
              if (tituloController.text.trim().isNotEmpty) {
                Navigator.pop(
                  dialogContext,
                  tituloController.text.trim(),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    // Libera o controller do campo de texto
    tituloController.dispose();

    if (titulo == null) return;

    if (manga == null) {
      // Cadastra um novo mangá no SQLite
      await _controller.adicionarManga(
        Manga(titulo: titulo),
      );
    } else {
      // Atualiza os dados sem perder capa e anotações
      await _controller.atualizarManga(
        Manga(
          id: manga.id,
          titulo: titulo,
          nota: manga.nota,
          progresso: manga.progresso,
          capa: manga.capa,
          anotacoes: manga.anotacoes,
        ),
      );
    }

    // Atualiza a biblioteca depois de salvar
    await _carregarMangas();
  }

  // Exclui um mangá da biblioteca
  Future<void> _excluirManga(Manga manga) async {
    if (manga.id == null) return;

    await _controller.excluirManga(manga.id!);

    // Atualiza a lista depois da exclusão
    await _carregarMangas();
  }

  @override
  Widget build(BuildContext context) {
    const roxo = Color.fromARGB(255, 81, 49, 134);

    return Scaffold(
      // Barra superior da biblioteca LAYOUT
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Meus Mangás',
          style: GoogleFonts.modak(),
        ),
        actions: [
          // Abre a pesquisa de mangás na Kitsu NAVEGAÇÃO
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar na Kitsu',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MangaUI(),
                ),
              );

              // Atualiza a biblioteca ao voltar da pesquisa
              await _carregarMangas();
            },
          ),

          // Botão para sair da biblioteca NAVEGAÇÃO
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      // Verifica se existem mangás cadastrados
      body: mangas.isEmpty
          ? const Center(
              child: Text(
                'Nenhum mangá adicionado. Use + ou a pesquisa.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: mangas.length,
              itemBuilder: (context, index) {
                final manga = mangas[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    // Abre a coleção particular do mangá NAVEGAÇÃO
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ColecaoMangaPage(
                            manga: manga,
                          ),
                        ),
                      );

                      // Atualiza os dados ao voltar da coleção
                      await _carregarMangas();
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Mostra a capa salva no SQLite LAYOUT
                          SizedBox(
                            width: 65,
                            height: 92,
                            child: manga.capa == null ||
                                    manga.capa!.isEmpty
                                ? const Icon(
                                    Icons.menu_book,
                                    size: 42,
                                    color: roxo,
                                  )
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(5),
                                    child: Image.network(
                                      manga.capa!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(
                                        Icons.menu_book,
                                        color: roxo,
                                      ),
                                    ),
                                  ),
                          ),

                          const SizedBox(width: 12),

                          // Mostra as informações do mangá LAYOUT
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  manga.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Nota: ${manga.nota} | '
                                  'Leitura: ${manga.progresso}%',
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Toque para abrir a coleção',
                                  style: TextStyle(
                                    color: roxo,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Botões para editar e excluir
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Editar',
                                onPressed: () =>
                                    _dialogoManga(manga: manga),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Excluir',
                                onPressed: () => _excluirManga(manga),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      // Botão para cadastrar um mangá manualmente INPUT
      floatingActionButton: FloatingActionButton(
        backgroundColor: roxo,
        onPressed: () => _dialogoManga(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
