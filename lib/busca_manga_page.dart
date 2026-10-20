import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/jikan_service.dart';
import 'models/manga.dart';
import 'controllers/manga_controller.dart';

class BuscaMangaPage extends StatefulWidget {
  const BuscaMangaPage({super.key});

  @override
  State<BuscaMangaPage> createState() => _BuscaMangaPageState();
}

class _BuscaMangaPageState extends State<BuscaMangaPage> {
  final JikanService _jikanService = JikanService();
  final MangaController _mangaController =
      MangaController();

  final TextEditingController _buscaController =
      TextEditingController();

  List<dynamic> mangas = [];
  bool carregando = false;
  String? erro;

  Future<void> _buscarMangas() async {
    final texto = _buscaController.text.trim();
    if (texto.isEmpty) {
      return;
    }

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultados =
          await _jikanService.buscarMangas(texto);
      if (!mounted) return;

      setState(() {
        mangas = resultados;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Erro ao buscar mangás.';
        mangas = [];
      });

    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  Future<void> _adicionarManga(String titulo) async {
    final manga = Manga(
      titulo: titulo,
      nota: 0,
      progresso: 0,
    );

    await _mangaController.adicionarManga(manga);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$titulo foi adicionado à sua biblioteca!',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buscar Mangás',
          style: GoogleFonts.modak(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              decoration: const InputDecoration(
                labelText: 'Digite o nome do mangá',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) {
                _buscarMangas();
              },
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    carregando ? null : _buscarMangas,
                child: const Text(
                  'Pesquisar',
                ),
              ),
            ),

            const SizedBox(height: 15),
            if (carregando)
              const CircularProgressIndicator(),
            if (erro != null)
              Text(
                erro!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),

            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  final manga = mangas[index];
                  final String titulo =
                      manga['title'] ?? 'Sem título';
                  final String sinopse =
                      manga['synopsis'] ??
                      'Sinopse não disponível.';
                  final String? capa =
                      manga['images']?['jpg']?['image_url'];
                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          if (capa != null)
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8),
                              child: Image.network(
                                capa,
                                width: 80,
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) {
                                  return const SizedBox(
                                    width: 80,
                                    height: 110,
                                    child: Icon(
                                      Icons.menu_book,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            const SizedBox(
                              width: 80,
                              height: 110,
                              child: Icon(
                                Icons.menu_book,
                                size: 40,
                              ),
                            ),

                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  titulo,

                                  style: GoogleFonts.modak(
                                    fontSize: 20,
                                    color:
                                    const Color.fromARGB(
                                      255,
                                      81,
                                      49,
                                      134,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),
                                Text(
                                  sinopse,
                                  maxLines: 4,
                                  overflow:
                                      TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _adicionarManga(
                                      titulo,
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.add,
                                  ),

                                  label: const Text(
                                    'Adicionar',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}