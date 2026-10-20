//DATABASE é responsável por conversar diretamente com o banco SQLite

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/manga.dart';

class DatabaseHelper {
  // Instância única da classe
  // Garante que o aplicativo utilize uma única instância do DatabaseHelper,
  // para evitar criar várias conexões diferentes
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  // Retorna o banco de dados
  Future<Database> get database async {
    // Verifica se o banco já foi inicializado,
    // caso não exista ele inicia um novo banco
    if (_database != null) return _database!;
    _database = await _initDB('mymanga.db');
    return _database!;
  }

  // Cria o banco
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // Abrir ou criar o banco de dados
    return await openDatabase(
      path,
      // Define a versão do banco
      version: 1,
       // cria a tabela quando o banco é criado pela primeira vez
      onCreate: _createDB,
    );
  }

  // Cria a tabela
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mangas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        nota INTEGER NOT NULL,
        progresso INTEGER NOT NULL
      )
    ''');
  }

   // Cria um novo registro na tabela de mangás
  Future<int> insertManga(Manga manga) async {
    final db = await instance.database;
    // Insere os dados do objeto Manga na tabela
    return await db.insert(
      'mangas',
      manga.toMap(),
    );
  }

  // Busca os registros armazenados
  Future<List<Manga>> getMangas() async {
    final db = await instance.database;
    //Consulta os registros
    final result = await db.query('mangas');
    // Converte para objetos
    return result.map((json) => Manga.fromMap(json)).toList();
  }

  // Atualiza o registo
  Future<int> updateManga(Manga manga) async {
    final db = await instance.database;
    // Atualiza os dados
    return await db.update(
      'mangas',
      manga.toMap(),
      // Atualiza somente o ID
      where: 'id = ?',
      whereArgs: [manga.id],
    );
  }

  // Deletar um mangá
  Future<int> deleteManga(int id) async {
    final db = await instance.database;
    //Remove com base no ID informado
    return await db.delete(
      'mangas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fecha o banco
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}