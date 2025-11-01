import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/features/events/presentation/capture_home_screen.dart';
import 'package:reis/features/events/presentation/events_provider.dart';
import 'package:reis/features/events/presentation/widgets/event_list_item.dart';
import 'package:reis/features/settings/presentation/settings_screen.dart';

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: const Text('reis'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.read(eventsProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return _buildEmptyState(context);
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 100,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EventListItem(event: events[index]),
                    ),
                    childCount: events.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: RetroTheme.vintageOrange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Loading memories...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RetroTheme.sageBrown,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
        error: (error, stack) => _buildErrorState(context, error, ref),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CaptureHomeScreen()),
          );
          ref.read(eventsProvider.notifier).refresh();
        },
        child: const Icon(Icons.camera_alt, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 80,
              color: RetroTheme.paleOlive,
            ),
            const SizedBox(height: 32),
            Text(
              'Your Journey Awaits',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Capture your first memory\nby pressing the camera button below',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: RetroTheme.sageBrown,
                    height: 1.8,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: RetroTheme.warmBeige,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: RetroTheme.paleOlive.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                    color: RetroTheme.vintageOrange,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to Begin',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: RetroTheme.deepTaupe,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: RetroTheme.dustyRose,
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to load',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(eventsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
