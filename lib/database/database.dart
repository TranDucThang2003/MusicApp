import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/song.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("favorites.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE songs(
    id INTEGER PRIMARY KEY,
    song_name TEXT,
    song_artist TEXT,
    audio_url TEXT,
    background_url TEXT,
    is_favorite INTEGER
    )
    ''');
  }

  Future<void> insertSongs(List<Song> songs) async {
    final db = await instance.database;

    Batch batch = db.batch();

    for (var song in songs) {
      batch.insert(
        'songs',
        song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertIfNotExists(Song song) async {
    final db = await instance.database;

    final existing = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [song.id],
    );

    if (existing.isEmpty) {
      await db.insert('songs', song.toMap());
    }
  }

  Future<List<Song>> getSongs() async {
    final db = await instance.database;
    final result = await db.query('songs');
    return result.map((map) => Song.fromMap(map)).toList();
  }

  Future<List<Song>> getFavoriteSongs() async {
    final db = await instance.database;
    final result = await db.query('songs', where: 'is_favorite = 1');
    return result.map((map) => Song.fromMap(map)).toList();
  }

  Future<void> favoriteSong(int id, bool isFavorite) async {
    final db = await instance.database;
    await db.update(
      'songs',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSong(int id) async {
    final db = await instance.database;
    await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }
}
