import 'MangaModel.dart';

class MangaListModel {
  final List<MangaModel> mangas;

  MangaListModel({required this.mangas});

  factory MangaListModel.fromJson(Map<String, dynamic> json) {
    final lista = (json['data'] as List<dynamic>? ?? []);
    return MangaListModel(
      mangas: lista.map((e) => MangaModel.fromJson(e)).toList(),
    );
  }
}