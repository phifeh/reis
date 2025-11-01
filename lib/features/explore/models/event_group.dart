import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reis/core/models/capture_event.dart';

part 'event_group.freezed.dart';

@freezed
class EventGroup with _$EventGroup {
  const factory EventGroup({
    required String id,
    required String title,
    required List<CaptureEvent> events,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    double? latitude,
    double? longitude,
    @Default(false) bool isCollapsed,
  }) = _EventGroup;
}
