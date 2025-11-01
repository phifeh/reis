import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'travel_journal.db');

    return await openDatabase(path, version: 2, onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL,
        type TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        altitude REAL,
        accuracy REAL,
        location_timestamp INTEGER,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE moments (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT DEFAULT 'auto',
        parent_moment_id TEXT,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        center_lat REAL,
        center_lon REAL,
        radius_meters REAL DEFAULT 100,
        event_count INTEGER DEFAULT 0,
        settings TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (parent_moment_id) REFERENCES moments(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE moment_events (
        moment_id TEXT NOT NULL,
        event_id TEXT NOT NULL,
        assigned_at INTEGER NOT NULL,
        assignment_type TEXT DEFAULT 'auto',
        PRIMARY KEY (moment_id, event_id),
        FOREIGN KEY (moment_id) REFERENCES moments(id) ON DELETE CASCADE,
        FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_timestamp ON events(timestamp)');
    await db.execute('CREATE INDEX idx_created_at ON events(created_at)');
    await db.execute('CREATE INDEX idx_start_time ON moments(start_time)');
    await db.execute(
        'CREATE INDEX idx_moments_time ON moments(start_time, end_time)');
    await db.execute(
        'CREATE INDEX idx_moments_location ON moments(center_lat, center_lon)');
    await db
        .execute('CREATE INDEX idx_moment_id ON moment_events(moment_id)');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE moments ADD COLUMN parent_moment_id TEXT');
      await db.execute('ALTER TABLE moments ADD COLUMN center_lat REAL');
      await db.execute('ALTER TABLE moments ADD COLUMN center_lon REAL');
      await db.execute(
          'ALTER TABLE moments ADD COLUMN radius_meters REAL DEFAULT 100');
      await db.execute(
          'ALTER TABLE moments ADD COLUMN event_count INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE moments ADD COLUMN settings TEXT');
      await db.execute(
          'ALTER TABLE moments ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0');
      await db.execute(
          'ALTER TABLE moment_events ADD COLUMN assigned_at INTEGER NOT NULL DEFAULT 0');
      await db.execute(
          'ALTER TABLE moment_events ADD COLUMN assignment_type TEXT DEFAULT "auto"');

      await db.execute(
          'CREATE INDEX idx_moments_time ON moments(start_time, end_time)');
      await db.execute(
          'CREATE INDEX idx_moments_location ON moments(center_lat, center_lon)');
    }
  }
}
