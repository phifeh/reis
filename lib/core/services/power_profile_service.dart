import 'package:geolocator/geolocator.dart' as geo;
import 'package:reis/core/services/battery_monitor_service.dart';
import 'package:reis/core/services/background_location_service.dart';

class PowerProfileService {
  final BatteryMonitorService _batteryService;
  final BackgroundLocationService _locationService;
  
  PowerProfileService(this._batteryService, this._locationService);
  
  Future<void> applyPowerSavingMode() async {
    final mode = _batteryService.currentMode;
    final interval = _batteryService.getRecommendedTrackingInterval();
    
    await _locationService.updateInterval(interval);
    
    switch (mode) {
      case PowerMode.normal:
        break;
      case PowerMode.balanced:
        break;
      case PowerMode.saving:
        break;
    }
  }
  
  Future<void> restoreNormalMode() async {
    await _locationService.updateInterval(const Duration(minutes: 5));
  }
  
  geo.LocationAccuracy getGeolocatorAccuracy(LocationAccuracy accuracy) {
    switch (accuracy) {
      case LocationAccuracy.high:
        return geo.LocationAccuracy.high;
      case LocationAccuracy.medium:
        return geo.LocationAccuracy.medium;
      case LocationAccuracy.low:
        return geo.LocationAccuracy.low;
    }
  }
  
  String getPowerModeDescription(PowerMode mode) {
    switch (mode) {
      case PowerMode.normal:
        return 'Normal (5 min intervals, high accuracy)';
      case PowerMode.balanced:
        return 'Balanced (10 min intervals, medium accuracy)';
      case PowerMode.saving:
        return 'Power Saving (15 min intervals, low accuracy)';
    }
  }
  
  String getPowerModeIcon(PowerMode mode) {
    switch (mode) {
      case PowerMode.normal:
        return '🔋';
      case PowerMode.balanced:
        return '⚡';
      case PowerMode.saving:
        return '🪫';
    }
  }
}
