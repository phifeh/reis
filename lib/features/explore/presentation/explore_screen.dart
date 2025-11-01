import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/features/explore/presentation/explore_provider.dart';
import 'package:reis/features/explore/presentation/widgets/grouped_event_card.dart';
import 'package:reis/features/explore/services/export_service.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedEventsAsync = ref.watch(groupedEventsProvider);

    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: const Text('Explore'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showExportOptions(context, ref),
            tooltip: 'Export',
          ),
        ],
      ),
      body: groupedEventsAsync.when(
        data: (groupedEvents) {
          if (groupedEvents.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedEvents.length,
            itemBuilder: (context, index) {
              final group = groupedEvents[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GroupedEventCard(group: group),
              );
            },
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
                'Organizing memories...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RetroTheme.sageBrown,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: RetroTheme.dustyRose,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading grouped events',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 64,
            color: RetroTheme.sageBrown.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No grouped memories yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Spectral',
                  color: RetroTheme.sageBrown,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Create some memories and they\'ll be organized here by time and location',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RetroTheme.sageBrown.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: RetroTheme.softCream,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Export Format',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Spectral',
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Markdown'),
              subtitle: const Text('Great for notes apps and GitHub'),
              onTap: () {
                Navigator.pop(context);
                _exportAsMarkdown(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code_outlined),
              title: const Text('JSON'),
              subtitle: const Text('Technical export with all data'),
              onTap: () {
                Navigator.pop(context);
                _exportAsJson(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet_outlined),
              title: const Text('Plain Text'),
              subtitle: const Text('Simple text format'),
              onTap: () {
                Navigator.pop(context);
                _exportAsText(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: const Text('HTML'),
              subtitle: const Text('Rich formatting for web and email'),
              onTap: () {
                Navigator.pop(context);
                _exportAsHtml(context, ref);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAsMarkdown(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final result = await exportService.exportAsMarkdown();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exported as Markdown'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed'),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAsJson(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final result = await exportService.exportAsJson();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exported as JSON'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed'),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAsText(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final result = await exportService.exportAsText();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exported as Text'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed'),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAsHtml(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final result = await exportService.exportAsHtml();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exported as HTML'),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed'),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
