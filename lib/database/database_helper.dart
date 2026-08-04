import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/manga.dart';

class DatabaseHelper {
  // Instância única da classe (Singleton)
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Retorna o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mymanga.db');
    return _database!;
  }

  // Cria o banco
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
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

  // ===========================
  // CREATE
  // ===========================

  Future<int> insertManga(Manga manga) async {
    final db = await instance.database;

    return await db.insert(
      'mangas',
      manga.toMap(),
    );
  }

  // ===========================
  // READ
  // ===========================

  Future<List<Manga>> getMangas() async {
    final db = await instance.database;

    final result = await db.query('mangas');

    return result.map((json) => Manga.fromMap(json)).toList();
  }

  // ===========================
  // UPDATE
  // ===========================

  Future<int> updateManga(Manga manga) async {
    final db = await instance.database;

    return await db.update(
      'mangas',
      manga.toMap(),
      where: 'id = ?',
      whereArgs: [manga.id],
    );
  }

  // ===========================
  // DELETE
  // ===========================

  Future<int> deleteManga(int id) async {
    final db = await instance.database;

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