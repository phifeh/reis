import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart' as app;
import 'package:reis/core/repositories/capture_event_repository.dart';

class CaptureService {
  final CaptureEventRepository _repository;
  final _uuid = const Uuid();

  CaptureService(this._repository);

  Future<CaptureEvent> capturePhoto({
    required String filePath,
    app.Location? location,
  }) async {
    final event = CaptureEvent(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      location: location ?? await _getCurrentLocation(),
      data: {'filePath': filePath},
      type: CaptureType.photo,
    );

    await _repository.save(event);
    return event;
  }

  Future<CaptureEvent> captureAudio({
    required String filePath,
    required Duration duration,
    app.Location? location,
  }) async {
    final event = CaptureEvent(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      location: location ?? await _getCurrentLocation(),
      data: {
        'filePath': filePath,
        'duration': duration.inSeconds,
      },
      type: CaptureType.audio,
    );

    await _repository.save(event);
    return event;
  }

  Future<CaptureEvent> captureText({
    required String text,
    app.Location? location,
  }) async {
    final event = CaptureEvent(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      location: location ?? await _getCurrentLocation(),
      data: {'text': text},
      type: CaptureType.text,
    );

    await _repository.save(event);
    return event;
  }

  Future<CaptureEvent> captureRating({
    required double rating,
    String? note,
    app.Location? location,
  }) async {
    final event = CaptureEvent(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      location: location ?? await _getCurrentLocation(),
      data: {
        'rating': rating,
        if (note != null) 'note': note,
      },
      type: CaptureType.rating,
    );

    await _repository.save(event);
    return event;
  }

  Future<CaptureEvent> importEvent({
    required DateTime timestamp,
    required Map<String, dynamic> data,
    required CaptureType type,
    app.Location? location,
  }) async {
    final event = CaptureEvent(
      id: _uuid.v4(),
      timestamp: timestamp,
      location: location,
      data: data,
      type: type,
    );

    await _repository.save(event);
    return event;
  }

  Future<List<CaptureEvent>> getEventsByTimeRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _repository.findByTimeRange(start, end);
  }

  Future<List<CaptureEvent>> getEventsByIds(List<String> ids) async {
    return await _repository.findByIds(ids);
  }

  Future<app.Location?> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition();
      return app.Location(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
      );
    } catch (e) {
      return null;
    }
  }
}
