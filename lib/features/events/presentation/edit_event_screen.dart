import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart' as app;
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/providers/providers.dart';
import 'events_provider.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final CaptureEvent event;

  const EditEventScreen({super.key, required this.event});

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  late TextEditingController _noteController;
  late DateTime _selectedDateTime;
  double? _latitude;
  double? _longitude;
  
  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: widget.event.data['note'] as String? ?? '',
    );
    _selectedDateTime = widget.event.timestamp;
    _latitude = widget.event.location?.latitude;
    _longitude = widget.event.location?.longitude;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: RetroTheme.vintageOrange,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: RetroTheme.vintageOrange,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null && mounted) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _saveChanges() async {
    final updatedEvent = CaptureEvent(
      id: widget.event.id,
      timestamp: _selectedDateTime,
      location: _latitude != null && _longitude != null
          ? app.Location(
              latitude: _latitude!,
              longitude: _longitude!,
              altitude: widget.event.location?.altitude,
              accuracy: widget.event.location?.accuracy,
              timestamp: widget.event.location?.timestamp,
            )
          : widget.event.location,
      data: {
        ...widget.event.data,
        if (_noteController.text.isNotEmpty) 'note': _noteController.text,
      },
      type: widget.event.type,
    );

    final repository = ref.read(captureEventRepositoryProvider);
    await repository.save(updatedEvent);
    await ref.read(eventsProvider.notifier).refresh();

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event updated'),
          backgroundColor: RetroTheme.mutedTeal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _copyLocationFromPrevious() async {
    final eventsAsync = ref.read(eventsProvider);
    final events = eventsAsync.value;
    if (events == null) return;

    // Find current event index
    final currentIndex = events.indexWhere((e) => e.id == widget.event.id);
    if (currentIndex < 0 || currentIndex >= events.length - 1) return;

    // Get previous event (next in list since sorted newest first)
    final previousEvent = events[currentIndex + 1];
    if (previousEvent.location == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Previous event has no location'),
            backgroundColor: RetroTheme.dustyRose,
          ),
        );
      }
      return;
    }

    setState(() {
      _latitude = previousEvent.location!.latitude;
      _longitude = previousEvent.location!.longitude;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location copied from previous event'),
          backgroundColor: RetroTheme.mutedTeal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: RetroTheme.warmBeige,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveChanges,
            tooltip: 'Save',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Event type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: RetroTheme.vintageOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              _getTypeLabel(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: RetroTheme.deepTaupe,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Date/Time
          Text(
            'Date & Time',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: RetroTheme.deepTaupe,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectDateTime,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RetroTheme.warmBeige.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: RetroTheme.paleOlive),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: RetroTheme.sageBrown),
                  const SizedBox(width: 12),
                  Text(
                    RetroTheme.formatRetroDate(_selectedDateTime) +
                        ' ' +
                        RetroTheme.formatRetroTime(_selectedDateTime),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  const Icon(Icons.edit, size: 16, color: RetroTheme.sageBrown),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Location
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: RetroTheme.deepTaupe,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RetroTheme.warmBeige.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: RetroTheme.paleOlive),
            ),
            child: Column(
              children: [
                if (_latitude != null && _longitude != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: RetroTheme.mutedTeal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontFamily: RetroTheme.monoFont,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  const Text(
                    'No location data',
                    style: TextStyle(
                      color: RetroTheme.sageBrown,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ElevatedButton.icon(
                  onPressed: _copyLocationFromPrevious,
                  icon: const Icon(Icons.content_copy, size: 18),
                  label: const Text('Copy from previous event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RetroTheme.vintageOrange.withOpacity(0.2),
                    foregroundColor: RetroTheme.deepTaupe,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Note
          Text(
            'Note',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: RetroTheme.deepTaupe,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Add or edit note...',
              filled: true,
              fillColor: RetroTheme.warmBeige.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: const BorderSide(color: RetroTheme.paleOlive),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: const BorderSide(color: RetroTheme.paleOlive),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: const BorderSide(
                  color: RetroTheme.vintageOrange,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel() {
    switch (widget.event.type) {
      case CaptureType.photo:
        return 'PHOTO';
      case CaptureType.video:
        return 'VIDEO';
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
