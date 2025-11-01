import 'package:battery_plus/battery_plus.dart';

enum PowerMode {
  normal,
  balanced,
  saving,
}

class BatteryMonitorService {
  final Battery _battery = Battery();
  
  PowerMode _currentMode = PowerMode.normal;
  int _lastBatteryLevel = 100;
  
  PowerMode get currentMode => _currentMode;
  int get batteryLevel => _lastBatteryLevel;
  
  Stream<int> get batteryLevelStream => _battery.onBatteryStateChanged.asyncMap(
    (_) async => await _battery.batteryLevel,
  );
  
  Future<void> initialize() async {
    _lastBatteryLevel = await _battery.batteryLevel;
    _updatePowerMode(_lastBatteryLevel);
    
    _battery.onBatteryStateChanged.listen((state) async {
      _lastBatteryLevel = await _battery.batteryLevel;
      _updatePowerMode(_lastBatteryLevel);
    });
  }
  
  void _updatePowerMode(int level) {
    if (level < 20) {
      _currentMode = PowerMode.saving;
    } else if (level < 40) {
      _currentMode = PowerMode.balanced;
    } else {
      _currentMode = PowerMode.normal;
    }
  }
  
  Future<bool> isCharging() async {
    final state = await _battery.batteryState;
    return state == BatteryState.charging || state == BatteryState.full;
  }
  
  bool shouldEnablePowerSaving() {
    return _lastBatteryLevel < 20;
  }
  
  Duration getRecommendedTrackingInterval() {
    switch (_currentMode) {
      case PowerMode.normal:
        return const Duration(minutes: 5);
      case PowerMode.balanced:
        return const Duration(minutes: 10);
      case PowerMode.saving:
        return const Duration(minutes: 15);
    }
  }
  
  LocationAccuracy getRecommendedAccuracy() {
    switch (_currentMode) {
      case PowerMode.normal:
        return LocationAccuracy.high;
      case PowerMode.balanced:
        return LocationAccuracy.medium;
      case PowerMode.saving:
        return LocationAccuracy.low;
    }
  }
}

enum LocationAccuracy {
  high,
  medium,
  low,
}

