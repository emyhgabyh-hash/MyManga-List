// CONTROLLER serve para controlar as operações do aplicativo

import '../database/database_helper.dart'; // Importa o responsável pelo banco de dados
import '../models/manga.dart'; // Importa o Model Manga

class MangaController {

  // Instância do banco de dados
  // O Controller utiliza o DatabaseHelper para realizar as operações
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Cria um novo manga
  Future<int> adicionarManga(Manga manga) async {
    return await _databaseHelper.insertManga(manga);
  }

  // Lê os mangás cadastrados
  Future<List<Manga>> listarMangas() async {
    // Busca os dados e retorna uma lista
    return await _databaseHelper.getMangas();
  }

  // Atualiza o mangá
  Future<int> atualizarManga(Manga manga) async {
    return await _databaseHelper.updateManga(manga);
  }

  // Deleta um mangá pelo ID
  Future<int> excluirManga(int id) async {
    return await _databaseHelper.deleteManga(id);
  }
}