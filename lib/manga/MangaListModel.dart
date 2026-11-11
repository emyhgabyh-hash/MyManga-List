
// MODEL: organiza a lista de mangás recebida da API Kitsu.
import 'MangaModel.dart';

class MangaListModel {
  final List<MangaModel> mangas;

  const MangaListModel({required this.mangas});

  // Converte a resposta JSON em uma lista de objetos MangaModel API
  factory MangaListModel.fromJson(Map<String, dynamic> json) {
    // Pega a lista de resultados recebida no campo data
    final lista = json['data'] as List<dynamic>? ?? [];

    // Converte cada resultado em um objeto MangaModel
    return MangaListModel(
      mangas: lista.map((e) =>
          MangaModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
