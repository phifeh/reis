import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart';
import 'package:reis/core/providers/providers.dart';
import 'package:reis/core/theme/retro_theme.dart';

class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen({super.key});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  int _rating = 0;
  final _noteController = TextEditingController();
  final _placeController = TextEditingController();
  bool _isSaving = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _placeController.dispose();
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

  Future<void> _saveRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a rating'),
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
      final event = CaptureEvent.rating(
        rating: _rating,
        note: _noteController.text.trim().isEmpty 
            ? null 
            : _noteController.text.trim(),
        place: _placeController.text.trim().isEmpty
            ? null
            : _placeController.text.trim(),
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
            content: const Text('Rating saved successfully'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving rating: $e'),
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
                      Icons.star_outline,
                      color: RetroTheme.vintageOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Rate a place, experience, or moment',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: RetroTheme.sageBrown,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Star rating
              Text(
                'Your Rating',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = starValue;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        starValue <= _rating
                            ? Icons.star
                            : Icons.star_border,
                        size: 48,
                        color: starValue <= _rating
                            ? RetroTheme.vintageOrange
                            : RetroTheme.paleOlive,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              
              if (_rating > 0)
                Text(
                  _getRatingLabel(_rating),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: RetroTheme.vintageOrange,
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),

              // Place name field
              Text(
                'Place Name (optional)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: RetroTheme.deepTaupe,
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _placeController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Café du Monde',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                style: Theme.of(context).textTheme.titleMedium,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),

              // Note field
              Text(
                'Note (optional)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: RetroTheme.deepTaupe,
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Add details about your experience...',
                  border: OutlineInputBorder(),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 6,
                minLines: 4,
                textCapitalization: TextCapitalization.sentences,
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
            onPressed: _isSaving ? null : _saveRating,
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
            label: Text(_isSaving ? 'Saving...' : 'Save Rating'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ],
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Not Great';
      case 2:
        return 'Could Be Better';
      case 3:
        return 'Good';
      case 4:
        return 'Really Good';
      case 5:
        return 'Amazing!';
      default:
        return '';
    }
  }
}
