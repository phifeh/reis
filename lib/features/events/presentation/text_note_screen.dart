import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart';
import 'package:reis/core/providers/providers.dart';
import 'package:reis/core/theme/retro_theme.dart';

class TextNoteScreen extends ConsumerStatefulWidget {
  const TextNoteScreen({super.key});

  @override
  ConsumerState<TextNoteScreen> createState() => _TextNoteScreenState();
}

class _TextNoteScreenState extends ConsumerState<TextNoteScreen> {
  final _textController = TextEditingController();
  final _titleController = TextEditingController();
  bool _isSaving = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await Geolocator.checkPermission();
      if (hasPermission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _saveNote() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please write something first'),
          backgroundColor: RetroTheme.dustyRose,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final event = CaptureEvent.text(
        text: _textController.text.trim(),
        title: _titleController.text.trim().isEmpty 
            ? null 
            : _titleController.text.trim(),
        location: _currentPosition != null
            ? Location(
                latitude: _currentPosition!.latitude,
                longitude: _currentPosition!.longitude,
                accuracy: _currentPosition!.accuracy,
              )
            : null,
      );

      await ref.read(captureEventRepositoryProvider).save(event);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Note saved successfully'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RetroTheme.warmBeige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: RetroTheme.paleOlive.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: RetroTheme.vintageOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Capture thoughts, observations, or quick reminders',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: RetroTheme.sageBrown,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title field
              Text(
                'Title (optional)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: RetroTheme.deepTaupe,
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Morning at the café...',
                  border: OutlineInputBorder(),
                ),
                style: Theme.of(context).textTheme.titleMedium,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),

              // Note field
              Text(
                'Your Note',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: RetroTheme.deepTaupe,
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts here...',
                  border: OutlineInputBorder(),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 12,
                minLines: 8,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
              const SizedBox(height: 16),

              // Character count
              Text(
                '${_textController.text.length} characters',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: RetroTheme.sageBrown.withOpacity(0.7),
                    ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 24),

              // Location indicator
              if (_currentPosition != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RetroTheme.softMint.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: RetroTheme.mutedTeal.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: RetroTheme.mutedTeal,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),

        // Floating save button
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveNote,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(RetroTheme.softCream),
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 20),
            label: Text(_isSaving ? 'Saving...' : 'Save Note'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}
