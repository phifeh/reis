// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CaptureEvent _$CaptureEventFromJson(Map<String, dynamic> json) {
  return _CaptureEvent.fromJson(json);
}

/// @nodoc
mixin _$CaptureEvent {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Location? get location => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  CaptureType get type => throw _privateConstructorUsedError;

  /// Serializes this CaptureEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaptureEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaptureEventCopyWith<CaptureEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureEventCopyWith<$Res> {
  factory $CaptureEventCopyWith(
    CaptureEvent value,
    $Res Function(CaptureEvent) then,
  ) = _$CaptureEventCopyWithImpl<$Res, CaptureEvent>;
  @useResult
  $Res call({
    String id,
    DateTime timestamp,
    Location? location,
    Map<String, dynamic> data,
    CaptureType type,
  });

  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$CaptureEventCopyWithImpl<$Res, $Val extends CaptureEvent>
    implements $CaptureEventCopyWith<$Res> {
  _$CaptureEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaptureEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? location = freezed,
    Object? data = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as Location?,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CaptureType,
          )
          as $Val,
    );
  }

  /// Create a copy of CaptureEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CaptureEventImplCopyWith<$Res>
    implements $CaptureEventCopyWith<$Res> {
  factory _$$CaptureEventImplCopyWith(
    _$CaptureEventImpl value,
    $Res Function(_$CaptureEventImpl) then,
  ) = __$$CaptureEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime timestamp,
    Location? location,
    Map<String, dynamic> data,
    CaptureType type,
  });

  @override
  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$CaptureEventImplCopyWithImpl<$Res>
    extends _$CaptureEventCopyWithImpl<$Res, _$CaptureEventImpl>
    implements _$$CaptureEventImplCopyWith<$Res> {
  __$$CaptureEventImplCopyWithImpl(
    _$CaptureEventImpl _value,
    $Res Function(_$CaptureEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaptureEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? location = freezed,
    Object? data = null,
    Object? type = null,
  }) {
    return _then(
      _$CaptureEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as Location?,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CaptureType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaptureEventImpl implements _CaptureEvent {
  const _$CaptureEventImpl({
    required this.id,
    required this.timestamp,
    this.location,
    required final Map<String, dynamic> data,
    required this.type,
  }) : _data = data;

  factory _$CaptureEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureEventImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final Location? location;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final CaptureType type;

  @override
  String toString() {
    return 'CaptureEvent(id: $id, timestamp: $timestamp, location: $location, data: $data, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    timestamp,
    location,
    const DeepCollectionEquality().hash(_data),
    type,
  );

  /// Create a copy of CaptureEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureEventImplCopyWith<_$CaptureEventImpl> get copyWith =>
      __$$CaptureEventImplCopyWithImpl<_$CaptureEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureEventImplToJson(this);
  }
}

abstract class _CaptureEvent implements CaptureEvent {
  const factory _CaptureEvent({
    required final String id,
    required final DateTime timestamp,
    final Location? location,
    required final Map<String, dynamic> data,
    required final CaptureType type,
  }) = _$CaptureEventImpl;

  factory _CaptureEvent.fromJson(Map<String, dynamic> json) =
      _$CaptureEventImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  Location? get location;
  @override
  Map<String, dynamic> get data;
  @override
  CaptureType get type;

  /// Create a copy of CaptureEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaptureEventImplCopyWith<_$CaptureEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
