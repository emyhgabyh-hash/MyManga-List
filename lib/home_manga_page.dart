import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'review_page.dart'; // Importa a tela de avaliação
import 'reading_page.dart'; // Importa a tela de progresso da leitura
import 'models/manga.dart'; // Importa o Model do mangá
import 'controllers/manga_controller.dart'; // Importa o Controller dos mangás
import 'busca_manga_page.dart'; // NOVO: importa a tela de busca pela API

class HomeMangaPage extends StatefulWidget {
  const HomeMangaPage({super.key});
  @override
  State<HomeMangaPage> createState() => _HomeMangaPageState();
}
class _HomeMangaPageState extends State<HomeMangaPage> {
  // Controller usado para acessar o banco de dados
  final MangaController _mangaController = MangaController();
  // Lista que recebe os mangás salvos no banco
  List<Manga> mangas = [];
  // Carrega os mangás do banco de dados
  Future<void> _carregarMangas() async {
    final lista = await _mangaController.listarMangas();
    // Atualiza a lista de mangás mostrada na tela
    setState(() {
      mangas = lista;
    });
  }
  @override
  void initState() {
    super.initState();
    // Carrega os mangás assim que a tela abre
    _carregarMangas();
  }
  // Abre uma janela para adicionar um novo mangá
  void _adicionarManga() {
    // Controller para capturar o nome digitado INPUT
    final TextEditingController tituloController =
        TextEditingController();
    // Abre uma janela sobre a tela atual
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Adicionar Mangá",
            style: GoogleFonts.modak(),
          ),
          // Campo usado para digitar o nome do mangá INPUT
          content: TextField(
            controller: tituloController,
            decoration: const InputDecoration(
              labelText: "Nome do mangá",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            // Botão para cancelar INPUT
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha a janela NAVEGAÇÃO
              },
              child: const Text("Cancelar"),
            ),
            // Botão para adicionar INPUT
            ElevatedButton(
              onPressed: () async {
                // Verifica se o campo não está vazio
                if (tituloController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Digite o nome do mangá!"),
                    ),
                  );
                  return;
                }
                // Cria um novo objeto Manga
                final manga = Manga(
                  titulo: tituloController.text.trim(),
                  nota: 0,
                  progresso: 0,
                );
                // Salva o mangá no banco de dados
                await _mangaController.adicionarManga(manga);
                // Fecha a janela
                if (context.mounted) {
                  Navigator.pop(context);
                }
                // Atualiza a lista da tela
                _carregarMangas();
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }
  // Exclui um mangá do banco de dados
  Future<void> _excluirManga(Manga manga) async {
    // Verifica se o mangá possui um ID
    if (manga.id != null) {
      // Exclui o mangá usando o ID pelo Controller
      await _mangaController.excluirManga(manga.id!);
      // Atualiza a lista depois de excluir
      _carregarMangas();
      // Mostra uma mensagem confirmando a exclusão
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mangá excluído com sucesso!"),
        ),
      );
    }
  }
  // Abre uma janela para editar o mangá
  void _editarManga(Manga manga) {
    // Controller que recebe o título atual
    final TextEditingController tituloController =
        TextEditingController(text: manga.titulo);
    // Abre uma janela sobre a tela atual
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Editar Mangá",
            style: GoogleFonts.modak(),
          ),
          // Campo usado para alterar o nome do mangá INPUT
          content: TextField(
            controller: tituloController,
            decoration: const InputDecoration(
              labelText: "Nome do mangá",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            // Botão para cancelar INPUT
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha a janela NAVEGAÇÃO
              },
              child: const Text("Cancelar"),
            ),
            // Botão para salvar alteração INPUT
            ElevatedButton(
              onPressed: () async {
                // Verifica se o campo não está vazio
                if (tituloController.text.trim().isEmpty) {
                  return;
                }
                // Cria o objeto atualizado
                final mangaAtualizado = Manga(
                  id: manga.id,
                  titulo: tituloController.text.trim(),
                  nota: manga.nota,
                  progresso: manga.progresso,
                );
                // Atualiza o mangá no banco de dados
                await _mangaController.atualizarManga(mangaAtualizado);
                // Fecha a janela
                if (context.mounted) {
                  Navigator.pop(context);
                }
                // Atualiza a lista da tela
                _carregarMangas();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estrutura principal da tela
      appBar: AppBar(
        // Remove seta automática de voltar
        automaticallyImplyLeading: false,
        title: Text(
          "Meus Mangás",
          style: GoogleFonts.modak(),
        ),
        // Widgets no canto direito da AppBar
        actions: [ //Botão de pesquisa
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            tooltip: "Buscar mangás",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const BuscaMangaPage(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: mangas.isEmpty
            ? Center( //Mensagem de quando não existe mangá
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [ 
                    const Icon(
                      Icons.menu_book,
                      size: 80,
                      color: Color.fromARGB(
                        255,
                        81,
                        49,
                        134,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Nenhum mangá adicionado",
                      style: GoogleFonts.modak(
                        fontSize: 24,
                        color: const Color.fromARGB(
                          255,
                          81,
                          49,
                          134,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Clique no botão + para adicionar um mangá.",
                    ),
                  ],
                ),
              )
            : ListView.builder( //Lista dos mangás salvos no banco
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  // Pega o mangá correspondente à posição da lista
                  final manga = mangas[index];
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: ListTile(
                      // Ícone do mangá
                      leading: const Icon(
                        Icons.menu_book,
                        color: Color.fromARGB(
                          255,
                          81,
                          49,
                          134,
                        ),
                      ),
                      // Mostra o nome vindo do banco
                      title: Text(
                        manga.titulo,
                      ),
                      subtitle: Text(
                        "Nota: ${manga.nota} | Progresso: ${manga.progresso}%",
                      ),
                      // Coloca os botões de ação no lado direito
                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          IconButton( //Botão de avaliação
                            onPressed: () {
                              // Abre a tela de avaliação
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewPage(
                                    mangaTitle:
                                        manga.titulo,
                                  ),
                                ),
                              ).then((_) {
                                // Atualiza a lista ao voltar da avaliação
                                _carregarMangas();
                              });
                            },
                            icon: const Icon(
                              Icons.star,
                              color: Color.fromARGB(
                                255,
                                255,
                                191,
                                0,
                              ),
                            ),
                          ),
                          IconButton( //Botão de acompanhar leitura
                            onPressed: () {
                              // Abre a tela de leitura
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReadingProgressPage(
                                    mangaTitle:
                                        manga.titulo,
                                  ),
                                ),
                              ).then((_) {
                                // Atualiza a lista ao voltar
                                // da leitura
                                _carregarMangas();
                              });
                            },
                            icon: const Icon(
                              Icons.auto_stories,
                              color: Color.fromARGB(
                                255,
                                31,
                                92,
                                33,
                              ),
                            ),
                          ),
                          IconButton( //Botão d eeditar
                            onPressed: () {
                              _editarManga(manga);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton( //Botão de excluir
                            onPressed: () {
                              _excluirManga(manga);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton( //Botão d eadicionar manualmente
        backgroundColor: const Color.fromARGB(
          255,
          81,
          49,
          134,
        ),
        onPressed: _adicionarManga,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}