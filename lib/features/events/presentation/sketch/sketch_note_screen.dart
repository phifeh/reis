import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/models/capture_event.dart';
import 'package:reis/core/models/location.dart' as app;
import 'package:reis/core/providers/providers.dart';
import 'package:reis/core/utils/permissions_helper.dart';
import '../events_provider.dart';
import 'sketch_models.dart';
import 'sketch_painter.dart';

class SketchNoteScreen extends ConsumerStatefulWidget {
  const SketchNoteScreen({super.key});

  @override
  ConsumerState<SketchNoteScreen> createState() => _SketchNoteScreenState();
}

class _SketchNoteScreenState extends ConsumerState<SketchNoteScreen> {
  final List<SketchLayer> _layers = [SketchLayer(name: 'Layer 1')];
  int _currentLayerIndex = 0;
  List<DrawingPoint>? _currentStroke;

  DrawingTool _currentTool = DrawingTool.pen;
  Color _currentColor = Colors.black;
  double _currentWidth = 3.0;

  final List<List<SketchLayer>> _history = [];
  int _historyIndex = -1;

  bool _showLayers = false;
  bool _isSaving = false;

  final List<Color> _presetColors = [
    Colors.black,
    Colors.white,
    const Color(0xFFE07A5F), // Vintage orange
    const Color(0xFF3D405B), // Deep taupe
    const Color(0xFF81B29A), // Muted teal
    const Color(0xFFF2CC8F), // Pale olive
    const Color(0xFFE29578), // Dusty rose
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    _saveHistory();
  }

  void _saveHistory() {
    // Remove any history after current index
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // Add current state
    _history.add(_layers.map((l) {
      return SketchLayer(
        id: l.id,
        strokes: List.from(l.strokes),
        visible: l.visible,
        opacity: l.opacity,
        name: l.name,
      );
    }).toList());

    _historyIndex++;

    // Limit history to 50 states
    if (_history.length > 50) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _layers.clear();
        _layers.addAll(_history[_historyIndex].map((l) => SketchLayer(
              id: l.id,
              strokes: List.from(l.strokes),
              visible: l.visible,
              opacity: l.opacity,
              name: l.name,
            )));
      });
    }
  }

  void _redo() {
    if (_historyIndex < _history.length - 1) {
      setState(() {
        _historyIndex++;
        _layers.clear();
        _layers.addAll(_history[_historyIndex].map((l) => SketchLayer(
              id: l.id,
              strokes: List.from(l.strokes),
              visible: l.visible,
              opacity: l.opacity,
              name: l.name,
            )));
      });
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _currentStroke = [
        DrawingPoint(
          offset: event.localPosition,
          pressure: event.pressure.clamp(0.0, 1.0),
          timestamp: DateTime.now(),
        ),
      ];
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_currentStroke != null) {
      setState(() {
        _currentStroke!.add(
          DrawingPoint(
            offset: event.localPosition,
            pressure: event.pressure.clamp(0.0, 1.0),
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_currentStroke != null && _currentStroke!.isNotEmpty) {
      setState(() {
        _layers[_currentLayerIndex].strokes.add(
          Stroke(
            points: _currentStroke!,
            color: _currentColor,
            width: _currentWidth,
            tool: _currentTool,
          ),
        );
        _currentStroke = null;
        
        // Add to history
        _history.add(List.from(_layers.map((l) => SketchLayer(
          strokes: List.from(l.strokes),
          visible: l.visible,
          opacity: l.opacity,
          name: l.name,
        ))));
        _historyIndex = _history.length - 1;
        if (_history.length > 50) {
          _history.removeAt(0);
          _historyIndex--;
        }
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [
        DrawingPoint(
          offset: details.localPosition,
          pressure: 0.5, // Default pressure for touch
          timestamp: DateTime.now(),
        ),
      ];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_currentStroke != null) {
      setState(() {
        _currentStroke!.add(
          DrawingPoint(
            offset: details.localPosition,
            pressure: 0.5, // Default pressure for touch
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke != null && _currentStroke!.isNotEmpty) {
      setState(() {
        _layers[_currentLayerIndex].strokes.add(
              Stroke(
                points: _currentStroke!,
                color: _currentColor,
                width: _currentWidth,
                tool: _currentTool,
              ),
            );
        _currentStroke = null;
      });
      _saveHistory();
    }
  }

  Future<void> _saveSketch() async {
    setState(() => _isSaving = true);

    try {
      // Create a recorder to render the sketch
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = MediaQuery.of(context).size;

      // Draw white background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white,
      );

      // Draw all layers
      final painter = SketchPainter(
        layers: _layers,
        currentTool: _currentTool,
        currentColor: _currentColor,
        currentWidth: _currentWidth,
      );
      painter.paint(canvas, size);

      // Convert to image
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final filePath = '${directory.path}/media/sketches/sketch_$timestamp.png';
      final file = File(filePath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(buffer);

      // Get location
      final location = await PermissionsHelper.getCurrentLocation();

      // Create event
      final event = CaptureEvent(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        location: location != null
            ? app.Location(
                latitude: location.latitude,
                longitude: location.longitude,
                altitude: location.altitude,
                accuracy: location.accuracy,
                timestamp: DateTime.now(),
              )
            : null,
        data: {
          'filePath': filePath,
          'layerCount': _layers.length,
          'strokeCount': _layers.fold(0, (sum, layer) => sum + layer.strokes.length),
        },
        type: CaptureType.sketch,
      );

      // Save to repository
      final repository = ref.read(captureEventRepositoryProvider);
      await repository.save(event);

      // Refresh events list
      await ref.read(eventsProvider.notifier).refresh();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sketch saved!'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving sketch: $e'),
            backgroundColor: RetroTheme.dustyRose,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _addLayer() {
    setState(() {
      _layers.add(SketchLayer(name: 'Layer ${_layers.length + 1}'));
      _currentLayerIndex = _layers.length - 1;
    });
    _saveHistory();
  }

  void _removeLayer(int index) {
    if (_layers.length > 1) {
      setState(() {
        _layers.removeAt(index);
        if (_currentLayerIndex >= _layers.length) {
          _currentLayerIndex = _layers.length - 1;
        }
      });
      _saveHistory();
    }
  }

  void _toggleLayerVisibility(int index) {
    setState(() {
      _layers[index].visible = !_layers[index].visible;
    });
  }

  void _moveLayerUp(int index) {
    if (index < _layers.length - 1) {
      setState(() {
        final layer = _layers.removeAt(index);
        _layers.insert(index + 1, layer);
        if (_currentLayerIndex == index) {
          _currentLayerIndex = index + 1;
        } else if (_currentLayerIndex == index + 1) {
          _currentLayerIndex = index;
        }
      });
      _saveHistory();
    }
  }

  void _moveLayerDown(int index) {
    if (index > 0) {
      setState(() {
        final layer = _layers.removeAt(index);
        _layers.insert(index - 1, layer);
        if (_currentLayerIndex == index) {
          _currentLayerIndex = index - 1;
        } else if (_currentLayerIndex == index - 1) {
          _currentLayerIndex = index;
        }
      });
      _saveHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.warmBeige,
      appBar: AppBar(
        title: const Text('Sketch Note'),
        backgroundColor: RetroTheme.warmBeige,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _historyIndex > 0 ? _undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _historyIndex < _history.length - 1 ? _redo : null,
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: () => setState(() => _showLayers = !_showLayers),
            color: _showLayers ? RetroTheme.vintageOrange : null,
          ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveSketch,
            ),
        ],
      ),
      body: Stack(
        children: [
          // Drawing canvas
          Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: Container(
              color: Colors.white,
              child: CustomPaint(
                painter: SketchPainter(
                  layers: _layers,
                  currentStroke: _currentStroke,
                  currentTool: _currentTool,
                  currentColor: _currentColor,
                  currentWidth: _currentWidth,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          // Layer panel
          if (_showLayers)
            Positioned(
              right: 0,
              top: 0,
              bottom: 80,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: RetroTheme.softCream,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'LAYERS',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: RetroTheme.deepTaupe,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _layers.length,
                        reverse: true,
                        itemBuilder: (context, reverseIndex) {
                          final index = _layers.length - 1 - reverseIndex;
                          final layer = _layers[index];
                          final isActive = index == _currentLayerIndex;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? RetroTheme.vintageOrange.withOpacity(0.2)
                                  : RetroTheme.warmBeige,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isActive
                                    ? RetroTheme.vintageOrange
                                    : RetroTheme.paleOlive,
                              ),
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                layer.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              leading: IconButton(
                                icon: Icon(
                                  layer.visible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 16,
                                ),
                                onPressed: () => _toggleLayerVisibility(index),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_upward, size: 14),
                                    onPressed: () => _moveLayerUp(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_downward, size: 14),
                                    onPressed: () => _moveLayerDown(index),
                                  ),
                                  if (_layers.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 14),
                                      onPressed: () => _removeLayer(index),
                                    ),
                                ],
                              ),
                              onTap: () => setState(() => _currentLayerIndex = index),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: _addLayer,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Layer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RetroTheme.vintageOrange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom toolbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: RetroTheme.softCream,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tools
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: DrawingTool.values.map((tool) {
                        final isActive = tool == _currentTool;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Material(
                            color: isActive
                                ? RetroTheme.vintageOrange
                                : RetroTheme.warmBeige,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () => setState(() => _currentTool = tool),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 50,
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  tool.icon,
                                  color: isActive ? Colors.white : RetroTheme.deepTaupe,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Width slider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.line_weight, size: 16),
                        Expanded(
                          child: Slider(
                            value: _currentWidth,
                            min: 1,
                            max: 20,
                            divisions: 19,
                            label: '${_currentWidth.toInt()}px',
                            activeColor: RetroTheme.vintageOrange,
                            onChanged: (value) =>
                                setState(() => _currentWidth = value),
                          ),
                        ),
                        Text(
                          '${_currentWidth.toInt()}px',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Colors
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: _presetColors.map((color) {
                        final isActive = color == _currentColor;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () => setState(() => _currentColor = color),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isActive
                                      ? RetroTheme.vintageOrange
                                      : Colors.grey,
                                  width: isActive ? 3 : 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
