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
      state = AsyncValue.data(events);
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
}

final eventsProvider = StateNotifierProvider<EventsNotifier, AsyncValue<List<CaptureEvent>>>((ref) {
  final repository = ref.watch(captureEventRepositoryProvider);
  return EventsNotifier(repository);
});
