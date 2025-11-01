import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AudioCaptureService {
  final _audioRecorder = FlutterSoundRecorder();
  final _uuid = const Uuid();
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _audioRecorder.openRecorder();
      _isInitialized = true;
    }
  }

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<String?> startRecording() async {
    try {
      await initialize();
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/media/audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final filename = '${timestamp}_${_uuid.v4()}.aac';
      _currentRecordingPath = '${audioDir.path}/$filename';
      _recordingStartTime = DateTime.now();

      await _audioRecorder.startRecorder(
        toFile: _currentRecordingPath!,
        codec: Codec.aacADTS,
        bitRate: 128000,
        sampleRate: 44100,
      );

      return _currentRecordingPath;
    } catch (e) {
      return null;
    }
  }

  Future<({String? path, int durationSeconds})?> stopRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      if (_currentRecordingPath == null || _recordingStartTime == null) {
        return null;
      }

      final duration = DateTime.now().difference(_recordingStartTime!);
      final savedPath = _currentRecordingPath;
      
      _currentRecordingPath = null;
      _recordingStartTime = null;

      return (path: savedPath, durationSeconds: duration.inSeconds);
    } catch (e) {
      return null;
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      _currentRecordingPath = null;
      _recordingStartTime = null;
    } catch (e) {
      // Ignore errors during cancel
    }
  }

  Future<bool> isRecording() async {
    return _audioRecorder.isRecording;
  }

  int? getRecordingDuration() {
    if (_recordingStartTime == null) return null;
    return DateTime.now().difference(_recordingStartTime!).inSeconds;
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _audioRecorder.closeRecorder();
      _isInitialized = false;
    }
  }
}
