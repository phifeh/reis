import 'package:freezed_annotation/freezed_annotation.dart';
import 'location.dart';

part 'capture_event.freezed.dart';
part 'capture_event.g.dart';

enum CaptureType {
  photo,
  audio,
  text,
  rating,
  imported,
}

@freezed
class CaptureEvent with _$CaptureEvent {
  const factory CaptureEvent({
    required String id,
    required DateTime timestamp,
    Location? location,
    required Map<String, dynamic> data,
    required CaptureType type,
  }) = _CaptureEvent;

  factory CaptureEvent.fromJson(Map<String, dynamic> json) =>
      _$CaptureEventFromJson(json);

  factory CaptureEvent.photo({
    required String id,
    required DateTime timestamp,
    Location? location,
    required String filePath,
    String? note,
  }) =>
      CaptureEvent(
        id: id,
        timestamp: timestamp,
        type: CaptureType.photo,
        location: location,
        data: {'filePath': filePath, if (note != null) 'note': note},
      );

  factory CaptureEvent.audio({
    required String id,
    required DateTime timestamp,
    Location? location,
    required String filePath,
    required int durationSeconds,
    String? note,
  }) =>
      CaptureEvent(
        id: id,
        timestamp: timestamp,
        type: CaptureType.audio,
        location: location,
        data: {
          'filePath': filePath,
          'duration': durationSeconds,
          if (note != null) 'note': note,
        },
      );

  factory CaptureEvent.text({
    String? id,
    DateTime? timestamp,
    Location? location,
    required String text,
    String? title,
  }) =>
      CaptureEvent(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: timestamp ?? DateTime.now(),
        type: CaptureType.text,
        location: location,
        data: {
          'text': text,
          if (title != null) 'title': title,
        },
      );

  factory CaptureEvent.rating({
    String? id,
    DateTime? timestamp,
    Location? location,
    required int rating,
    String? note,
    String? place,
  }) =>
      CaptureEvent(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: timestamp ?? DateTime.now(),
        type: CaptureType.rating,
        location: location,
        data: {
          'rating': rating,
          if (note != null) 'note': note,
          if (place != null) 'place': place,
        },
      );
}
