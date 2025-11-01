import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/models/capture_event.dart';
import '../../../core/providers/providers.dart';

class EventsNotifier extends StateNotifier<AsyncValue<List<CaptureEvent>>> {
  final captureEventRepository;

  EventsNotifier(this.captureEventRepository) : super(const AsyncValue.loading()) {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await captureEventRepository.findAll();
      final sortedEvents = List<CaptureEvent>.from(events);
      sortedEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      state = AsyncValue.data(sortedEvents);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addEvent(CaptureEvent event) async {
    await captureEventRepository.save(event);
    await _loadEvents();
  }

  Future<void> refresh() async {
    await _loadEvents();
  }
  
  Future<void> deleteEvent(String eventId) async {
    await captureEventRepository.delete(eventId);
    await _loadEvents();
  }
}

final eventsProvider = StateNotifierProvider<EventsNotifier, AsyncValue<List<CaptureEvent>>>((ref) {
  final repository = ref.watch(captureEventRepositoryProvider);
  return EventsNotifier(repository);
});
