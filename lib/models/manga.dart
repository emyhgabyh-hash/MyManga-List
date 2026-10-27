// MODEL dos mangás salvos no SQLite
class Manga {
  int? id;
  String titulo;
  int nota;
  int progresso;
  String? capa;

  Manga({this.id, required this.titulo, this.nota = 0, this.progresso = 0, this.capa});

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'nota': nota,
    'progresso': progresso,
    'capa': capa,
  };

  factory Manga.fromMap(Map<String, dynamic> map) => Manga(
    id: map['id'] as int?,
    titulo: map['titulo'] as String,
    nota: (map['nota'] as num).toInt(),
    progresso: (map['progresso'] as num).toInt(),
    capa: map['capa'] as String?,
  );
}
