import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/features/explore/presentation/explore_provider.dart';
import 'package:reis/features/explore/models/event_group.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

final exportServiceProvider = Provider((ref) => ExportService(ref));

class ExportService {
  final Ref ref;

  ExportService(this.ref);

  Future<bool> exportAsMarkdown() async {
    try {
      final groupedEventsAsync = ref.read(groupedEventsProvider);
      final groupedEvents = groupedEventsAsync.valueOrNull;
      
      if (groupedEvents == null) {
        return false;
      }
      
      final markdown = _generateMarkdown(groupedEvents);
      
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/reis_export_${DateTime.now().millisecondsSinceEpoch}.md');
      await file.writeAsString(markdown);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Reis Memories Export',
      );
      
      return true;
    } catch (e) {
      print('Error exporting as markdown: $e');
      return false;
    }
  }

  Future<bool> exportAsJson() async {
    try {
      final groupedEventsAsync = ref.read(groupedEventsProvider);
      final groupedEvents = groupedEventsAsync.valueOrNull;
      
      if (groupedEvents == null) {
        return false;
      }
      
      final jsonData = _generateJson(groupedEvents);
      
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/reis_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonData);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Reis Memories Export',
      );
      
      return true;
    } catch (e) {
      print('Error exporting as JSON: $e');
      return false;
    }
  }

  Future<bool> exportAsText() async {
    try {
      final groupedEventsAsync = ref.read(groupedEventsProvider);
      final groupedEvents = groupedEventsAsync.valueOrNull;
      
      if (groupedEvents == null) {
        return false;
      }
      
      final text = _generateText(groupedEvents);
      
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/reis_export_${DateTime.now().millisecondsSinceEpoch}.txt');
      await file.writeAsString(text);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Reis Memories Export',
      );
      
      return true;
    } catch (e) {
      print('Error exporting as text: $e');
      return false;
    }
  }

  Future<bool> exportAsHtml() async {
    try {
      final groupedEventsAsync = ref.read(groupedEventsProvider);
      final groupedEvents = groupedEventsAsync.valueOrNull;
      
      if (groupedEvents == null) {
        return false;
      }
      
      final html = _generateHtml(groupedEvents);
      
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/reis_export_${DateTime.now().millisecondsSinceEpoch}.html');
      await file.writeAsString(html);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Reis Memories Export',
      );
      
      return true;
    } catch (e) {
      print('Error exporting as HTML: $e');
      return false;
    }
  }

  String _generateMarkdown(List<EventGroup> groups) {
    final buffer = StringBuffer();
    buffer.writeln('# Reis Memories\n');
    buffer.writeln('*Exported on ${DateFormat('MMMM d, y').format(DateTime.now())}*\n');
    buffer.writeln('---\n');
    
    for (final group in groups) {
      buffer.writeln('## ${group.title}\n');
      
      if (group.location != null) {
        buffer.writeln('📍 ${group.location}\n');
      }
      
      buffer.writeln('**${group.events.length} ${group.events.length == 1 ? 'item' : 'items'}**\n');
      
      for (final event in group.events) {
        final time = DateFormat('HH:mm').format(event.timestamp);
        buffer.writeln('### $time - ${_getEventTypeLabel(event.type)}\n');
        buffer.writeln(_getEventMarkdown(event));
        buffer.writeln();
      }
      
      buffer.writeln('---\n');
    }
    
    return buffer.toString();
  }

  String _generateJson(List<EventGroup> groups) {
    final data = {
      'exported_at': DateTime.now().toIso8601String(),
      'groups': groups.map((group) {
        return {
          'id': group.id,
          'title': group.title,
          'start_time': group.startTime.toIso8601String(),
          'end_time': group.endTime.toIso8601String(),
          'location': group.location,
          'latitude': group.latitude,
          'longitude': group.longitude,
          'events': group.events.map((event) => event.toJson()).toList(),
        };
      }).toList(),
    };
    
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  String _generateText(List<EventGroup> groups) {
    final buffer = StringBuffer();
    buffer.writeln('REIS MEMORIES');
    buffer.writeln('Exported on ${DateFormat('MMMM d, y').format(DateTime.now())}');
    buffer.writeln('${'=' * 60}\n');
    
    for (final group in groups) {
      buffer.writeln(group.title);
      if (group.location != null) {
        buffer.writeln('Location: ${group.location}');
      }
      buffer.writeln('Items: ${group.events.length}');
      buffer.writeln('-' * 60);
      
      for (final event in group.events) {
        final time = DateFormat('HH:mm').format(event.timestamp);
        buffer.writeln('$time - ${_getEventTypeLabel(event.type)}');
        buffer.writeln(_getEventText(event));
        buffer.writeln();
      }
      
      buffer.writeln('${'=' * 60}\n');
    }
    
    return buffer.toString();
  }

  String _generateHtml(List<EventGroup> groups) {
    final buffer = StringBuffer();
    buffer.writeln('''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reis Memories</title>
  <style>
    body {
      font-family: 'Spectral', Georgia, serif;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
      background-color: #F5F1E8;
      color: #5C4A3C;
    }
    h1 {
      color: #E07A5F;
      border-bottom: 2px solid #E07A5F;
      padding-bottom: 10px;
    }
    h2 {
      color: #8B7355;
      margin-top: 30px;
    }
    h3 {
      color: #5C4A3C;
      font-size: 1.1em;
    }
    .group {
      background-color: #FAF8F0;
      border: 1px solid #D4C4A8;
      border-radius: 4px;
      padding: 20px;
      margin-bottom: 20px;
    }
    .event {
      margin: 15px 0;
      padding-left: 10px;
      border-left: 3px solid #E07A5F;
    }
    .meta {
      color: #8B7355;
      font-size: 0.9em;
      font-style: italic;
    }
    .location {
      color: #6B9080;
      margin: 5px 0;
    }
  </style>
</head>
<body>
  <h1>Reis Memories</h1>
  <p class="meta">Exported on ${DateFormat('MMMM d, y').format(DateTime.now())}</p>
''');
    
    for (final group in groups) {
      buffer.writeln('  <div class="group">');
      buffer.writeln('    <h2>${group.title}</h2>');
      
      if (group.location != null) {
        buffer.writeln('    <p class="location">📍 ${group.location}</p>');
      }
      
      buffer.writeln('    <p class="meta">${group.events.length} ${group.events.length == 1 ? 'item' : 'items'}</p>');
      
      for (final event in group.events) {
        final time = DateFormat('HH:mm').format(event.timestamp);
        buffer.writeln('    <div class="event">');
        buffer.writeln('      <h3>$time - ${_getEventTypeLabel(event.type)}</h3>');
        buffer.writeln('      ${_getEventHtml(event)}');
        buffer.writeln('    </div>');
      }
      
      buffer.writeln('  </div>');
    }
    
    buffer.writeln('</body>');
    buffer.writeln('</html>');
    
    return buffer.toString();
  }

  String _getEventTypeLabel(CaptureType type) {
    switch (type) {
      case CaptureType.photo:
        return 'Photo';
      case CaptureType.video:
        return 'Video';
      case CaptureType.audio:
        return 'Audio';
      case CaptureType.text:
        return 'Note';
      case CaptureType.rating:
        return 'Rating';
      case CaptureType.sketch:
        return 'Sketch';
      case CaptureType.imported:
        return 'Imported';
    }
  }

  String _getEventMarkdown(CaptureEvent event) {
    switch (event.type) {
      case CaptureType.photo:
        final note = event.data['note'] as String?;
        return note != null ? note : '*Photo*';
      case CaptureType.video:
        return '*Video*';
      case CaptureType.audio:
        final duration = event.data['duration'] as int? ?? 0;
        return '*Audio recording (${duration}s)*';
      case CaptureType.text:
        final text = event.data['text'] as String? ?? '';
        final title = event.data['title'] as String?;
        if (title != null) {
          return '**$title**\n\n$text';
        }
        return text;
      case CaptureType.rating:
        final rating = event.data['rating'] as int? ?? 0;
        final place = event.data['place'] as String?;
        final stars = '⭐' * rating;
        return place != null ? '$stars\n$place' : stars;
      case CaptureType.sketch:
        return '*Sketch*';
      default:
        return '';
    }
  }

  String _getEventText(CaptureEvent event) {
    switch (event.type) {
      case CaptureType.photo:
        final note = event.data['note'] as String?;
        return note ?? '[Photo]';
      case CaptureType.video:
        return '[Video]';
      case CaptureType.audio:
        final duration = event.data['duration'] as int? ?? 0;
        return '[Audio recording (${duration}s)]';
      case CaptureType.text:
        final text = event.data['text'] as String? ?? '';
        final title = event.data['title'] as String?;
        if (title != null) {
          return '$title\n$text';
        }
        return text;
      case CaptureType.rating:
        final rating = event.data['rating'] as int? ?? 0;
        final place = event.data['place'] as String?;
        final stars = '*' * rating;
        return place != null ? '$stars ($rating/5)\n$place' : '$stars ($rating/5)';
      case CaptureType.sketch:
        return '[Sketch]';
      default:
        return '';
    }
  }

  String _getEventHtml(CaptureEvent event) {
    switch (event.type) {
      case CaptureType.photo:
        final note = event.data['note'] as String?;
        return note != null ? '<p>$note</p>' : '<p><em>Photo</em></p>';
      case CaptureType.video:
        return '<p><em>Video</em></p>';
      case CaptureType.audio:
        final duration = event.data['duration'] as int? ?? 0;
        return '<p><em>Audio recording (${duration}s)</em></p>';
      case CaptureType.text:
        final text = event.data['text'] as String? ?? '';
        final title = event.data['title'] as String?;
        if (title != null) {
          return '<p><strong>$title</strong></p><p>$text</p>';
        }
        return '<p>$text</p>';
      case CaptureType.rating:
        final rating = event.data['rating'] as int? ?? 0;
        final place = event.data['place'] as String?;
        final stars = '⭐' * rating;
        return place != null ? '<p>$stars</p><p>$place</p>' : '<p>$stars</p>';
      case CaptureType.sketch:
        return '<p><em>Sketch</em></p>';
      default:
        return '';
    }
  }
}
