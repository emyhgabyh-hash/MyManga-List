import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'review_page.dart';
import 'reading_page.dart';
import 'models/manga.dart';
import 'controllers/manga_controller.dart';


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
    final TextEditingController tituloController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Adicionar Mangá",
            style: GoogleFonts.modak(),
          ),

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

      await _mangaController.excluirManga(manga.id!);

      // Atualiza a lista depois de excluir
      _carregarMangas();

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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          title: Text(
            "Editar Mangá",
            style: GoogleFonts.modak(),
          ),

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

    return Scaffold( // Estrutura principal da tela LAYOUT

      appBar: AppBar( // Barra superior LAYOUT

        automaticallyImplyLeading: false, // Remove seta automática de voltar LAYOUT

        title: Text(
          "Meus Mangás",
          style: GoogleFonts.modak(), // Fonte personalizada LAYOUT
        ),

        actions: [ // Widgets no canto direito da AppBar LAYOUT

          IconButton( // Botão de logout INPUT

            onPressed: () {
              Navigator.pop(context); // Volta para tela anterior NAVEGAÇÃO
            },

            icon: const Icon(
              Icons.logout, // Ícone de logout LAYOUT
            ),
          ),
        ],
      ),


      body: Padding( // Espaçamento interno nas bordas LAYOUT

        padding: const EdgeInsets.all(16),

        child: mangas.isEmpty

            // Mensagem quando ainda não existem mangás
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Icon(
                      Icons.menu_book,
                      size: 80,
                      color: Color.fromARGB(255, 81, 49, 134),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Nenhum mangá adicionado",
                      style: GoogleFonts.modak(
                        fontSize: 24,
                        color: const Color.fromARGB(255, 81, 49, 134),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Clique no botão + para adicionar um mangá.",
                    ),
                  ],
                ),
              )

            // Lista dos mangás salvos no banco
            : ListView.builder( // Cria lista dinâmica LAYOUT

                itemCount: mangas.length, // Quantidade de mangás LAYOUT

                itemBuilder: (context, index) {

                  final manga = mangas[index];

                  return Card( // Card visual para cada mangá LAYOUT

                    margin: const EdgeInsets.only(bottom: 15),

                    child: ListTile(

                      leading: const Icon(
                        Icons.menu_book, // Ícone do mangá LAYOUT
                        color: Color.fromARGB(255, 81, 49, 134),
                      ),

                      title: Text(
                        manga.titulo, // Mostra o nome vindo do banco LAYOUT
                      ),

                      subtitle: Text(
                        "Nota: ${manga.nota} | Progresso: ${manga.progresso}%",
                      ),

                      trailing: Row(

                        mainAxisSize: MainAxisSize.min, // Ocupa somente o espaço necessário

                        children: [

                          // Botão de avaliação INPUT
                          IconButton(

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(
                                    mangaTitle: manga.titulo,
                                  ),
                                ),
                              ).then((_) {
                                // Atualiza a lista ao voltar da avaliação
                                _carregarMangas();
                              });

                            },

                            icon: const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 191, 0),
                            ),
                          ),


                          // Botão de leitura INPUT
                          IconButton(

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadingProgressPage(
                                    mangaTitle: manga.titulo,
                                  ),
                                ),
                              ).then((_) {
                                // Atualiza a lista ao voltar da leitura
                                _carregarMangas();
                              });

                            },

                            icon: const Icon(
                              Icons.auto_stories,
                              color: Color.fromARGB(255, 31, 92, 33),
                            ),
                          ),


                          // Botão de editar INPUT
                          IconButton(

                            onPressed: () {
                              _editarManga(manga);
                            },

                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),


                          // Botão de excluir INPUT
                          IconButton(

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


      // Botão para adicionar mangá INPUT
      floatingActionButton: FloatingActionButton(

        backgroundColor: const Color.fromARGB(255, 81, 49, 134),

        onPressed: _adicionarManga,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}