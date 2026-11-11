
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
  // Controller responsável por salvar os mangás no SQLite
  final _controller = MangaController();

  // Controller para capturar o nome digitado na pesquisa INPUT
  final _buscaController = TextEditingController();

  // Lista que recebe os mangás encontrados na API
  List<MangaModel> mangas = [];

  // Guarda as sinopses depois da tentativa de tradução
  final Map<String, String> sinopses = {};

  bool carregando = false;
  String? erro;

  // Identifica a pesquisa atual para evitar misturar resultados
  int _numeroBusca = 0;

  // Pesquisa mangás na API Kitsu API
  Future<void> _buscarMangas() async {
    final texto = _buscaController.text.trim();

    // Verifica se o campo está preenchido e se já não existe uma busca
    if (texto.isEmpty || carregando) return;

    final numero = ++_numeroBusca;

    setState(() {
      carregando = true;
      erro = null;
      mangas = [];
      sinopses.clear();
    });

    try {
      // Faz a requisição GET usando o endereço da Kitsu
      final json = await Remote.get(EndPoints.buscarMangas(texto));

      // Converte o JSON recebido em uma lista de mangás
      final lista = MangaListModel.fromJson(json);

      if (!mounted || numero != _numeroBusca) return;

      setState(() => mangas = lista.mangas);

      // Tenta traduzir as sinopses dos resultados encontrados
      for (final manga in lista.mangas) {
        Traducao.traduzir(manga.sinopse).then((texto) {
          if (mounted && numero == _numeroBusca) {
            setState(() => sinopses[manga.id] = texto);
          }
        });
      }
    } catch (e) {
      // Guarda o erro caso a pesquisa não funcione
      if (mounted) {
        setState(() {
          erro = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      // Finaliza o indicador de carregamento
      if (mounted) setState(() => carregando = false);
    }
  }

  // Salva o mangá escolhido no banco de dados SQLite
  Future<void> _adicionarManga(MangaModel manga) async {
    try {
      // Salva o título e o endereço da capa
      await _controller.adicionarManga(
        Manga(titulo: manga.titulo, capa: manga.capa),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${manga.titulo} adicionado à biblioteca!'),
        ),
      );
    } catch (e) {
      // Mostra uma mensagem caso não consiga salvar
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Libera o controller quando a tela é fechada
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const roxo = Color.fromARGB(255, 81, 49, 134);

    return Scaffold(
      // Barra superior da tela LAYOUT
      appBar: AppBar(
        title: Text('Buscar mangás', style: GoogleFonts.modak()),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo para digitar o nome do mangá INPUT
            TextField(
              controller: _buscaController,
              onSubmitted: (_) => _buscarMangas(),
              decoration: const InputDecoration(
                labelText: 'Nome do mangá',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Botão para iniciar a pesquisa INPUT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: carregando ? null : _buscarMangas,
                child: const Text('Pesquisar'),
              ),
            ),

            // Mostra uma barra enquanto a API responde
            if (carregando) const LinearProgressIndicator(),

            // Mostra uma mensagem caso aconteça um erro
            if (erro != null)
              Text(erro!, style: const TextStyle(color: Colors.red)),

            // Lista os resultados encontrados pela API LAYOUT
            Expanded(
              child: ListView.builder(
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  final manga = mangas[index];

                  return Card(
                    margin: const EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mostra a capa recebida da Kitsu
                          SizedBox(
                            width: 75,
                            height: 110,
                            child: manga.capa == null
                                ? const Icon(Icons.menu_book, size: 42)
                                : Image.network(
                                    manga.capa!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.menu_book, size: 42),
                                  ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Abre os detalhes do mangá NAVEGAÇÃO
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MangaUISingle(id: manga.id),
                                    ),
                                  ),
                                  child: Text(
                                    manga.titulo,
                                    style: GoogleFonts.modak(
                                      fontSize: 19,
                                      color: roxo,
                                    ),
                                  ),
                                ),

                                // Mostra a nota e a quantidade de capítulos
                                Text(
                                  'Nota: ${manga.score?.toStringAsFixed(1) ?? '-'}'
                                  ' | Capítulos: ${manga.capitulos ?? '?'}',
                                ),

                                const SizedBox(height: 5),

                                // Mostra a sinopse traduzida, quando disponível
                                Text(
                                  sinopses[manga.id] ?? 'Traduzindo sinopse…',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 8),

                                // Adiciona o mangá à biblioteca INPUT
                                ElevatedButton.icon(
                                  onPressed: () => _adicionarManga(manga),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Adicionar'),
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