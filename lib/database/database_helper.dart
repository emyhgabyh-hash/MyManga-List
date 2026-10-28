// DATABASE: banco SQLite, com migração que preserva os registros anteriores
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/manga.dart';
import '../models/item_colecao.dart';

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
    return openDatabase(
      join(dbPath, filePath),
      version: 3,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE mangas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          nota INTEGER NOT NULL DEFAULT 0,
          progresso INTEGER NOT NULL DEFAULT 0,
          capa TEXT,
          anotacoes TEXT NOT NULL DEFAULT ''
        )''');
        await _criarTabelaItens(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Verifica as colunas existentes para funcionar tanto com v1 quanto v2.
        final colunas = await db.rawQuery('PRAGMA table_info(mangas)');
        final nomes = colunas.map((c) => c['name'].toString()).toSet();
        if (!nomes.contains('capa')) {
          await db.execute('ALTER TABLE mangas ADD COLUMN capa TEXT');
        }
        if (!nomes.contains('anotacoes')) {
          await db.execute("ALTER TABLE mangas ADD COLUMN anotacoes TEXT NOT NULL DEFAULT ''");
        }
        await _criarTabelaItens(db);
      },
    );
  }

  Future<void> _criarTabelaItens(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS itens_colecao (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      manga_id INTEGER NOT NULL,
      descricao TEXT NOT NULL,
      comprado INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (manga_id) REFERENCES mangas(id) ON DELETE CASCADE
    )''');
  }

  Future<int> insertManga(Manga manga) async {
    final db = await database;
    return db.insert('mangas', manga.toMap());
  }

  Future<List<Manga>> getMangas() async {
    final db = await database;
    final result = await db.query('mangas', orderBy: 'id DESC');
    return result.map(Manga.fromMap).toList();
  }

  Future<int> updateManga(Manga manga) async {
    final db = await database;
    return db.update('mangas', manga.toMap(), where: 'id = ?', whereArgs: [manga.id]);
  }

  Future<int> deleteManga(int id) async {
    final db = await database;
    return db.delete('mangas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> atualizarAnotacoes(int mangaId, String texto) async {
    final db = await database;
    return db.update('mangas', {'anotacoes': texto}, where: 'id = ?', whereArgs: [mangaId]);
  }

  Future<List<ItemColecao>> listarItens(int mangaId) async {
    final db = await database;
    final rows = await db.query('itens_colecao',
      where: 'manga_id = ?', whereArgs: [mangaId], orderBy: 'id ASC');
    return rows.map(ItemColecao.fromMap).toList();
  }

  Future<int> adicionarItem(ItemColecao item) async {
    final db = await database;
    return db.insert('itens_colecao', item.toMap());
  }

  Future<int> atualizarItem(ItemColecao item) async {
    final db = await database;
    return db.update('itens_colecao', item.toMap(),
      where: 'id = ? AND manga_id = ?', whereArgs: [item.id, item.mangaId]);
  }

  Future<int> excluirItem(int itemId, int mangaId) async {
    final db = await database;
    return db.delete('itens_colecao', where: 'id = ? AND manga_id = ?',
      whereArgs: [itemId, mangaId]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
