import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/features/events/presentation/events_provider.dart';
import 'package:reis/features/explore/models/event_group.dart';
import 'package:intl/intl.dart';

final groupedEventsProvider = Provider<AsyncValue<List<EventGroup>>>((ref) {
  final eventsAsync = ref.watch(eventsProvider);
  
  return eventsAsync.when(
    data: (events) {
      final groups = _groupEvents(events);
      return AsyncValue.data(groups);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

List<EventGroup> _groupEvents(List<CaptureEvent> events) {
  if (events.isEmpty) return [];
  
  final List<EventGroup> groups = [];
  List<CaptureEvent> currentGroup = [];
  DateTime? groupStart;
  
  // Sort events by timestamp (newest first)
  final sortedEvents = List<CaptureEvent>.from(events)
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  
  for (int i = 0; i < sortedEvents.length; i++) {
    final event = sortedEvents[i];
    
    if (currentGroup.isEmpty) {
      currentGroup.add(event);
      groupStart = event.timestamp;
    } else {
      final lastEvent = currentGroup.last;
      final timeDiff = lastEvent.timestamp.difference(event.timestamp);
      final distanceDiff = _calculateDistance(lastEvent, event);
      
      // Group if within 30 minutes and 100 meters
      if (timeDiff.inMinutes.abs() < 30 && distanceDiff < 100) {
        currentGroup.add(event);
      } else {
        // Create group from current events
        if (currentGroup.isNotEmpty) {
          groups.add(_createGroup(currentGroup, groupStart!));
        }
        currentGroup = [event];
        groupStart = event.timestamp;
      }
    }
  }
  
  // Add last group
  if (currentGroup.isNotEmpty && groupStart != null) {
    groups.add(_createGroup(currentGroup, groupStart));
  }
  
  return groups;
}

EventGroup _createGroup(List<CaptureEvent> events, DateTime startTime) {
  final endTime = events.first.timestamp;
  final dateFormatter = DateFormat('MMM d, y');
  final timeFormatter = DateFormat('HH:mm');
  
  String title;
  if (events.length == 1) {
    title = dateFormatter.format(startTime);
  } else {
    final start = timeFormatter.format(startTime);
    final end = timeFormatter.format(endTime);
    title = '${dateFormatter.format(startTime)} • $start - $end';
  }
  
  // Get location from first event with location
  String? locationName;
  double? lat;
  double? lon;
  for (final event in events) {
    if (event.location != null) {
      lat = event.location!.latitude;
      lon = event.location!.longitude;
      locationName = _getLocationName(event.location!.latitude, event.location!.longitude);
      break;
    }
  }
  
  return EventGroup(
    id: '${startTime.millisecondsSinceEpoch}',
    title: title,
    events: events,
    startTime: startTime,
    endTime: endTime,
    location: locationName,
    latitude: lat,
    longitude: lon,
  );
}

double _calculateDistance(CaptureEvent event1, CaptureEvent event2) {
  if (event1.location == null || event2.location == null) {
    return double.infinity;
  }
  
  final lat1 = event1.location!.latitude;
  final lon1 = event1.location!.longitude;
  final lat2 = event2.location!.latitude;
  final lon2 = event2.location!.longitude;
  
  // Simple distance calculation (not accurate for long distances)
  final dLat = (lat2 - lat1) * 111000; // degrees to meters
  final dLon = (lon2 - lon1) * 111000;
  
  return (dLat * dLat + dLon * dLon) / 1000; // approximate
}

String _getLocationName(double lat, double lon) {
  // Simplified location name - in a real app, use reverse geocoding
  return '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
}
