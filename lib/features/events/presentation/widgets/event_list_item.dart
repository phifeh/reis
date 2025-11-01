import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/theme/retro_theme.dart';

class EventListItem extends StatelessWidget {
  final CaptureEvent event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RetroTheme.vintageCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with time and type
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: RetroTheme.vintageOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    _getTypeLabel(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: RetroTheme.deepTaupe,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Spacer(),
                Text(
                  RetroTheme.formatRetroTime(event.timestamp),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: RetroTheme.sageBrown,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date
            Text(
              RetroTheme.formatRetroDate(event.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: RetroTheme.sageBrown.withOpacity(0.8),
                    letterSpacing: 1.5,
                  ),
            ),

            if (event.type == CaptureType.photo) ...[
              const SizedBox(height: 16),
              _buildPhotoPreview(),
            ],

            if (event.type == CaptureType.text) ...[
              const SizedBox(height: 16),
              _buildTextNote(context),
            ],

            if (event.type == CaptureType.audio) ...[
              const SizedBox(height: 16),
              _buildAudioPlayer(context),
            ],

            if (event.type == CaptureType.rating) ...[
              const SizedBox(height: 16),
              _buildRating(context),
            ],

            if (event.location != null) ...[
              const SizedBox(height: 12),
              _buildLocationInfo(),
            ],

            if (event.data['note'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RetroTheme.warmBeige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                  border: const Border(
                    left: BorderSide(
                      color: RetroTheme.vintageOrange,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  event.data['note'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    final filePath = event.data['filePath'] as String?;
    if (filePath == null || !File(filePath).existsSync()) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: RetroTheme.paleOlive.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: RetroTheme.sageBrown,
            size: 48,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.file(
        File(filePath),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: RetroTheme.paleOlive.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: RetroTheme.dustyRose,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextNote(BuildContext context) {
    final text = event.data['text'] as String?;
    final title = event.data['title'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.warmBeige.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
        border: const Border(
          left: BorderSide(
            color: RetroTheme.mutedTeal,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: RetroTheme.deepTaupe,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
          ],
          if (text != null)
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(BuildContext context) {
    final duration = event.data['duration'] as int? ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final durationText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.paleOlive.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
        border: const Border(
          left: BorderSide(
            color: RetroTheme.vintageOrange,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RetroTheme.vintageOrange.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.mic,
              color: RetroTheme.vintageOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Recording',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: RetroTheme.deepTaupe,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  durationText,
                  style: const TextStyle(
                    fontFamily: RetroTheme.monoFont,
                    color: RetroTheme.sageBrown,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.play_arrow,
            color: RetroTheme.sageBrown,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    final rating = event.data['rating'] as int?;
    final place = event.data['place'] as String?;
    final note = event.data['note'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rating != null) ...[
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: index < rating
                      ? RetroTheme.vintageOrange
                      : RetroTheme.paleOlive,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$rating / 5',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: RetroTheme.vintageOrange,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
        if (place != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 18,
                color: RetroTheme.mutedTeal,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  place,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: RetroTheme.deepTaupe,
                      ),
                ),
              ),
            ],
          ),
        ],
        if (note != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: RetroTheme.warmBeige.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationInfo() {
    final location = event.location!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: RetroTheme.softMint.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: RetroTheme.mutedTeal.withOpacity(0.3),
          width: 1,
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
              '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
              style: const TextStyle(
                fontFamily: RetroTheme.monoFont,
                color: RetroTheme.sageBrown,
                fontSize: 10,
                letterSpacing: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (location.accuracy != null) ...[
            const SizedBox(width: 8),
            Text(
              '±${location.accuracy!.toStringAsFixed(0)}m',
              style: TextStyle(
                fontFamily: RetroTheme.monoFont,
                color: RetroTheme.sageBrown.withOpacity(0.7),
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTypeLabel() {
    switch (event.type) {
      case CaptureType.photo:
        return 'PHOTO';
      case CaptureType.audio:
        return 'AUDIO';
      case CaptureType.text:
        return 'NOTE';
      case CaptureType.rating:
        return 'RATING';
      case CaptureType.imported:
        return 'IMPORTED';
    }
  }
}
