import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/features/events/presentation/camera_screen.dart';
import 'package:reis/features/events/presentation/video_screen.dart';
import 'package:reis/features/events/presentation/audio_record_screen.dart';
import 'package:reis/features/events/presentation/text_note_screen.dart';
import 'package:reis/features/events/presentation/rating_screen.dart';
import 'package:reis/features/events/presentation/sketch/sketch_note_screen.dart';

class CaptureHomeScreen extends ConsumerStatefulWidget {
  const CaptureHomeScreen({super.key});

  @override
  ConsumerState<CaptureHomeScreen> createState() => _CaptureHomeScreenState();
}

class _CaptureHomeScreenState extends ConsumerState<CaptureHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: const Text('Capture Memory'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: RetroTheme.vintageOrange,
          unselectedLabelColor: RetroTheme.sageBrown,
          indicatorColor: RetroTheme.vintageOrange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontFamily: RetroTheme.serifFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.camera_alt_outlined),
              text: 'PHOTO',
            ),
            Tab(
              icon: Icon(Icons.videocam_outlined),
              text: 'VIDEO',
            ),
            Tab(
              icon: Icon(Icons.mic_outlined),
              text: 'AUDIO',
            ),
            Tab(
              icon: Icon(Icons.draw_outlined),
              text: 'SKETCH',
            ),
            Tab(
              icon: Icon(Icons.edit_note_outlined),
              text: 'NOTE',
            ),
            Tab(
              icon: Icon(Icons.star_outline),
              text: 'RATING',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CameraScreen(),
          VideoScreen(),
          AudioRecordScreen(),
          SketchNoteScreen(),
          TextNoteScreen(),
          RatingScreen(),
        ],
      ),
    );
  }
}
