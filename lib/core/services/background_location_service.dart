import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reis/core/models/location.dart' as app_location;
import 'package:reis/core/repositories/capture_event_repository.dart';
import 'package:reis/core/models/capture_event.dart';

class BackgroundLocationService {
  static final BackgroundLocationService _instance =
      BackgroundLocationService._internal();

  factory BackgroundLocationService() {
    return _instance;
  }

  BackgroundLocationService._internal();

  bool _isInitialized = false;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;
  DateTime? _lastLocationTime;
  Timer? _periodicTimer;
  Duration _currentInterval = const Duration(minutes: 5);
  LocationAccuracy _currentAccuracy = LocationAccuracy.medium;

  bool get isTracking => _isTracking;
  Duration get currentInterval => _currentInterval;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    debugPrint('[BackgroundLocation] Initialized (foreground tracking mode)');
  }

  Future<bool> startTracking({
    Duration interval = const Duration(minutes: 5),
    bool createJourneyMoments = false,
    LocationAccuracy accuracy = LocationAccuracy.medium,
  }) async {
    if (_isTracking) {
      debugPrint('[BackgroundLocation] Already tracking');
      return true;
    }

    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      debugPrint('[BackgroundLocation] Permission denied');
      return false;
    }

    await initialize();

    _isTracking = true;
    _currentInterval = interval;
    _currentAccuracy = accuracy;
    _lastLocationTime = DateTime.now();

    // Use position stream for real-time updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: 50,
      ),
    ).listen(
      _handlePositionUpdate,
      onError: (error) {
        debugPrint('[BackgroundLocation] Stream error: $error');
      },
    );

    // Periodic timer for journey waypoints
    if (createJourneyMoments) {
      _periodicTimer = Timer.periodic(interval, (timer) async {
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: accuracy,
          );
          _handlePositionUpdate(position);
        } catch (e) {
          debugPrint('[BackgroundLocation] Periodic update error: $e');
        }
      });
    }

    debugPrint('[BackgroundLocation] Started tracking (${interval.inMinutes}min, $accuracy accuracy)');
    return true;
  }
  
  Future<void> updateInterval(Duration newInterval) async {
    if (!_isTracking) {
      _currentInterval = newInterval;
      return;
    }
    
    _currentInterval = newInterval;
    
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(newInterval, (timer) async {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: _currentAccuracy,
        );
        _handlePositionUpdate(position);
      } catch (e) {
        debugPrint('[BackgroundLocation] Periodic update error: $e');
      }
    });
    
    debugPrint('[BackgroundLocation] Updated interval to ${newInterval.inMinutes} minutes');
  }
  
  Future<void> updateAccuracy(LocationAccuracy newAccuracy) async {
    if (!_isTracking) {
      _currentAccuracy = newAccuracy;
      return;
    }
    
    _currentAccuracy = newAccuracy;
    
    await _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: newAccuracy,
        distanceFilter: 50,
      ),
    ).listen(
      _handlePositionUpdate,
      onError: (error) {
        debugPrint('[BackgroundLocation] Stream error: $error');
      },
    );
    
    debugPrint('[BackgroundLocation] Updated accuracy to $newAccuracy');
  }

  Future<void> stopTracking() async {
    if (!_isTracking) return;

    await _positionStream?.cancel();
    _positionStream = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _isTracking = false;
    _lastPosition = null;
    _lastLocationTime = null;

    debugPrint('[BackgroundLocation] Stopped tracking');
  }

  void _handlePositionUpdate(Position position) {
    final now = DateTime.now();

    if (_lastPosition != null && _lastLocationTime != null) {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      final timeDiff = now.difference(_lastLocationTime!);

      debugPrint(
        '[BackgroundLocation] Update: ${position.latitude}, ${position.longitude} '
        '(${distance.toStringAsFixed(0)}m from last, ${timeDiff.inMinutes}min ago)',
      );
    }

    _lastPosition = position;
    _lastLocationTime = now;
  }

  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    if (permission == LocationPermission.denied) {
      return false;
    }

    return true;
  }

  app_location.Location? get currentLocation {
    if (_lastPosition == null) return null;

    return app_location.Location(
      latitude: _lastPosition!.latitude,
      longitude: _lastPosition!.longitude,
      accuracy: _lastPosition!.accuracy,
      altitude: _lastPosition!.altitude,
      timestamp: _lastLocationTime ?? DateTime.now(),
    );
  }

  Position? get lastPosition => _lastPosition;
  DateTime? get lastLocationTime => _lastLocationTime;

  Future<void> createJourneyMoment({
    required CaptureEventRepository repository,
  }) async {
    if (_lastPosition == null) return;

    final location = app_location.Location(
      latitude: _lastPosition!.latitude,
      longitude: _lastPosition!.longitude,
      accuracy: _lastPosition!.accuracy,
      altitude: _lastPosition!.altitude,
      timestamp: _lastLocationTime ?? DateTime.now(),
    );

    final journeyEvent = CaptureEvent.text(
      location: location,
      text: 'Journey tracked at ${_lastLocationTime?.toLocal()}',
      title: 'Journey Waypoint',
    );

    await repository.save(journeyEvent);
    debugPrint('[BackgroundLocation] Created journey moment');
  }
}
