import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../../../core/providers/providers.dart';
import 'package:reis/core/models/result_extension.dart';
import '../../../core/utils/permissions_helper.dart';
import 'events_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  bool _isInitialized = false;
  bool _isCapturing = false;
  String? _error;
  bool _permissionDenied = false;
  bool _isBurstMode = false;
  int _burstCount = 0;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitialize();
  }

  Future<void> _checkPermissionsAndInitialize() async {
    final hasPermission = await PermissionsHelper.requestCameraPermission();

    if (!hasPermission) {
      if (mounted) {
        setState(() {
          _permissionDenied = true;
          _error = 'Camera permission required';
        });
      }
      return;
    }

    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final photoService = ref.read(photoCaptureServiceProvider);
    final result = await photoService.initializeCamera();

    if (mounted) {
      result.when(
        success: (_) {
          setState(() {
            _isInitialized = true;
            _error = null;
          });
        },
        failure: (message, _) {
          setState(() {
            _error = message;
          });
        },
      );
    }
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing) return;

    final photoService = ref.read(photoCaptureServiceProvider);
    if (photoService.isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    final result = await photoService.capturePhoto();

    if (mounted) {
      result.when(
        success: (event) {
          ref.invalidate(eventsProvider);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                event.location != null
                    ? 'Photo captured with GPS'
                    : 'Photo captured (no GPS)',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        failure: (message, _) {
          setState(() {
            _isCapturing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $message'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      );
    }
  }

  Future<void> _startBurstCapture() async {
    if (_isCapturing) return;

    setState(() {
      _isBurstMode = true;
      _isCapturing = true;
      _burstCount = 0;
    });

    const burstPhotos = 5;
    const burstInterval = Duration(milliseconds: 500);
    
    final photoService = ref.read(photoCaptureServiceProvider);

    for (int i = 0; i < burstPhotos; i++) {
      if (!_isBurstMode || !mounted) break;
      
      final result = await photoService.capturePhoto();
      
      if (mounted) {
        result.when(
          success: (_) {
            setState(() {
              _burstCount++;
            });
            ref.invalidate(eventsProvider);
          },
          failure: (message, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Burst error: $message'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      }

      if (i < burstPhotos - 1) {
        await Future.delayed(burstInterval);
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Captured $_burstCount photos'),
          duration: const Duration(seconds: 2),
        ),
      );
      
      setState(() {
        _isBurstMode = false;
        _isCapturing = false;
        _burstCount = 0;
      });
    }
  }

  @override
  void dispose() {
    ref.read(photoCaptureServiceProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, size: 64),
              const SizedBox(height: 16),
              const Text('Camera permission required'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _checkPermissionsAndInitialize,
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null && !_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final controller = ref.read(photoCaptureServiceProvider).controller!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(controller)),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Spacer(),
                if (_isBurstMode)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Burst Mode: $_burstCount/5',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: _CaptureButton(
                    isCapturing: _isCapturing,
                    onTap: _capturePhoto,
                    onLongPress: _startBurstCapture,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final bool isCapturing;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CaptureButton({
    required this.isCapturing,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (isCapturing) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
