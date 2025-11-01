import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/result.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart' as app;
import 'package:reis/core/repositories/capture_event_repository.dart';

class VideoCaptureService {
  final CaptureEventRepository _repository;
  final _uuid = const Uuid();

  VideoCaptureService(this._repository);

  Future<Result<CaptureEvent>> saveVideo({
    required String filePath,
    required Duration duration,
    app.Location? location,
    String? note,
  }) async {
    try {
      final savedPath = await _saveVideoToStorage(filePath);
      final locationData = location ?? await _getCurrentLocation();

      final event = CaptureEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        location: locationData,
        data: {
          'filePath': savedPath,
          'duration': duration.inSeconds,
          if (note != null) 'note': note,
        },
        type: CaptureType.video,
      );

      await _repository.save(event);
      return Success(event);
    } catch (e) {
      return Failure('Failed to save video: $e', e as Exception?);
    }
  }

  Future<String> _saveVideoToStorage(String tempPath) async {
    final directory = await _getVideosDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final uuid = _uuid.v4().substring(0, 8);
    final fileName = '${timestamp}_$uuid.mp4';
    final filePath = join(directory.path, fileName);

    await File(tempPath).copy(filePath);

    try {
      await File(tempPath).delete();
    } catch (_) {}

    return filePath;
  }

  Future<Directory> _getVideosDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final videosDir = Directory(join(appDir.path, 'media', 'videos'));

    if (!await videosDir.exists()) {
      await videosDir.create(recursive: true);
    }

    return videosDir;
  }

  Future<app.Location?> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestResult = await Geolocator.requestPermission();
        if (requestResult == LocationPermission.denied ||
            requestResult == LocationPermission.deniedForever) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 10),
      );

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
