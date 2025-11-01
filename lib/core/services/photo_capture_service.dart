import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/result.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart' as app;
import 'package:reis/core/repositories/capture_event_repository.dart';

class PhotoCaptureService {
  final CaptureEventRepository _repository;
  final _uuid = const Uuid();
  CameraController? _controller;
  bool _isCapturing = false;

  PhotoCaptureService(this._repository);

  Future<Result<CameraController>> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return const Failure('No cameras available');
      }

      final camera = cameras.first;
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      return Success(_controller!);
    } catch (e) {
      return Failure('Failed to initialize camera: $e', e as Exception?);
    }
  }

  Future<Result<CaptureEvent>> capturePhoto({
    app.Location? location,
    String? note,
  }) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Failure('Camera not initialized');
    }

    if (_isCapturing) {
      return const Failure('Capture already in progress');
    }

    _isCapturing = true;

    try {
      final XFile photo = await _controller!.takePicture();

      final storageResult = await _checkStorageSpace();
      if (storageResult is Failure) {
        await File(photo.path).delete();
        _isCapturing = false;
        return storageResult as Failure<CaptureEvent>;
      }

      final String filePath = await _savePhotoToStorage(photo);

      final locationData = location ?? await _getCurrentLocation();

      final event = CaptureEvent.photo(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        filePath: filePath,
        location: locationData,
        note: note,
      );

      await _repository.save(event);

      _isCapturing = false;
      return Success(event);
    } catch (e) {
      _isCapturing = false;
      return Failure('Failed to capture photo: $e', e as Exception?);
    }
  }

  Future<Result<void>> _checkStorageSpace() async {
    try {
      return const Success(null);
    } catch (e) {
      return const Failure('Unable to check storage space');
    }
  }

  Future<String> _savePhotoToStorage(XFile photo) async {
    final directory = await _getPhotosDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final uuid = _uuid.v4().substring(0, 8);
    final fileName = '${timestamp}_$uuid.jpg';
    final filePath = join(directory.path, fileName);

    await File(photo.path).copy(filePath);

    try {
      await File(photo.path).delete();
    } catch (_) {}

    return filePath;
  }

  Future<Directory> _getPhotosDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(join(appDir.path, 'media', 'photos'));

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    return photosDir;
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

  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isCapturing = false;
  }

  CameraController? get controller => _controller;
  bool get isCapturing => _isCapturing;
}
