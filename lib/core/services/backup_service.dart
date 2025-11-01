import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<String> createBackup() async {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final tempDir = await getTemporaryDirectory();
    final backupDir = Directory('${tempDir.path}/reis_backup_$timestamp');
    
    if (await backupDir.exists()) {
      await backupDir.delete(recursive: true);
    }
    await backupDir.create(recursive: true);

    // Copy database
    final dbPath = await getDatabasesPath();
    final dbFile = File(path.join(dbPath, 'travel_journal.db'));
    if (await dbFile.exists()) {
      await dbFile.copy('${backupDir.path}/travel_journal.db');
    }

    // Copy all files from app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    if (await appDir.exists()) {
      await _copyDirectory(appDir, Directory('${backupDir.path}/documents'));
    }

    // Create zip archive
    final zipPath = '${tempDir.path}/reis_backup_$timestamp.zip';
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addDirectory(backupDir);
    encoder.close();

    // Cleanup temp backup directory
    await backupDir.delete(recursive: true);

    return zipPath;
  }

  static Future<void> shareBackup() async {
    final zipPath = await createBackup();
    final file = File(zipPath);
    
    if (await file.exists()) {
      await Share.shareXFiles(
        [XFile(zipPath)],
        subject: 'Reis App Backup - ${DateTime.now().toIso8601String()}',
      );
      
      // Cleanup after a delay (user might still be uploading)
      Future.delayed(const Duration(minutes: 5), () async {
        if (await file.exists()) {
          await file.delete();
        }
      });
    }
  }

  static Future<void> _copyDirectory(Directory source, Directory destination) async {
    if (!await destination.exists()) {
      await destination.create(recursive: true);
    }

    await for (final entity in source.list(recursive: false)) {
      if (entity is Directory) {
        final newDirectory = Directory(
          path.join(destination.path, path.basename(entity.path))
        );
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        await entity.copy(
          path.join(destination.path, path.basename(entity.path))
        );
      }
    }
  }
}
