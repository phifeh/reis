import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import '../services/local_storage.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final WearLocalStorage _storage = WearLocalStorage();
  
  bool _isRecording = false;
  bool _isInitialized = false;
  bool _isSaving = false;
  int _recordingSeconds = 0;
  Timer? _timer;
  String? _recordingPath;
  
  final int _maxDuration = 300;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required')),
        );
        Navigator.pop(context);
      }
      return;
    }

    await _recorder.openRecorder();
    setState(() => _isInitialized = true);
    await _startRecording();
  }

  Future<void> _startRecording() async {
    if (!_isInitialized) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      _recordingPath = '${directory.path}/audio_$timestamp.aac';

      await _recorder.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
        _recordingSeconds = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_recordingSeconds >= _maxDuration) {
          _stopRecording();
        } else if (mounted) {
          setState(() => _recordingSeconds++);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    _timer?.cancel();
    
    setState(() {
      _isRecording = false;
      _isSaving = true;
    });

    try {
      await _recorder.stopRecorder();
      
      if (_recordingPath != null && File(_recordingPath!).existsSync()) {
        await _storage.savePendingAudio(
          filePath: _recordingPath!,
          duration: Duration(seconds: _recordingSeconds),
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Voice memo saved! Will sync to phone.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    }
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE07A5F)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording) ...[
              const Icon(
                Icons.mic,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                _formatDuration(_recordingSeconds),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Max: ${_formatDuration(_maxDuration)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _stopRecording,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE07A5F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stop,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap to Stop',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ] else if (_isSaving) ...[
              const CircularProgressIndicator(
                color: Color(0xFFE07A5F),
              ),
              const SizedBox(height: 16),
              const Text(
                'Saving...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
