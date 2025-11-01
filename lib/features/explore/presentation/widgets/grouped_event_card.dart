import 'package:flutter/material.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/features/explore/models/event_group.dart';
import 'package:reis/core/models/capture_event.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class GroupedEventCard extends StatefulWidget {
  final EventGroup group;

  const GroupedEventCard({super.key, required this.group});

  @override
  State<GroupedEventCard> createState() => _GroupedEventCardState();
}

class _GroupedEventCardState extends State<GroupedEventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: RetroTheme.warmBeige,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
        side: BorderSide(
          color: RetroTheme.sageBrown.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.group.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontFamily: 'Spectral',
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.collections_outlined,
                              size: 14,
                              color: RetroTheme.sageBrown.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.group.events.length} ${widget.group.events.length == 1 ? 'item' : 'items'}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: RetroTheme.sageBrown.withOpacity(0.6),
                                  ),
                            ),
                            if (widget.group.location != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: RetroTheme.sageBrown.withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.group.location!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: RetroTheme.sageBrown.withOpacity(0.6),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: RetroTheme.sageBrown,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: RetroTheme.sageBrown.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.group.events.map((event) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEventItem(context, event),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, CaptureEvent event) {
    final timeFormatter = DateFormat('HH:mm');
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timeFormatter.format(event.timestamp),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: RetroTheme.sageBrown.withOpacity(0.6),
                fontFamily: 'monospace',
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getEventIcon(event.type),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEventContent(context, event),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getEventIcon(CaptureType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case CaptureType.photo:
        icon = Icons.photo_outlined;
        color = RetroTheme.vintageOrange;
        break;
      case CaptureType.video:
        icon = Icons.videocam_outlined;
        color = RetroTheme.dustyRose;
        break;
      case CaptureType.audio:
        icon = Icons.mic_outlined;
        color = RetroTheme.mutedTeal;
        break;
      case CaptureType.text:
        icon = Icons.text_fields_outlined;
        color = RetroTheme.deepTaupe;
        break;
      case CaptureType.rating:
        icon = Icons.star_outlined;
        color = RetroTheme.vintageOrange;
        break;
      case CaptureType.sketch:
        icon = Icons.draw_outlined;
        color = RetroTheme.sageBrown;
        break;
      case CaptureType.imported:
        icon = Icons.upload_file_outlined;
        color = RetroTheme.sageBrown;
        break;
    }
    
    return Icon(icon, size: 18, color: color);
  }

  Widget _buildEventContent(BuildContext context, CaptureEvent event) {
    switch (event.type) {
      case CaptureType.photo:
        return _buildPhotoContent(event);
      case CaptureType.video:
        return _buildVideoContent(event);
      case CaptureType.audio:
        return _buildAudioContent(event);
      case CaptureType.text:
        return _buildTextContent(event);
      case CaptureType.rating:
        return _buildRatingContent(event);
      case CaptureType.sketch:
        return _buildSketchContent(event);
      default:
        return const Text('Unknown type');
    }
  }

  Widget _buildPhotoContent(CaptureEvent event) {
    final filePath = event.data['filePath'] as String?;
    if (filePath == null) return const Text('Photo');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image.file(
            File(filePath),
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 100,
                color: RetroTheme.sageBrown.withOpacity(0.1),
                child: const Center(child: Text('Image not found')),
              );
            },
          ),
        ),
        if (event.data['note'] != null) ...[
          const SizedBox(height: 4),
          Text(
            event.data['note'] as String,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildVideoContent(CaptureEvent event) {
    return Row(
      children: [
        const Icon(Icons.play_circle_outline, size: 16),
        const SizedBox(width: 4),
        Text(
          'Video',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAudioContent(CaptureEvent event) {
    final duration = event.data['duration'] as int? ?? 0;
    return Text(
      'Audio (${duration}s)',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildTextContent(CaptureEvent event) {
    final text = event.data['text'] as String? ?? '';
    final title = event.data['title'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRatingContent(CaptureEvent event) {
    final rating = event.data['rating'] as int? ?? 0;
    final place = event.data['place'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: 16,
              color: RetroTheme.vintageOrange,
            ),
          ),
        ),
        if (place != null) ...[
          const SizedBox(height: 2),
          Text(
            place,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildSketchContent(CaptureEvent event) {
    return const Text('Sketch');
  }
}
