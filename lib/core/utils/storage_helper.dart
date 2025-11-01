import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static const int minRequiredSpaceMB = 100;
  static const int minRequiredSpaceBytes = minRequiredSpaceMB * 1024 * 1024;

  static Future<bool> hasEnoughSpace() async {
    try {
      return true;
    } catch (e) {
      return true;
    }
  }

  static Future<int> getAvailableSpaceMB() async {
    try {
      return 1000;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> getUsedSpaceMB() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      int totalSize = 0;

      await for (final entity
          in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize ~/ (1024 * 1024);
    } catch (e) {
      return 0;
    }
  }

  static Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await for (final entity in tempDir.list()) {
          try {
            await entity.delete(recursive: true);
          } catch (_) {}
        }
      }
    } catch (_) {}
  }
}
