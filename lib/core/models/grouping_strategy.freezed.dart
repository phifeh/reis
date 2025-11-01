// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouping_strategy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GroupingStrategy _$GroupingStrategyFromJson(Map<String, dynamic> json) {
  return _GroupingStrategy.fromJson(json);
}

/// @nodoc
mixin _$GroupingStrategy {
  Duration get timeThreshold => throw _privateConstructorUsedError;
  double get distanceThreshold => throw _privateConstructorUsedError;
  int get minEventsForMoment => throw _privateConstructorUsedError;
  bool get autoGroupEnabled => throw _privateConstructorUsedError;

  /// Serializes this GroupingStrategy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupingStrategy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupingStrategyCopyWith<GroupingStrategy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupingStrategyCopyWith<$Res> {
  factory $GroupingStrategyCopyWith(
    GroupingStrategy value,
    $Res Function(GroupingStrategy) then,
  ) = _$GroupingStrategyCopyWithImpl<$Res, GroupingStrategy>;
  @useResult
  $Res call({
    Duration timeThreshold,
    double distanceThreshold,
    int minEventsForMoment,
    bool autoGroupEnabled,
  });
}

/// @nodoc
class _$GroupingStrategyCopyWithImpl<$Res, $Val extends GroupingStrategy>
    implements $GroupingStrategyCopyWith<$Res> {
  _$GroupingStrategyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupingStrategy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeThreshold = null,
    Object? distanceThreshold = null,
    Object? minEventsForMoment = null,
    Object? autoGroupEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            timeThreshold: null == timeThreshold
                ? _value.timeThreshold
                : timeThreshold // ignore: cast_nullable_to_non_nullable
                      as Duration,
            distanceThreshold: null == distanceThreshold
                ? _value.distanceThreshold
                : distanceThreshold // ignore: cast_nullable_to_non_nullable
                      as double,
            minEventsForMoment: null == minEventsForMoment
                ? _value.minEventsForMoment
                : minEventsForMoment // ignore: cast_nullable_to_non_nullable
                      as int,
            autoGroupEnabled: null == autoGroupEnabled
                ? _value.autoGroupEnabled
                : autoGroupEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupingStrategyImplCopyWith<$Res>
    implements $GroupingStrategyCopyWith<$Res> {
  factory _$$GroupingStrategyImplCopyWith(
    _$GroupingStrategyImpl value,
    $Res Function(_$GroupingStrategyImpl) then,
  ) = __$$GroupingStrategyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Duration timeThreshold,
    double distanceThreshold,
    int minEventsForMoment,
    bool autoGroupEnabled,
  });
}

/// @nodoc
class __$$GroupingStrategyImplCopyWithImpl<$Res>
    extends _$GroupingStrategyCopyWithImpl<$Res, _$GroupingStrategyImpl>
    implements _$$GroupingStrategyImplCopyWith<$Res> {
  __$$GroupingStrategyImplCopyWithImpl(
    _$GroupingStrategyImpl _value,
    $Res Function(_$GroupingStrategyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupingStrategy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeThreshold = null,
    Object? distanceThreshold = null,
    Object? minEventsForMoment = null,
    Object? autoGroupEnabled = null,
  }) {
    return _then(
      _$GroupingStrategyImpl(
        timeThreshold: null == timeThreshold
            ? _value.timeThreshold
            : timeThreshold // ignore: cast_nullable_to_non_nullable
                  as Duration,
        distanceThreshold: null == distanceThreshold
            ? _value.distanceThreshold
            : distanceThreshold // ignore: cast_nullable_to_non_nullable
                  as double,
        minEventsForMoment: null == minEventsForMoment
            ? _value.minEventsForMoment
            : minEventsForMoment // ignore: cast_nullable_to_non_nullable
                  as int,
        autoGroupEnabled: null == autoGroupEnabled
            ? _value.autoGroupEnabled
            : autoGroupEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupingStrategyImpl implements _GroupingStrategy {
  const _$GroupingStrategyImpl({
    required this.timeThreshold,
    required this.distanceThreshold,
    this.minEventsForMoment = 3,
    this.autoGroupEnabled = true,
  });

  factory _$GroupingStrategyImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupingStrategyImplFromJson(json);

  @override
  final Duration timeThreshold;
  @override
  final double distanceThreshold;
  @override
  @JsonKey()
  final int minEventsForMoment;
  @override
  @JsonKey()
  final bool autoGroupEnabled;

  @override
  String toString() {
    return 'GroupingStrategy(timeThreshold: $timeThreshold, distanceThreshold: $distanceThreshold, minEventsForMoment: $minEventsForMoment, autoGroupEnabled: $autoGroupEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupingStrategyImpl &&
            (identical(other.timeThreshold, timeThreshold) ||
                other.timeThreshold == timeThreshold) &&
            (identical(other.distanceThreshold, distanceThreshold) ||
                other.distanceThreshold == distanceThreshold) &&
            (identical(other.minEventsForMoment, minEventsForMoment) ||
                other.minEventsForMoment == minEventsForMoment) &&
            (identical(other.autoGroupEnabled, autoGroupEnabled) ||
                other.autoGroupEnabled == autoGroupEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timeThreshold,
    distanceThreshold,
    minEventsForMoment,
    autoGroupEnabled,
  );

  /// Create a copy of GroupingStrategy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupingStrategyImplCopyWith<_$GroupingStrategyImpl> get copyWith =>
      __$$GroupingStrategyImplCopyWithImpl<_$GroupingStrategyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupingStrategyImplToJson(this);
  }
}

abstract class _GroupingStrategy implements GroupingStrategy {
  const factory _GroupingStrategy({
    required final Duration timeThreshold,
    required final double distanceThreshold,
    final int minEventsForMoment,
    final bool autoGroupEnabled,
  }) = _$GroupingStrategyImpl;

  factory _GroupingStrategy.fromJson(Map<String, dynamic> json) =
      _$GroupingStrategyImpl.fromJson;

  @override
  Duration get timeThreshold;
  @override
  double get distanceThreshold;
  @override
  int get minEventsForMoment;
  @override
  bool get autoGroupEnabled;

  /// Create a copy of GroupingStrategy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupingStrategyImplCopyWith<_$GroupingStrategyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
