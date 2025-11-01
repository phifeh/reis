import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/l10n/app_localizations.dart';
import 'package:reis/core/services/backup_service.dart';
import 'package:reis/features/events/presentation/capture_home_screen.dart';
import 'package:reis/features/events/presentation/events_provider.dart';
import 'package:reis/features/events/presentation/widgets/event_list_item.dart';
import 'package:reis/features/settings/presentation/settings_screen.dart';

class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.backup_outlined),
            onPressed: () => _handleBackup(context),
            tooltip: l10n.backupData,
          ),
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
              // Swipe hint at top
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: RetroTheme.sageBrown.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe left to delete',
                        style: TextStyle(
                          fontSize: 12,
                          color: RetroTheme.sageBrown.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 100,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Dismissible(
                        key: Key(events[index].id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            color: RetroTheme.dustyRose,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          final l10n = AppLocalizations.of(context);
                          return await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: RetroTheme.softCream,
                                title: Text(
                                  l10n.deleteEvent,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontFamily: 'Spectral',
                                  ),
                                ),
                                content: Text(
                                  l10n.deleteConfirmation,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text(l10n.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: RetroTheme.dustyRose,
                                    ),
                                    child: Text(l10n.delete),
                                  ),
                                ],
                              );
                            },
                          ) ?? false;
                        },
                        onDismissed: (direction) async {
                          final l10n = AppLocalizations.of(context);
                          await ref.read(eventsProvider.notifier).deleteEvent(events[index].id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.eventDeleted),
                                backgroundColor: RetroTheme.deepTaupe,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: EventListItem(
                          event: events[index],
                          previousEvent: index < events.length - 1 ? events[index + 1] : null,
                        ),
                      ),
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
                AppLocalizations.of(context).loading,
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
        backgroundColor: RetroTheme.vintageOrange,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
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
              l10n.noEvents,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.startCapturing,
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

  Future<void> _handleBackup(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(l10n.creatingBackup),
          ],
        ),
      ),
    );

    try {
      await BackupService.shareBackup();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.backupFailed}: $e'),
            backgroundColor: RetroTheme.dustyRose,
          ),
        );
      }
    }
  }
}
