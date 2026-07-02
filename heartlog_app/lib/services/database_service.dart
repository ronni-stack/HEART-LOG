import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/journal_entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'heartlog.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE entries(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            audioPath TEXT,
            durationSeconds INTEGER DEFAULT 0,
            mood TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isFavorite INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<List<JournalEntry>> getEntries() async {
    final db = await database;
    final maps = await db.query(
      'entries',
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<List<JournalEntry>> searchEntries(String query) async {
    final db = await database;
    final maps = await db.query(
      'entries',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<JournalEntry?> getEntry(String id) async {
    final db = await database;
    final maps = await db.query(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return JournalEntry.fromMap(maps.first);
  }

  Future<void> insertEntry(JournalEntry entry) async {
    final db = await database;
    await db.insert(
      'entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEntry(JournalEntry entry) async {
    final db = await database;
    await db.update(
      'entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteEntry(String id) async {
    final db = await database;
    await db.delete(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
