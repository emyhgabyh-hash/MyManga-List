// CONTROLLER: operações da biblioteca local
import '../database/database_helper.dart';
import '../models/manga.dart';

class MangaController {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> adicionarManga(Manga manga) => _databaseHelper.insertManga(manga);
  Future<List<Manga>> listarMangas() => _databaseHelper.getMangas();
  Future<int> excluirManga(int id) => _databaseHelper.deleteManga(id);

  Future<int> atualizarManga(Manga manga) async {
    // Preserva capa e anotações quando a tela de nota/leitura atualiza o registro.
    if (manga.id != null) {
      final lista = await _databaseHelper.getMangas();
      for (final salvo in lista) {
        if (salvo.id == manga.id) {
          manga.capa ??= salvo.capa;
          if (manga.anotacoes.isEmpty) manga.anotacoes = salvo.anotacoes;
          break;
        }
      }
    }
    return _databaseHelper.updateManga(manga);
  }
}