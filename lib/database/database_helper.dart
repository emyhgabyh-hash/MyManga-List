// DATABASE: salva os mangás no SQLite
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/manga.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mymanga.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Acrescenta a capa sem excluir os mangás já salvos
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE mangas ADD COLUMN capa TEXT');
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE mangas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        nota INTEGER NOT NULL,
        progresso INTEGER NOT NULL,
        capa TEXT
      )
    """);
  }

  Future<int> insertManga(Manga manga) async {
    final db = await database;
    return db.insert('mangas', manga.toMap());
  }

  Future<List<Manga>> getMangas() async {
    final db = await database;
    final result = await db.query('mangas');
    return result.map((json) => Manga.fromMap(json)).toList();
  }

  Future<int> updateManga(Manga manga) async {
    final db = await database;
    return db.update('mangas', manga.toMap(), where: 'id = ?', whereArgs: [manga.id]);
  }

  Future<int> deleteManga(int id) async {
    final db = await database;
    return db.delete('mangas', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
