import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result == LocationPermission.whileInUse ||
          result == LocationPermission.always;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<Map<String, bool>> requestAllPermissions() async {
    return {
      'camera': await requestCameraPermission(),
      'location': await requestLocationPermission(),
      'microphone': await requestMicrophonePermission(),
    };
  }

  static Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<Position?> getCurrentLocation({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(timeout);
    } catch (e) {
      return null;
    }
  }
}
