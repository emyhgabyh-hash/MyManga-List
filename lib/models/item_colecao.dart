
 // MODEL: representa um volume ou item da lista de compras de um mangá

class ItemColecao {
  // Identifica cada item cadastrado no banco de dados
  final int? id;

  // Identifica a qual mangá esse item pertence
  final int mangaId;

  // Guarda a descrição do volume ou item
  final String descricao;

  // Informa se o item já foi comprado
  final bool comprado;

  // Construtor da classe MODEL
  const ItemColecao({
    this.id,
    required this.mangaId,
    required this.descricao,
    this.comprado = false,
  });

  // Converte o objeto ItemColecao em Map
  // Esse formato é utilizado para salvar os dados no SQLite DATABASE
  Map<String, dynamic> toMap() => {
    'id': id,
    'manga_id': mangaId,
    'descricao': descricao,

    // O SQLite armazena o valor booleano como número
    // 1 significa comprado e 0 significa não comprado
    'comprado': comprado ? 1 : 0,
  };

  // Converte os dados recebidos do banco em um objeto ItemColecao
  factory ItemColecao.fromMap(Map<String, dynamic> map) => ItemColecao(
    id: map['id'] as int?,
    mangaId: map['manga_id'] as int,
    descricao: map['descricao'] as String,

    // Converte o número armazenado no banco para verdadeiro ou falso
    comprado: (map['comprado'] as int) == 1,
  );
}
