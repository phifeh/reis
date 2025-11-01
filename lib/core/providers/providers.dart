import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/repositories/capture_event_repository.dart';
import 'package:reis/core/repositories/moment_repository.dart';
import 'package:reis/core/repositories/sqlite_capture_event_repository.dart';
import 'package:reis/core/repositories/sqlite_moment_repository.dart';
import 'package:reis/core/services/capture_service.dart';
import 'package:reis/core/services/moment_service.dart';
import 'package:reis/core/services/moment_detection_service.dart';
import 'package:reis/core/services/photo_capture_service.dart';
import 'package:reis/core/services/video_capture_service.dart';
import 'package:reis/core/services/battery_monitor_service.dart';
import 'package:reis/core/services/power_profile_service.dart';
import 'package:reis/core/services/background_location_service.dart';

final captureEventRepositoryProvider =
    Provider<CaptureEventRepository>((ref) {
  return SqliteCaptureEventRepository();
});

final momentRepositoryProvider = Provider<MomentRepository>((ref) {
  return SqliteMomentRepository();
});

final captureServiceProvider = Provider<CaptureService>((ref) {
  final repository = ref.watch(captureEventRepositoryProvider);
  return CaptureService(repository);
});

final momentServiceProvider = Provider<MomentService>((ref) {
  final momentRepo = ref.watch(momentRepositoryProvider);
  final eventRepo = ref.watch(captureEventRepositoryProvider);
  return MomentService(momentRepo, eventRepo);
});

final momentDetectionServiceProvider =
    Provider<MomentDetectionService>((ref) {
  final momentRepo = ref.watch(momentRepositoryProvider);
  final eventRepo = ref.watch(captureEventRepositoryProvider);
  return MomentDetectionService(momentRepo, eventRepo);
});

final photoCaptureServiceProvider = Provider<PhotoCaptureService>((ref) {
  final repository = ref.watch(captureEventRepositoryProvider);
  return PhotoCaptureService(repository);
});

final videoCaptureServiceProvider = Provider<VideoCaptureService>((ref) {
  final repository = ref.watch(captureEventRepositoryProvider);
  return VideoCaptureService(repository);
});

final batteryMonitorServiceProvider = Provider<BatteryMonitorService>((ref) {
  return BatteryMonitorService();
});

final powerProfileServiceProvider = Provider<PowerProfileService>((ref) {
  final batteryService = ref.watch(batteryMonitorServiceProvider);
  final locationService = BackgroundLocationService();
  return PowerProfileService(batteryService, locationService);
});

final batteryLevelProvider = StreamProvider<int>((ref) {
  final service = ref.watch(batteryMonitorServiceProvider);
  return service.batteryLevelStream;
});

final powerModeProvider = Provider<PowerMode>((ref) {
  final batteryLevel = ref.watch(batteryLevelProvider).value ?? 100;
  if (batteryLevel < 20) {
    return PowerMode.saving;
  } else if (batteryLevel < 40) {
    return PowerMode.balanced;
  } else {
    return PowerMode.normal;
  }
});
