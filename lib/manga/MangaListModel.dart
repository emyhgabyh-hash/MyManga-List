import 'MangaModel.dart';

class MangaListModel {
  final List<MangaModel> mangas;
  const MangaListModel({required this.mangas});
  factory MangaListModel.fromJson(Map<String, dynamic> json) {
    final lista = json['data'] as List<dynamic>? ?? [];
    return MangaListModel(mangas: lista.map((e) =>
      MangaModel.fromJson(e as Map<String, dynamic>)).toList());
  }
}