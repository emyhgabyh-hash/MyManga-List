// MODEL: um volume ou item da lista de compras de um mangá
class ItemColecao {
  final int? id;
  final int mangaId;
  final String descricao;
  final bool comprado;

  const ItemColecao({this.id, required this.mangaId,
    required this.descricao, this.comprado = false});

  Map<String, dynamic> toMap() => {
    'id': id, 'manga_id': mangaId, 'descricao': descricao,
    'comprado': comprado ? 1 : 0,
  };

  factory ItemColecao.fromMap(Map<String, dynamic> map) => ItemColecao(
    id: map['id'] as int?, mangaId: map['manga_id'] as int,
    descricao: map['descricao'] as String,
    comprado: (map['comprado'] as int) == 1,
  );
}
