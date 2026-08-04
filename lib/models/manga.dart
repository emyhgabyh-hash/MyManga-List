class Manga {
  int? id;
  String titulo;
  int nota;
  int progresso;

  // Construtor da classe
  Manga({
    this.id,
    required this.titulo,
    this.nota = 0,
    this.progresso = 0,
  });

  // Converte um objeto Manga para Map (usado pelo SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'nota': nota,
      'progresso': progresso,
    };
  }

  // Converte um Map vindo do SQLite para um objeto Manga
  factory Manga.fromMap(Map<String, dynamic> map) {
    return Manga(
      id: map['id'],
      titulo: map['titulo'],
      nota: map['nota'],
      progresso: map['progresso'],
    );
  }
}