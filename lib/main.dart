import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/features/events/presentation/events_list_screen.dart';
import 'package:reis/platform/quick_capture_channel.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    QuickCaptureChannel.setupHandler(ref);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'reis',
      debugShowCheckedModeBanner: false,
      theme: RetroTheme.theme,
      home: const EventsListScreen(),
    );
  }
}
