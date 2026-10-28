// MODEL: informações recebidas da API Kitsu
class MangaModel {
  final String id;
  final String titulo;
  final String sinopse;
  final String? capa;
  final double? score;
  final int? capitulos;

  const MangaModel({required this.id, required this.titulo,
    required this.sinopse, this.capa, this.score, this.capitulos});

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    final a = (json['attributes'] as Map<String, dynamic>?) ?? {};
    final titulos = a['titles'] as Map<String, dynamic>?;
    final tituloPt = titulos?['pt'] ?? titulos?['pt_br'];
    final media = double.tryParse('${a['averageRating'] ?? ''}');
    final imagens = a['posterImage'] as Map<String, dynamic>?;
    // Usa a imagem original primeiro; tenta outras resoluções como alternativa.
    String? capa;
    for (final key in ['original', 'large', 'medium', 'small', 'tiny']) {
      final url = imagens?[key]?.toString();
      if (url != null && url.startsWith('http')) { capa = url; break; }
    }
    return MangaModel(
      id: '${json['id']}',
      titulo: (tituloPt ?? a['canonicalTitle'] ?? 'Sem título').toString(),
      sinopse: (a['synopsis'] ?? 'Sinopse não disponível.').toString(),
      capa: capa,
      score: media == null ? null : media / 10,
      capitulos: (a['chapterCount'] as num?)?.toInt(),
    );
  }
}