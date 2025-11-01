// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Moment _$MomentFromJson(Map<String, dynamic> json) {
  return _Moment.fromJson(json);
}

/// @nodoc
mixin _$Moment {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  List<String> get eventIds => throw _privateConstructorUsedError;
  MomentType get type => throw _privateConstructorUsedError;
  String? get parentMomentId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  double? get centerLat => throw _privateConstructorUsedError;
  double? get centerLon => throw _privateConstructorUsedError;
  double get radiusMeters => throw _privateConstructorUsedError;
  int get eventCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Moment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MomentCopyWith<Moment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MomentCopyWith<$Res> {
  factory $MomentCopyWith(Moment value, $Res Function(Moment) then) =
      _$MomentCopyWithImpl<$Res, Moment>;
  @useResult
  $Res call({
    String id,
    String? name,
    List<String> eventIds,
    MomentType type,
    String? parentMomentId,
    DateTime startTime,
    DateTime? endTime,
    double? centerLat,
    double? centerLon,
    double radiusMeters,
    int eventCount,
    Map<String, dynamic>? settings,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$MomentCopyWithImpl<$Res, $Val extends Moment>
    implements $MomentCopyWith<$Res> {
  _$MomentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? eventIds = null,
    Object? type = null,
    Object? parentMomentId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? centerLat = freezed,
    Object? centerLon = freezed,
    Object? radiusMeters = null,
    Object? eventCount = null,
    Object? settings = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventIds: null == eventIds
                ? _value.eventIds
                : eventIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MomentType,
            parentMomentId: freezed == parentMomentId
                ? _value.parentMomentId
                : parentMomentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            centerLat: freezed == centerLat
                ? _value.centerLat
                : centerLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            centerLon: freezed == centerLon
                ? _value.centerLon
                : centerLon // ignore: cast_nullable_to_non_nullable
                      as double?,
            radiusMeters: null == radiusMeters
                ? _value.radiusMeters
                : radiusMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            eventCount: null == eventCount
                ? _value.eventCount
                : eventCount // ignore: cast_nullable_to_non_nullable
                      as int,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MomentImplCopyWith<$Res> implements $MomentCopyWith<$Res> {
  factory _$$MomentImplCopyWith(
    _$MomentImpl value,
    $Res Function(_$MomentImpl) then,
  ) = __$$MomentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? name,
    List<String> eventIds,
    MomentType type,
    String? parentMomentId,
    DateTime startTime,
    DateTime? endTime,
    double? centerLat,
    double? centerLon,
    double radiusMeters,
    int eventCount,
    Map<String, dynamic>? settings,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$MomentImplCopyWithImpl<$Res>
    extends _$MomentCopyWithImpl<$Res, _$MomentImpl>
    implements _$$MomentImplCopyWith<$Res> {
  __$$MomentImplCopyWithImpl(
    _$MomentImpl _value,
    $Res Function(_$MomentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? eventIds = null,
    Object? type = null,
    Object? parentMomentId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? centerLat = freezed,
    Object? centerLon = freezed,
    Object? radiusMeters = null,
    Object? eventCount = null,
    Object? settings = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MomentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventIds: null == eventIds
            ? _value._eventIds
            : eventIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MomentType,
        parentMomentId: freezed == parentMomentId
            ? _value.parentMomentId
            : parentMomentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        centerLat: freezed == centerLat
            ? _value.centerLat
            : centerLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        centerLon: freezed == centerLon
            ? _value.centerLon
            : centerLon // ignore: cast_nullable_to_non_nullable
                  as double?,
        radiusMeters: null == radiusMeters
            ? _value.radiusMeters
            : radiusMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        eventCount: null == eventCount
            ? _value.eventCount
            : eventCount // ignore: cast_nullable_to_non_nullable
                  as int,
        settings: freezed == settings
            ? _value._settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MomentImpl implements _Moment {
  const _$MomentImpl({
    required this.id,
    this.name,
    required final List<String> eventIds,
    required this.type,
    this.parentMomentId,
    required this.startTime,
    this.endTime,
    this.centerLat,
    this.centerLon,
    this.radiusMeters = 100.0,
    this.eventCount = 0,
    final Map<String, dynamic>? settings,
    required this.createdAt,
    required this.updatedAt,
  }) : _eventIds = eventIds,
       _settings = settings;

  factory _$MomentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MomentImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  final List<String> _eventIds;
  @override
  List<String> get eventIds {
    if (_eventIds is EqualUnmodifiableListView) return _eventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventIds);
  }

  @override
  final MomentType type;
  @override
  final String? parentMomentId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final double? centerLat;
  @override
  final double? centerLon;
  @override
  @JsonKey()
  final double radiusMeters;
  @override
  @JsonKey()
  final int eventCount;
  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Moment(id: $id, name: $name, eventIds: $eventIds, type: $type, parentMomentId: $parentMomentId, startTime: $startTime, endTime: $endTime, centerLat: $centerLat, centerLon: $centerLon, radiusMeters: $radiusMeters, eventCount: $eventCount, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MomentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._eventIds, _eventIds) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.parentMomentId, parentMomentId) ||
                other.parentMomentId == parentMomentId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.centerLat, centerLat) ||
                other.centerLat == centerLat) &&
            (identical(other.centerLon, centerLon) ||
                other.centerLon == centerLon) &&
            (identical(other.radiusMeters, radiusMeters) ||
                other.radiusMeters == radiusMeters) &&
            (identical(other.eventCount, eventCount) ||
                other.eventCount == eventCount) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_eventIds),
    type,
    parentMomentId,
    startTime,
    endTime,
    centerLat,
    centerLon,
    radiusMeters,
    eventCount,
    const DeepCollectionEquality().hash(_settings),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MomentImplCopyWith<_$MomentImpl> get copyWith =>
      __$$MomentImplCopyWithImpl<_$MomentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MomentImplToJson(this);
  }
}

abstract class _Moment implements Moment {
  const factory _Moment({
    required final String id,
    final String? name,
    required final List<String> eventIds,
    required final MomentType type,
    final String? parentMomentId,
    required final DateTime startTime,
    final DateTime? endTime,
    final double? centerLat,
    final double? centerLon,
    final double radiusMeters,
    final int eventCount,
    final Map<String, dynamic>? settings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MomentImpl;

  factory _Moment.fromJson(Map<String, dynamic> json) = _$MomentImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  List<String> get eventIds;
  @override
  MomentType get type;
  @override
  String? get parentMomentId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  double? get centerLat;
  @override
  double? get centerLon;
  @override
  double get radiusMeters;
  @override
  int get eventCount;
  @override
  Map<String, dynamic>? get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MomentImplCopyWith<_$MomentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
