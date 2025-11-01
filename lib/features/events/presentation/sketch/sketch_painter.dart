import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'sketch_models.dart';

class SketchPainter extends CustomPainter {
  final List<SketchLayer> layers;
  final List<DrawingPoint>? currentStroke;
  final DrawingTool currentTool;
  final Color currentColor;
  final double currentWidth;

  SketchPainter({
    required this.layers,
    this.currentStroke,
    required this.currentTool,
    required this.currentColor,
    required this.currentWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all layers
    for (final layer in layers) {
      if (!layer.visible) continue;

      final layerPaint = Paint()..color = Colors.white.withOpacity(layer.opacity);

      for (final stroke in layer.strokes) {
        _drawStroke(canvas, stroke, layer.opacity);
      }
    }

    // Draw current stroke
    if (currentStroke != null && currentStroke!.isNotEmpty) {
      _drawCurrentStroke(canvas);
    }
  }

  void _drawStroke(Canvas canvas, Stroke stroke, double layerOpacity) {
    if (stroke.points.isEmpty) return;

    final options = StrokeOptions(
      size: stroke.width,
      thinning: stroke.tool == DrawingTool.pencil ? 0.6 : 0.1,
      smoothing: 0.3,
      streamline: 0.3,
      simulatePressure: false,
    );

    final points = stroke.points.map((p) {
      return Point(
        p.offset.dx,
        p.offset.dy,
        p.pressure,
      );
    }).toList();

    final outlinePoints = getStroke(points, options: options);

    final path = Path();
    if (outlinePoints.isEmpty) return;

    path.moveTo(outlinePoints.first.dx, outlinePoints.first.dy);
    for (int i = 1; i < outlinePoints.length; i++) {
      path.lineTo(outlinePoints[i].dx, outlinePoints[i].dy);
    }
    path.close();

    final paint = Paint()
      ..color = stroke.tool
          .applyToolEffect(stroke.color, 1.0)
          .withOpacity(stroke.color.opacity * layerOpacity)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (stroke.tool == DrawingTool.eraser) {
      paint.blendMode = BlendMode.clear;
    }

    canvas.drawPath(path, paint);
  }

  void _drawCurrentStroke(Canvas canvas) {
    if (currentStroke == null || currentStroke!.isEmpty) return;

    final options = StrokeOptions(
      size: currentWidth,
      thinning: currentTool == DrawingTool.pencil ? 0.6 : 0.1,
      smoothing: 0.3,
      streamline: 0.3,
      simulatePressure: false,
    );

    final points = currentStroke!.map((p) {
      return Point(
        p.offset.dx,
        p.offset.dy,
        p.pressure,
      );
    }).toList();

    final outlinePoints = getStroke(points, options: options);

    if (outlinePoints.isEmpty) return;

    final path = Path();
    path.moveTo(outlinePoints.first.dx, outlinePoints.first.dy);
    for (int i = 1; i < outlinePoints.length; i++) {
      path.lineTo(outlinePoints[i].dx, outlinePoints[i].dy);
    }
    path.close();

    final paint = Paint()
      ..color = currentTool.applyToolEffect(currentColor, 1.0)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (currentTool == DrawingTool.eraser) {
      paint.blendMode = BlendMode.clear;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    return oldDelegate.layers != layers ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.currentTool != currentTool ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.currentWidth != currentWidth;
  }
}
