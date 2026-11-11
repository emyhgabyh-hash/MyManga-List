
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/manga.dart'; // Importa o Model do mangá
import 'models/item_colecao.dart'; // Importa o Model dos itens da coleção
import 'database/database_helper.dart'; // Importa o banco de dados
import 'review_page.dart'; // Importa a tela de avaliação
import 'reading_page.dart'; // Importa a tela de progresso de leitura

// Tela responsável por organizar a coleção de cada mangá LAYOUT
class ColecaoMangaPage extends StatefulWidget {

  // Recebe os dados do mangá selecionado
  final Manga manga;

  const ColecaoMangaPage({
    super.key,
    required this.manga,
  });

  @override
  State<ColecaoMangaPage> createState() => _ColecaoMangaPageState();
}

class _ColecaoMangaPageState extends State<ColecaoMangaPage> {

  // Acessa as funções do banco de dados SQLite
  final _db = DatabaseHelper.instance;

  // Controller para capturar o volume digitado INPUT
  final _itemController = TextEditingController();

  // Controller para capturar as anotações pessoais INPUT
  final _notasController = TextEditingController();

  // Lista que recebe os volumes cadastrados no banco
  List<ItemColecao> _itens = [];

  // Controla o estado do botão de salvar anotações
  bool _salvandoNotas = false;

  // Guarda os dados do mangá aberto
  late Manga _manga;

  @override
  void initState() {
    super.initState();

    // Recebe o mangá enviado pela tela principal
    _manga = widget.manga;

    // Carrega as anotações que já foram salvas
    _notasController.text = _manga.anotacoes;

    // Carrega os itens da coleção ao abrir a página
    _carregar();
  }

  // Busca os volumes e os dados atualizados do mangá no SQLite
  Future<void> _carregar() async {

    // Busca os itens pertencentes ao mangá selecionado
    final itens = await _db.listarItens(_manga.id!);

    // Busca os mangás cadastrados no banco
    final mangas = await _db.getMangas();

    // Verifica se a página ainda está aberta
    if (!mounted) return;

    // Atualiza as informações mostradas na tela
    setState(() {
      _itens = itens;

      // Procura o mangá atual para atualizar seus dados
      for (final m in mangas) {
        if (m.id == _manga.id) {
          _manga = m;
          break;
        }
      }
    });
  }

  // Adiciona um novo volume ou item à lista de compras INPUT
  Future<void> _adicionarItem() async {

    // Pega o texto digitado e remove espaços desnecessários
    final descricao = _itemController.text.trim();

    // Não permite adicionar um item vazio
    if (descricao.isEmpty) return;

    // Salva o novo item relacionado ao mangá atual no SQLite
    await _db.adicionarItem(
      ItemColecao(
        mangaId: _manga.id!,
        descricao: descricao,
      ),
    );

    // Limpa o campo depois de adicionar
    _itemController.clear();

    // Atualiza a lista mostrada na tela
    await _carregar();
  }

  // Marca ou desmarca um volume como comprado INPUT
  Future<void> _marcar(ItemColecao item, bool marcado) async {

    // Atualiza o estado de compra do item no banco de dados
    await _db.atualizarItem(
      ItemColecao(
        id: item.id,
        mangaId: item.mangaId,
        descricao: item.descricao,
        comprado: marcado,
      ),
    );

    // Atualiza a lista depois da alteração
    await _carregar();
  }

  // Exclui um volume da lista de compras
  Future<void> _excluir(ItemColecao item) async {

    // Exclui o item pelo ID e pelo ID do mangá
    await _db.excluirItem(
      item.id!,
      item.mangaId,
    );

    // Atualiza a lista depois da exclusão
    await _carregar();
  }

  // Salva as anotações pessoais do mangá no SQLite INPUT
  Future<void> _salvarNotas() async {

    // Indica que o aplicativo está salvando as anotações
    setState(() => _salvandoNotas = true);

    try {

      // Atualiza o campo de anotações do mangá no banco
      await _db.atualizarAnotacoes(
        _manga.id!,
        _notasController.text,
      );

      // Verifica se a página continua aberta
      if (!mounted) return;

      // Mostra uma mensagem confirmando que foi salvo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anotações salvas!'),
        ),
      );

      // Atualiza os dados da página
      await _carregar();

    } finally {

      // Libera o botão depois que o salvamento termina
      if (mounted) {
        setState(() => _salvandoNotas = false);
      }
    }
  }

  @override
  void dispose() {

    // Libera os controllers quando a página é fechada
    _itemController.dispose();
    _notasController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Conta quantos itens já foram comprados
    final comprados = _itens.where((i) => i.comprado).length;

    // Calcula a porcentagem de itens comprados
    final porcentagem = _itens.isEmpty
        ? 0.0
        : comprados / _itens.length;

    // Cor principal utilizada na tela
    const roxo = Color.fromARGB(255, 81, 49, 134);

    return Scaffold(

      // Barra superior da coleção LAYOUT
      appBar: AppBar(
        title: Text(
          'Minha coleção',
          style: GoogleFonts.modak(),
        ),
      ),

      // Lista os elementos da página verticalmente LAYOUT
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // LAYOUT: mostra a capa e as informações do mangá
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Exibe a capa salva no SQLite
              SizedBox(
                width: 100,
                height: 145,
                child: _manga.capa == null || _manga.capa!.isEmpty
                    ? const Icon(
                        Icons.menu_book,
                        size: 70,
                        color: roxo,
                      )
                    : Image.network(
                        _manga.capa!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(
                          Icons.menu_book,
                          size: 70,
                        ),
                      ),
              ),

              const SizedBox(width: 16),

              // Organiza o título e o progresso da coleção
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Nome do mangá selecionado
                    Text(
                      _manga.titulo,
                      style: GoogleFonts.modak(
                        fontSize: 25,
                        color: roxo,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Mostra a quantidade de itens comprados
                    Text(
                      '$comprados de ${_itens.length} itens comprados',
                    ),

                    const SizedBox(height: 8),

                    // Barra que representa o progresso das compras
                    LinearProgressIndicator(
                      value: porcentagem,
                      minHeight: 9,
                      backgroundColor: Colors.deepPurple.shade100,
                      valueColor: const AlwaysStoppedAnimation(roxo),
                    ),

                    const SizedBox(height: 8),

                    // Mostra a porcentagem da coleção concluída
                    Text(
                      '${(porcentagem * 100).round()}% da coleção',
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // NAVEGAÇÃO: mantém acesso às telas de avaliação e leitura
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [

              // Botão que abre a tela de avaliação
              OutlinedButton.icon(
                icon: const Icon(Icons.star),
                label: const Text('Avaliar'),
                onPressed: () async {

                  // Abre a tela de avaliação NAVEGAÇÃO
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewPage(
                        mangaTitle: _manga.titulo,
                      ),
                    ),
                  );

                  // Atualiza os dados ao voltar
                  await _carregar();
                },
              ),

              // Botão que abre a tela de progresso de leitura
              OutlinedButton.icon(
                icon: const Icon(Icons.auto_stories),
                label: const Text('Progresso de leitura'),
                onPressed: () async {

                  // Abre a tela de leitura NAVEGAÇÃO
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReadingProgressPage(
                        mangaTitle: _manga.titulo,
                      ),
                    ),
                  );

                  // Atualiza os dados ao voltar
                  await _carregar();
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Título da lista de compras LAYOUT
          Text(
            'Lista de compras',
            style: GoogleFonts.modak(
              fontSize: 25,
              color: roxo,
            ),
          ),

          const Text(
            'Marque os volumes que você já comprou.',
          ),

          const SizedBox(height: 10),

          // INPUT: campo para adicionar volumes ou edições especiais
          Row(
            children: [

              // Campo para digitar o nome do volume INPUT
              Expanded(
                child: TextField(
                  controller: _itemController,
                  textInputAction: TextInputAction.done,

                  // Adiciona o item quando o usuário confirma pelo teclado
                  onSubmitted: (_) => _adicionarItem(),

                  decoration: const InputDecoration(
                    labelText: 'Ex.: Volume 01',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Botão para adicionar o volume à lista INPUT
              IconButton(
                onPressed: _adicionarItem,
                icon: const Icon(
                  Icons.add_circle,
                  color: roxo,
                ),
                tooltip: 'Adicionar volume',
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Mensagem exibida quando a lista ainda está vazia
          if (_itens.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sua lista está vazia. Adicione o primeiro volume!',
              ),
            ),

          // Mostra todos os volumes cadastrados na lista LAYOUT
          ..._itens.map(
            (item) => Card(
              child: Row(
                children: [

                  // Checkbox para marcar se o volume foi comprado INPUT
                  Checkbox(
                    value: item.comprado,
                    onChanged: (v) => _marcar(
                      item,
                      v ?? false,
                    ),
                  ),

                  // Mostra a descrição do volume
                  Expanded(
                    child: Text(
                      item.descricao,

                      // Risca o texto quando o volume está comprado
                      style: TextStyle(
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),

                  // Botão para excluir um volume da lista
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Excluir item',
                    onPressed: () => _excluir(item),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Título da área de anotações pessoais LAYOUT
          Text(
            'Minhas anotações',
            style: GoogleFonts.modak(
              fontSize: 25,
              color: roxo,
            ),
          ),

          const SizedBox(height: 8),

          // INPUT: bloco de notas pessoal de cada mangá
          TextField(
            controller: _notasController,
            minLines: 5,
            maxLines: 12,
            decoration: const InputDecoration(
              hintText:
                  'Preços, lojas, volumes faltantes, edições especiais...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 10),

          // Botão para salvar as anotações no SQLite INPUT
          ElevatedButton.icon(
            onPressed: _salvandoNotas ? null : _salvarNotas,
            icon: const Icon(Icons.save),
            label: const Text('Salvar anotações'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
