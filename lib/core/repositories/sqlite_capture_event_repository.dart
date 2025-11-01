import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart';
import 'capture_event_repository.dart';
import 'database_helper.dart';

class SqliteCaptureEventRepository implements CaptureEventRepository {
  static const String _tableName = 'events';

  Future<Database> get database => DatabaseHelper.database;

  @override
  Future<void> save(CaptureEvent event) async {
    final db = await database;
    await db.insert(
      _tableName,
      _toMap(event),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<CaptureEvent?> findById(String id) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return _fromMap(results.first);
  }

  @override
  Future<List<CaptureEvent>> findAll() async {
    final db = await database;
    final results = await db.query(_tableName, orderBy: 'timestamp DESC');
    return results.map(_fromMap).toList();
  }

  @override
  Future<List<CaptureEvent>> findByTimeRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch
      ],
      orderBy: 'timestamp ASC',
    );
    return results.map(_fromMap).toList();
  }

  @override
  Future<List<CaptureEvent>> findByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final db = await database;
    final placeholders = List.filled(ids.length, '?').join(',');
    final results = await db.query(
      _tableName,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
    return results.map(_fromMap).toList();
  }

  @override
  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toMap(CaptureEvent event) {
    return {
      'id': event.id,
      'timestamp': event.timestamp.millisecondsSinceEpoch,
      'type': event.type.name,
      'latitude': event.location?.latitude,
      'longitude': event.location?.longitude,
      'altitude': event.location?.altitude,
      'accuracy': event.location?.accuracy,
      'location_timestamp':
          event.location?.timestamp?.millisecondsSinceEpoch,
      'data': jsonEncode(event.data),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  CaptureEvent _fromMap(Map<String, dynamic> map) {
    final location = map['latitude'] != null && map['longitude'] != null
        ? Location(
            latitude: map['latitude'] as double,
            longitude: map['longitude'] as double,
            altitude: map['altitude'] as double?,
            accuracy: map['accuracy'] as double?,
            timestamp: map['location_timestamp'] != null
                ? DateTime.fromMillisecondsSinceEpoch(
                    map['location_timestamp'] as int)
                : null,
          )
        : null;

    return CaptureEvent(
      id: map['id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      location: location,
      data: jsonDecode(map['data'] as String) as Map<String, dynamic>,
      type: CaptureType.values.firstWhere((t) => t.name == map['type']),
    );
  }
}
