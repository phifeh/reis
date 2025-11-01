import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/models/result.dart';
import 'package:reis/core/providers/providers.dart';

class QuickCaptureChannel {
  static const platform = MethodChannel('com.reis.reis/quick_capture');
  
  static void setupHandler(WidgetRef ref) {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'quickCapture') {
        return await _handleQuickCapture(ref);
      }
      throw PlatformException(
        code: 'NOT_IMPLEMENTED',
        message: 'Method ${call.method} not implemented',
      );
    });
  }
  
  static Future<void> _handleQuickCapture(WidgetRef ref) async {
    try {
      final photoCaptureService = ref.read(photoCaptureServiceProvider);
      
      final cameraResult = await photoCaptureService.initializeCamera();
      
      if (cameraResult is Failure) {
        throw Exception('Failed to initialize camera');
      }
      
      final captureResult = await photoCaptureService.capturePhoto();
      
      photoCaptureService.dispose();
      
      if (captureResult is Failure) {
        throw Exception('Failed to capture photo');
      }
      
      return;
    } catch (e) {
      throw PlatformException(
        code: 'CAPTURE_ERROR',
        message: e.toString(),
      );
    }
  }
}
