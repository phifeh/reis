// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EventGroup {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<CaptureEvent> get events => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  bool get isCollapsed => throw _privateConstructorUsedError;

  /// Create a copy of EventGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventGroupCopyWith<EventGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventGroupCopyWith<$Res> {
  factory $EventGroupCopyWith(
    EventGroup value,
    $Res Function(EventGroup) then,
  ) = _$EventGroupCopyWithImpl<$Res, EventGroup>;
  @useResult
  $Res call({
    String id,
    String title,
    List<CaptureEvent> events,
    DateTime startTime,
    DateTime endTime,
    String? location,
    double? latitude,
    double? longitude,
    bool isCollapsed,
  });
}

/// @nodoc
class _$EventGroupCopyWithImpl<$Res, $Val extends EventGroup>
    implements $EventGroupCopyWith<$Res> {
  _$EventGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? events = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isCollapsed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            events: null == events
                ? _value.events
                : events // ignore: cast_nullable_to_non_nullable
                      as List<CaptureEvent>,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            isCollapsed: null == isCollapsed
                ? _value.isCollapsed
                : isCollapsed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventGroupImplCopyWith<$Res>
    implements $EventGroupCopyWith<$Res> {
  factory _$$EventGroupImplCopyWith(
    _$EventGroupImpl value,
    $Res Function(_$EventGroupImpl) then,
  ) = __$$EventGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    List<CaptureEvent> events,
    DateTime startTime,
    DateTime endTime,
    String? location,
    double? latitude,
    double? longitude,
    bool isCollapsed,
  });
}

/// @nodoc
class __$$EventGroupImplCopyWithImpl<$Res>
    extends _$EventGroupCopyWithImpl<$Res, _$EventGroupImpl>
    implements _$$EventGroupImplCopyWith<$Res> {
  __$$EventGroupImplCopyWithImpl(
    _$EventGroupImpl _value,
    $Res Function(_$EventGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? events = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isCollapsed = null,
  }) {
    return _then(
      _$EventGroupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        events: null == events
            ? _value._events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<CaptureEvent>,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        isCollapsed: null == isCollapsed
            ? _value.isCollapsed
            : isCollapsed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$EventGroupImpl implements _EventGroup {
  const _$EventGroupImpl({
    required this.id,
    required this.title,
    required final List<CaptureEvent> events,
    required this.startTime,
    required this.endTime,
    this.location,
    this.latitude,
    this.longitude,
    this.isCollapsed = false,
  }) : _events = events;

  @override
  final String id;
  @override
  final String title;
  final List<CaptureEvent> _events;
  @override
  List<CaptureEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String? location;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey()
  final bool isCollapsed;

  @override
  String toString() {
    return 'EventGroup(id: $id, title: $title, events: $events, startTime: $startTime, endTime: $endTime, location: $location, latitude: $latitude, longitude: $longitude, isCollapsed: $isCollapsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isCollapsed, isCollapsed) ||
                other.isCollapsed == isCollapsed));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_events),
    startTime,
    endTime,
    location,
    latitude,
    longitude,
    isCollapsed,
  );

  /// Create a copy of EventGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventGroupImplCopyWith<_$EventGroupImpl> get copyWith =>
      __$$EventGroupImplCopyWithImpl<_$EventGroupImpl>(this, _$identity);
}

abstract class _EventGroup implements EventGroup {
  const factory _EventGroup({
    required final String id,
    required final String title,
    required final List<CaptureEvent> events,
    required final DateTime startTime,
    required final DateTime endTime,
    final String? location,
    final double? latitude,
    final double? longitude,
    final bool isCollapsed,
  }) = _$EventGroupImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  List<CaptureEvent> get events;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String? get location;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  bool get isCollapsed;

  /// Create a copy of EventGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventGroupImplCopyWith<_$EventGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
