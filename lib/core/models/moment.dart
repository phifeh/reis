import 'package:freezed_annotation/freezed_annotation.dart';

part 'moment.freezed.dart';
part 'moment.g.dart';

enum MomentType {
  auto,
  manual,
  journey,
}

enum AssignmentType {
  auto,
  manual,
}

@freezed
class Moment with _$Moment {
  const factory Moment({
    required String id,
    String? name,
    required List<String> eventIds,
    required MomentType type,
    String? parentMomentId,
    required DateTime startTime,
    DateTime? endTime,
    double? centerLat,
    double? centerLon,
    @Default(100.0) double radiusMeters,
    @Default(0) int eventCount,
    Map<String, dynamic>? settings,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Moment;

  factory Moment.fromJson(Map<String, dynamic> json) =>
      _$MomentFromJson(json);
}
