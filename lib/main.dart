import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/l10n/app_localizations.dart';
import 'package:reis/features/events/presentation/events_list_screen.dart';
import 'package:reis/features/explore/presentation/explore_screen.dart';
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const EventsListScreen(),
    const ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: RetroTheme.warmBeige,
        selectedItemColor: RetroTheme.vintageOrange,
        unselectedItemColor: RetroTheme.sageBrown.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_outlined),
            activeIcon: const Icon(Icons.list),
            label: l10n.timeline,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore),
            label: l10n.explore,
          ),
        ],
      ),
    );
  }
}
