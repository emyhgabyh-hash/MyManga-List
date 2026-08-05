import '../database/database_helper.dart';
import '../models/manga.dart';

class MangaController {
  // Instância do banco de dados
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Adiciona um novo mangá
  Future<int> adicionarManga(Manga manga) async {
    return await _databaseHelper.insertManga(manga);
  }

  // Lista todos os mangás
  Future<List<Manga>> listarMangas() async {
    return await _databaseHelper.getMangas();
  }

  // Atualiza um mangá
  Future<int> atualizarManga(Manga manga) async {
    return await _databaseHelper.updateManga(manga);
  }

  // Remove um mangá pelo ID
  Future<int> excluirManga(int id) async {
    return await _databaseHelper.deleteManga(id);
  }
}