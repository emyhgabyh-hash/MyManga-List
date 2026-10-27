// CONTROLLER: controla as operações com o banco SQLite
import '../database/database_helper.dart';
import '../models/manga.dart';

class MangaController {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> adicionarManga(Manga manga) async {
    return _databaseHelper.insertManga(manga);
  }

  Future<List<Manga>> listarMangas() async {
    return _databaseHelper.getMangas();
  }

  Future<int> atualizarManga(Manga manga) async {
    // Mantém a capa quando avaliação ou progresso atualizam o mangá.
    if (manga.capa == null && manga.id != null) {
      final lista = await _databaseHelper.getMangas();
      for (final salvo in lista) {
        if (salvo.id == manga.id) {
          manga.capa = salvo.capa;
          break;
        }
      }
    }
    return _databaseHelper.updateManga(manga);
  }

  Future<int> excluirManga(int id) async {
    return _databaseHelper.deleteManga(id);
  }
}
