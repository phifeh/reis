import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class WearLocalStorage {
  static Database? _database;
  final _uuid = const Uuid();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reis_wear.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pending_audio (
            id TEXT PRIMARY KEY,
            file_path TEXT NOT NULL,
            duration INTEGER NOT NULL,
            timestamp INTEGER NOT NULL,
            synced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> savePendingAudio({
    required String filePath,
    required Duration duration,
  }) async {
    final db = await database;
    
    await db.insert(
      'pending_audio',
      {
        'id': _uuid.v4(),
        'file_path': filePath,
        'duration': duration.inSeconds,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingAudios() async {
    final db = await database;
    return await db.query(
      'pending_audio',
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> markAsSynced(String id) async {
    final db = await database;
    await db.update(
      'pending_audio',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getPendingCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM pending_audio WHERE synced = 0',
    );
    return result.first['count'] as int;
  }
}
