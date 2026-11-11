
// MODEL: apresenta as informações de um mangá recebido da API Kitsu.
class MangaModel {
  final String id;
  final String titulo;
  final String sinopse;
  final String? capa;
  final double? score;
  final int? capitulos;

  const MangaModel({
    required this.id,
    required this.titulo,
    required this.sinopse,
    this.capa,
    this.score,
    this.capitulos,
  });

  // Converte os dados JSON recebidos da API em um objeto MangaModel API
  factory MangaModel.fromJson(Map<String, dynamic> json) {
    // As informações principais ficam dentro de attributes
    final a = (json['attributes'] as Map<String, dynamic>?) ?? {};

    // Procura um título em português, caso esteja disponível
    final titulos = a['titles'] as Map<String, dynamic>?;
    final tituloPt = titulos?['pt'] ?? titulos?['pt_br'];

    // Converte a nota recebida para número
    final media = double.tryParse('${a['averageRating'] ?? ''}');

    // Pega os endereços das capas disponíveis
    final imagens = a['posterImage'] as Map<String, dynamic>?;

    // Procura uma imagem em diferentes resoluções
    String? capa;
    for (final key in ['original', 'large', 'medium', 'small', 'tiny']) {
      final url = imagens?[key]?.toString();

      if (url != null && url.startsWith('http')) {
        capa = url;
        break;
      }
    }

    // Cria o objeto com as informações recebidas
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