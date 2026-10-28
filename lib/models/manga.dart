// MODEL: mangá salvo na biblioteca local
class Manga {
  int? id;
  String titulo;
  int nota;
  int progresso;
  String? capa;
  String anotacoes;

  Manga({this.id, required this.titulo, this.nota = 0, this.progresso = 0,
    this.capa, this.anotacoes = ''});

  Map<String, dynamic> toMap() => {
    'id': id, 'titulo': titulo, 'nota': nota, 'progresso': progresso,
    'capa': capa, 'anotacoes': anotacoes,
  };

  factory Manga.fromMap(Map<String, dynamic> map) => Manga(
    id: map['id'] as int?, titulo: map['titulo'] as String,
    nota: (map['nota'] as num?)?.toInt() ?? 0,
    progresso: (map['progresso'] as num?)?.toInt() ?? 0,
    capa: map['capa'] as String?,
    anotacoes: map['anotacoes'] as String? ?? '',
  );
}
