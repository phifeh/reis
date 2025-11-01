import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final double pressure;
  final DateTime timestamp;

  DrawingPoint({
    required this.offset,
    required this.pressure,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'x': offset.dx,
        'y': offset.dy,
        'pressure': pressure,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory DrawingPoint.fromJson(Map<String, dynamic> json) => DrawingPoint(
        offset: Offset(json['x'] as double, json['y'] as double),
        pressure: json['pressure'] as double,
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}

class Stroke {
  final List<DrawingPoint> points;
  final Color color;
  final double width;
  final DrawingTool tool;
  final String id;

  Stroke({
    required this.points,
    required this.color,
    required this.width,
    required this.tool,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points.map((p) => p.toJson()).toList(),
        'color': color.value,
        'width': width,
        'tool': tool.toString(),
      };

  factory Stroke.fromJson(Map<String, dynamic> json) => Stroke(
        id: json['id'] as String,
        points: (json['points'] as List)
            .map((p) => DrawingPoint.fromJson(p as Map<String, dynamic>))
            .toList(),
        color: Color(json['color'] as int),
        width: json['width'] as double,
        tool: DrawingTool.values.firstWhere(
          (t) => t.toString() == json['tool'],
          orElse: () => DrawingTool.pen,
        ),
      );
}

class SketchLayer {
  final String id;
  final List<Stroke> strokes;
  bool visible;
  double opacity;
  final String name;

  SketchLayer({
    String? id,
    List<Stroke>? strokes,
    this.visible = true,
    this.opacity = 1.0,
    String? name,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        strokes = strokes ?? [],
        name = name ?? 'Layer ${DateTime.now().millisecondsSinceEpoch}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'strokes': strokes.map((s) => s.toJson()).toList(),
        'visible': visible,
        'opacity': opacity,
        'name': name,
      };

  factory SketchLayer.fromJson(Map<String, dynamic> json) => SketchLayer(
        id: json['id'] as String,
        strokes: (json['strokes'] as List)
            .map((s) => Stroke.fromJson(s as Map<String, dynamic>))
            .toList(),
        visible: json['visible'] as bool,
        opacity: json['opacity'] as double,
        name: json['name'] as String,
      );

  SketchLayer copyWith({
    String? id,
    List<Stroke>? strokes,
    bool? visible,
    double? opacity,
    String? name,
  }) =>
      SketchLayer(
        id: id ?? this.id,
        strokes: strokes ?? this.strokes,
        visible: visible ?? this.visible,
        opacity: opacity ?? this.opacity,
        name: name ?? this.name,
      );
}

enum DrawingTool {
  pencil,
  pen,
  marker,
  highlighter,
  eraser,
}

extension DrawingToolExtension on DrawingTool {
  String get displayName {
    switch (this) {
      case DrawingTool.pencil:
        return 'Pencil';
      case DrawingTool.pen:
        return 'Pen';
      case DrawingTool.marker:
        return 'Marker';
      case DrawingTool.highlighter:
        return 'Highlighter';
      case DrawingTool.eraser:
        return 'Eraser';
    }
  }

  IconData get icon {
    switch (this) {
      case DrawingTool.pencil:
        return Icons.edit;
      case DrawingTool.pen:
        return Icons.create;
      case DrawingTool.marker:
        return Icons.brush;
      case DrawingTool.highlighter:
        return Icons.highlight;
      case DrawingTool.eraser:
        return Icons.remove_circle_outline;
    }
  }

  double getWidth(double baseWidth, double pressure) {
    switch (this) {
      case DrawingTool.pencil:
        return baseWidth * (0.5 + pressure * 0.5);
      case DrawingTool.pen:
        return baseWidth;
      case DrawingTool.marker:
        return baseWidth * 2;
      case DrawingTool.highlighter:
        return baseWidth * 3;
      case DrawingTool.eraser:
        return baseWidth * 2;
    }
  }

  Color applyToolEffect(Color color, double pressure) {
    switch (this) {
      case DrawingTool.pencil:
        return color.withOpacity(0.3 + pressure * 0.7);
      case DrawingTool.pen:
        return color;
      case DrawingTool.marker:
        return color.withOpacity(0.7);
      case DrawingTool.highlighter:
        return color.withOpacity(0.3);
      case DrawingTool.eraser:
        return Colors.white;
    }
  }
}
