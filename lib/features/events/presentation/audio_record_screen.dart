import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart';
import 'package:reis/core/services/audio_capture_service.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/utils/permissions_helper.dart';
import 'package:reis/features/events/presentation/events_provider.dart';
import 'package:uuid/uuid.dart';

class AudioRecordScreen extends ConsumerStatefulWidget {
  const AudioRecordScreen({super.key});

  @override
  ConsumerState<AudioRecordScreen> createState() => _AudioRecordScreenState();
}

class _AudioRecordScreenState extends ConsumerState<AudioRecordScreen> {
  final _audioService = AudioCaptureService();
  final _noteController = TextEditingController();
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  void _startTimer() {
    _recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordingSeconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final path = await _audioService.startRecording();
    if (path != null) {
      setState(() {
        _isRecording = true;
      });
      _startTimer();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start recording')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    _stopTimer();
    final result = await _audioService.stopRecording();
    
    if (result != null && result.path != null) {
      setState(() {
        _isRecording = false;
      });
      await _saveAudioEvent(result.path!, result.durationSeconds);
    }
  }

  Future<void> _saveAudioEvent(String filePath, int duration) async {
    final location = await PermissionsHelper.getCurrentLocation();
    
    final event = CaptureEvent.audio(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      location: location != null
          ? Location(
              latitude: location.latitude,
              longitude: location.longitude,
              accuracy: location.accuracy,
            )
          : null,
      filePath: filePath,
      durationSeconds: duration,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    await ref.read(eventsProvider.notifier).addEvent(event);

    if (mounted) {
      _noteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio saved')),
      );
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                _isRecording ? 'RECORDING' : 'READY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: RetroTheme.serifFont,
                  fontSize: 16,
                  letterSpacing: 3.0,
                  color: _isRecording ? RetroTheme.vintageOrange : RetroTheme.sageBrown,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _formatDuration(_recordingSeconds),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: RetroTheme.monoFont,
                  fontSize: 64,
                  color: RetroTheme.sageBrown,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? RetroTheme.vintageOrange : RetroTheme.sageBrown,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 48,
                      color: RetroTheme.softCream,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              TextField(
                controller: _noteController,
                enabled: !_isRecording,
                maxLines: 3,
                style: const TextStyle(
                  fontFamily: RetroTheme.serifFont,
                  fontSize: 16,
                  color: RetroTheme.sageBrown,
                ),
                decoration: InputDecoration(
                  hintText: 'Add a note (optional)',
                  hintStyle: TextStyle(
                    fontFamily: RetroTheme.serifFont,
                    color: RetroTheme.sageBrown.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: RetroTheme.softCream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: RetroTheme.sageBrown,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: RetroTheme.sageBrown.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: RetroTheme.vintageOrange,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
