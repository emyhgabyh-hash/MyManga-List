// MODEL: representa um mangá recebido da Kitsu
class MangaModel {
  final String id;
  final String titulo;
  final String sinopse;
  final String? capa;
  final double? score;
  final int? capitulos;

  MangaModel({required this.id, required this.titulo, required this.sinopse,
    this.capa, this.score, this.capitulos});

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    final a = (json['attributes'] as Map<String, dynamic>?) ?? {};
    final titulos = a['titles'] as Map<String, dynamic>?;
    // Prefere o título em português quando existir na API
    final tituloPt = titulos?['pt'] ?? titulos?['pt_br'];
    final media = double.tryParse('${a['averageRating'] ?? ''}');
    final imagens = a['posterImage'] as Map<String, dynamic>?;
    return MangaModel(
      id: '${json['id']}',
      titulo: (tituloPt ?? a['canonicalTitle'] ?? 'Sem título').toString(),
      sinopse: (a['synopsis'] ?? 'Sinopse não disponível.').toString(),
      capa: (imagens?['small'] ?? imagens?['medium'] ?? imagens?['original'])?.toString(),
      score: media == null ? null : media / 10,
      capitulos: (a['chapterCount'] as num?)?.toInt(),
    );
  }
}
