import 'package:uuid/uuid.dart';
import 'package:reis/core/models/moment.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/moment_detection_strategy.dart';
import 'package:reis/core/models/location.dart';
import 'package:reis/core/repositories/moment_repository.dart';
import 'package:reis/core/repositories/capture_event_repository.dart';
import 'package:reis/core/algorithms/location_clustering.dart';

class MomentDetectionService {
  final MomentRepository _momentRepository;
  final CaptureEventRepository _eventRepository;
  final _uuid = const Uuid();

  MomentDetectionService(this._momentRepository, this._eventRepository);

  Future<MomentDecision> analyzeEvent(
    CaptureEvent event,
    Moment? currentMoment,
    MomentDetectionStrategy strategy,
  ) async {
    if (currentMoment == null) {
      return MomentDecision.createNew;
    }

    if (event.location == null) {
      return MomentDecision.addToExisting;
    }

    final timeDiff = event.timestamp.difference(currentMoment.startTime);
    if (timeDiff > strategy.timeThreshold) {
      return MomentDecision.createNew;
    }

    if (currentMoment.centerLat != null && currentMoment.centerLon != null) {
      final distance = LocationClustering.haversineDistance(
        currentMoment.centerLat!,
        currentMoment.centerLon!,
        event.location!.latitude,
        event.location!.longitude,
      );

      if (distance > strategy.distanceThreshold) {
        return MomentDecision.createNew;
      }

      if (strategy.autoCreateSubMoments &&
          distance > strategy.subMomentDistanceThreshold &&
          distance <= strategy.distanceThreshold) {
        return MomentDecision.createSubMoment;
      }
    }

    return MomentDecision.addToExisting;
  }

  Future<Moment> createMoment({
    String? name,
    required MomentType type,
    required DateTime startTime,
    String? parentMomentId,
    Location? initialLocation,
    MomentDetectionStrategy? strategy,
  }) async {
    final now = DateTime.now();
    final moment = Moment(
      id: _uuid.v4(),
      name: name,
      eventIds: [],
      type: type,
      parentMomentId: parentMomentId,
      startTime: startTime,
      endTime: null,
      centerLat: initialLocation?.latitude,
      centerLon: initialLocation?.longitude,
      radiusMeters: strategy?.distanceThreshold ?? 100.0,
      eventCount: 0,
      createdAt: now,
      updatedAt: now,
    );

    await _momentRepository.save(moment);
    return moment;
  }

  Future<Moment> assignEventToMoment(
    String eventId,
    String momentId, {
    bool manual = false,
  }) async {
    final moment = await _momentRepository.findById(momentId);
    if (moment == null) {
      throw ArgumentError('Moment not found: $momentId');
    }

    final event = await _eventRepository.findById(eventId);
    if (event == null) {
      throw ArgumentError('Event not found: $eventId');
    }

    await _momentRepository.addEventToMoment(
      momentId,
      eventId,
      assignmentType: manual ? AssignmentType.manual : AssignmentType.auto,
    );

    final updatedMoment = await _updateMomentMetadata(momentId);
    return updatedMoment!;
  }

  Future<List<Moment>> splitMoment(String momentId, String atEventId) async {
    final moment = await _momentRepository.findById(momentId);
    if (moment == null) {
      throw ArgumentError('Moment not found');
    }

    final events = await _eventRepository.findByIds(moment.eventIds);
    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final splitIndex = events.indexWhere((e) => e.id == atEventId);
    if (splitIndex == -1) {
      throw ArgumentError('Event not found in moment');
    }

    final beforeEvents = events.sublist(0, splitIndex);
    final afterEvents = events.sublist(splitIndex);

    final moment1 = await createMoment(
      name: moment.name != null ? '${moment.name} (1)' : null,
      type: MomentType.manual,
      startTime: beforeEvents.first.timestamp,
      parentMomentId: moment.parentMomentId,
    );

    final moment2 = await createMoment(
      name: moment.name != null ? '${moment.name} (2)' : null,
      type: MomentType.manual,
      startTime: afterEvents.first.timestamp,
      parentMomentId: moment.parentMomentId,
    );

    for (final event in beforeEvents) {
      await assignEventToMoment(event.id, moment1.id, manual: true);
    }

    for (final event in afterEvents) {
      await assignEventToMoment(event.id, moment2.id, manual: true);
    }

    await _momentRepository.delete(momentId);

    return [
      (await _momentRepository.findById(moment1.id))!,
      (await _momentRepository.findById(moment2.id))!,
    ];
  }

  Future<Moment> mergeMoments(List<String> momentIds) async {
    if (momentIds.length < 2) {
      throw ArgumentError('Need at least 2 moments to merge');
    }

    final moments = await Future.wait(
      momentIds.map((id) => _momentRepository.findById(id)),
    );

    if (moments.any((m) => m == null)) {
      throw ArgumentError('One or more moments not found');
    }

    final validMoments = moments.whereType<Moment>().toList();
    validMoments.sort((a, b) => a.startTime.compareTo(b.startTime));

    final allEventIds = <String>{};
    for (final moment in validMoments) {
      allEventIds.addAll(moment.eventIds);
    }

    final mergedMoment = await createMoment(
      name: validMoments.first.name,
      type: MomentType.manual,
      startTime: validMoments.first.startTime,
    );

    for (final eventId in allEventIds) {
      await assignEventToMoment(eventId, mergedMoment.id, manual: true);
    }

    for (final momentId in momentIds) {
      await _momentRepository.delete(momentId);
    }

    return (await _momentRepository.findById(mergedMoment.id))!;
  }

  Future<Moment?> _updateMomentMetadata(String momentId) async {
    final moment = await _momentRepository.findById(momentId);
    if (moment == null) return null;

    final events = await _eventRepository.findByIds(moment.eventIds);
    if (events.isEmpty) return moment;

    final locationsWithData = events
        .where((e) => e.location != null)
        .map((e) => e.location!)
        .toList();

    if (locationsWithData.isEmpty) {
      return moment.copyWith(
        eventCount: events.length,
        updatedAt: DateTime.now(),
      );
    }

    final centroid = LocationClustering.calculateCentroid(locationsWithData);
    final radius = LocationClustering.calculateRadius(
      locationsWithData,
      centroid.lat,
      centroid.lon,
    );

    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final updated = moment.copyWith(
      centerLat: centroid.lat,
      centerLon: centroid.lon,
      radiusMeters: radius,
      eventCount: events.length,
      endTime: events.last.timestamp,
      updatedAt: DateTime.now(),
    );

    await _momentRepository.save(updated);
    return updated;
  }

  Future<Moment> detectMomentBoundary(
    CaptureEvent event,
    Moment? lastMoment,
    MomentDetectionStrategy strategy,
  ) async {
    final decision = await analyzeEvent(event, lastMoment, strategy);

    switch (decision) {
      case MomentDecision.createNew:
        final newMoment = await createMoment(
          type: MomentType.auto,
          startTime: event.timestamp,
          initialLocation: event.location,
          strategy: strategy,
        );
        await assignEventToMoment(event.id, newMoment.id);
        return newMoment;

      case MomentDecision.createSubMoment:
        final subMoment = await createMoment(
          type: MomentType.auto,
          startTime: event.timestamp,
          parentMomentId: lastMoment!.id,
          initialLocation: event.location,
          strategy: strategy,
        );
        await assignEventToMoment(event.id, subMoment.id);
        return subMoment;

      case MomentDecision.addToExisting:
      case MomentDecision.askUser:
        if (lastMoment != null) {
          await assignEventToMoment(event.id, lastMoment.id);
          return (await _momentRepository.findById(lastMoment.id))!;
        } else {
          final newMoment = await createMoment(
            type: MomentType.auto,
            startTime: event.timestamp,
            initialLocation: event.location,
            strategy: strategy,
          );
          await assignEventToMoment(event.id, newMoment.id);
          return newMoment;
        }
    }
  }

  Future<List<Moment>> getAllMoments({bool includeSubMoments = true}) async {
    final moments = await _momentRepository.findAll();
    if (includeSubMoments) {
      return moments;
    }
    return moments.where((m) => m.parentMomentId == null).toList();
  }

  Future<Moment?> getCurrentMoment() async {
    final moments = await _momentRepository.findAll();
    if (moments.isEmpty) return null;

    moments.sort((a, b) => b.startTime.compareTo(a.startTime));
    return moments.first.endTime == null ? moments.first : null;
  }

  Future<Moment> updateMomentName(String momentId, String name) async {
    final moment = await _momentRepository.findById(momentId);
    if (moment == null) {
      throw ArgumentError('Moment not found');
    }

    final updated = moment.copyWith(name: name, updatedAt: DateTime.now());
    await _momentRepository.save(updated);
    return updated;
  }

  Future<void> endMoment(String momentId) async {
    final moment = await _momentRepository.findById(momentId);
    if (moment == null) return;

    final events = await _eventRepository.findByIds(moment.eventIds);
    if (events.isEmpty) return;

    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final updated =
        moment.copyWith(endTime: events.last.timestamp, updatedAt: DateTime.now());
    await _momentRepository.save(updated);
  }
}
