import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:reis/core/models/moment.dart';
import 'moment_repository.dart';
import 'database_helper.dart';

class SqliteMomentRepository implements MomentRepository {
  static const String _tableName = 'moments';

  Future<Database> get database => DatabaseHelper.database;

  @override
  Future<void> save(Moment moment) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        _tableName,
        _toMap(moment),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        'moment_events',
        where: 'moment_id = ?',
        whereArgs: [moment.id],
      );

      for (final eventId in moment.eventIds) {
        await txn.insert(
          'moment_events',
          {
            'moment_id': moment.id,
            'event_id': eventId,
            'assigned_at': DateTime.now().millisecondsSinceEpoch,
            'assignment_type': 'auto',
          },
        );
      }
    });
  }

  Future<List<String>> _loadEventIds(Database db, String momentId) async {
    final results = await db.query(
      'moment_events',
      where: 'moment_id = ?',
      whereArgs: [momentId],
      orderBy: 'assigned_at ASC',
    );
    return results.map((e) => e['event_id'] as String).toList();
  }

  @override
  Future<Moment?> findById(String id) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;

    final eventIds = await _loadEventIds(db, id);
    return _fromMap(results.first, eventIds);
  }

  @override
  Future<List<Moment>> findAll() async {
    final db = await database;
    final results = await db.query(_tableName, orderBy: 'start_time DESC');

    final moments = <Moment>[];
    for (final row in results) {
      final eventIds = await _loadEventIds(db, row['id'] as String);
      moments.add(_fromMap(row, eventIds));
    }
    return moments;
  }

  @override
  Future<List<Moment>> findByTimeRange(DateTime start, DateTime end) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'start_time >= ? AND start_time <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'start_time ASC',
    );

    final moments = <Moment>[];
    for (final row in results) {
      final eventIds = await _loadEventIds(db, row['id'] as String);
      moments.add(_fromMap(row, eventIds));
    }
    return moments;
  }

  @override
  Future<List<Moment>> findByParentId(String parentId) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'parent_moment_id = ?',
      whereArgs: [parentId],
      orderBy: 'start_time ASC',
    );

    final moments = <Moment>[];
    for (final row in results) {
      final eventIds = await _loadEventIds(db, row['id'] as String);
      moments.add(_fromMap(row, eventIds));
    }
    return moments;
  }

  @override
  Future<void> delete(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .delete('moment_events', where: 'moment_id = ?', whereArgs: [id]);
      await txn.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<void> _updateTimestamp(String momentId) async {
    final db = await database;
    await db.update(
      _tableName,
      {'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [momentId],
    );
  }

  @override
  Future<void> addEventToMoment(
    String momentId,
    String eventId, {
    AssignmentType assignmentType = AssignmentType.auto,
  }) async {
    final db = await database;
    await db.insert(
      'moment_events',
      {
        'moment_id': momentId,
        'event_id': eventId,
        'assigned_at': DateTime.now().millisecondsSinceEpoch,
        'assignment_type': assignmentType.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _updateTimestamp(momentId);
  }

  @override
  Future<void> removeEventFromMoment(String momentId, String eventId) async {
    final db = await database;
    await db.delete(
      'moment_events',
      where: 'moment_id = ? AND event_id = ?',
      whereArgs: [momentId, eventId],
    );
    await _updateTimestamp(momentId);
  }

  Map<String, dynamic> _toMap(Moment moment) {
    return {
      'id': moment.id,
      'name': moment.name,
      'type': moment.type.name,
      'parent_moment_id': moment.parentMomentId,
      'start_time': moment.startTime.millisecondsSinceEpoch,
      'end_time': moment.endTime?.millisecondsSinceEpoch,
      'center_lat': moment.centerLat,
      'center_lon': moment.centerLon,
      'radius_meters': moment.radiusMeters,
      'event_count': moment.eventCount,
      'settings': moment.settings != null ? jsonEncode(moment.settings) : null,
      'created_at': moment.createdAt.millisecondsSinceEpoch,
      'updated_at': moment.updatedAt.millisecondsSinceEpoch,
    };
  }

  Moment _fromMap(Map<String, dynamic> map, List<String> eventIds) {
    return Moment(
      id: map['id'] as String,
      name: map['name'] as String?,
      eventIds: eventIds,
      type: MomentType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => MomentType.auto,
      ),
      parentMomentId: map['parent_moment_id'] as String?,
      startTime:
          DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
      endTime: map['end_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int)
          : null,
      centerLat: map['center_lat'] as double?,
      centerLon: map['center_lon'] as double?,
      radiusMeters: (map['radius_meters'] as num?)?.toDouble() ?? 100.0,
      eventCount: map['event_count'] as int? ?? 0,
      settings: map['settings'] != null
          ? jsonDecode(map['settings'] as String) as Map<String, dynamic>
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['created_at'] as int? ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
