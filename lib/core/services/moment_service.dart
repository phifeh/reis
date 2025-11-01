import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/moment.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/grouping_strategy.dart';
import 'package:reis/core/repositories/moment_repository.dart';
import 'package:reis/core/repositories/capture_event_repository.dart';

class MomentService {
  final MomentRepository _momentRepository;
  final CaptureEventRepository _eventRepository;
  final _uuid = const Uuid();

  MomentService(this._momentRepository, this._eventRepository);

  Future<Moment> createManualMoment({
    String? name,
    required List<String> eventIds,
  }) async {
    final events = await _eventRepository.findByIds(eventIds);
    if (events.isEmpty) {
      throw ArgumentError('No valid events found');
    }

    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final now = DateTime.now();
    final moment = Moment(
      id: _uuid.v4(),
      name: name,
      eventIds: eventIds,
      type: MomentType.manual,
      startTime: events.first.timestamp,
      endTime: events.last.timestamp,
      createdAt: now,
      updatedAt: now,
    );

    await _momentRepository.save(moment);
    return moment;
  }

  Future<List<Moment>> detectMomentsForTimeRange(
    DateTime start,
    DateTime end,
    GroupingStrategy strategy,
  ) async {
    final events = await _eventRepository.findByTimeRange(start, end);
    if (events.isEmpty) return [];

    final moments = <Moment>[];
    List<CaptureEvent> currentGroup = [];

    for (final event in events) {
      if (currentGroup.isEmpty) {
        currentGroup.add(event);
        continue;
      }

      final lastEvent = currentGroup.last;
      final timeDiff = event.timestamp.difference(lastEvent.timestamp);
      final shouldGroup = _shouldGroupEvents(
        lastEvent,
        event,
        timeDiff,
        strategy,
      );

      if (shouldGroup) {
        currentGroup.add(event);
      } else {
        if (currentGroup.length >= strategy.minEventsForMoment) {
          moments.add(_createAutoMoment(currentGroup));
        }
        currentGroup = [event];
      }
    }

    if (currentGroup.length >= strategy.minEventsForMoment) {
      moments.add(_createAutoMoment(currentGroup));
    }

    for (final moment in moments) {
      await _momentRepository.save(moment);
    }

    return moments;
  }

  bool _shouldGroupEvents(
    CaptureEvent event1,
    CaptureEvent event2,
    Duration timeDiff,
    GroupingStrategy strategy,
  ) {
    if (timeDiff > strategy.timeThreshold) {
      return false;
    }

    if (event1.location != null && event2.location != null) {
      final distance = Geolocator.distanceBetween(
        event1.location!.latitude,
        event1.location!.longitude,
        event2.location!.latitude,
        event2.location!.longitude,
      );

      if (distance > strategy.distanceThreshold) {
        return false;
      }
    }

    return true;
  }

  Moment _createAutoMoment(List<CaptureEvent> events) {
    final now = DateTime.now();
    return Moment(
      id: _uuid.v4(),
      name: null,
      eventIds: events.map((e) => e.id).toList(),
      type: MomentType.auto,
      startTime: events.first.timestamp,
      endTime: events.last.timestamp,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<Moment> updateMoment(Moment moment) async {
    await _momentRepository.save(moment);
    return moment;
  }

  Future<void> addEventToMoment(String momentId, String eventId) async {
    await _momentRepository.addEventToMoment(momentId, eventId);
  }

  Future<void> removeEventFromMoment(String momentId, String eventId) async {
    await _momentRepository.removeEventFromMoment(momentId, eventId);
  }

  Future<List<Moment>> getAllMoments() async {
    return await _momentRepository.findAll();
  }

  Future<Moment?> getMomentById(String id) async {
    return await _momentRepository.findById(id);
  }

  Future<void> deleteMoment(String id) async {
    await _momentRepository.delete(id);
  }
}
