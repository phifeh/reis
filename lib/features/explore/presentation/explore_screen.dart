import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/l10n/app_localizations.dart';
import 'package:reis/features/explore/presentation/explore_provider.dart';
import 'package:reis/features/explore/presentation/widgets/grouped_event_card.dart';
import 'package:reis/features/explore/services/export_service.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedEventsAsync = ref.watch(groupedEventsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: Text(l10n.explore),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showExportOptions(context, ref),
            tooltip: l10n.export,
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
                l10n.organizingMemories,
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
                l10n.errorLoading,
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
    final l10n = AppLocalizations.of(context);
    
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
            l10n.noGroupedMemories,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Spectral',
                  color: RetroTheme.sageBrown,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l10n.createMemoriesHint,
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
    final l10n = AppLocalizations.of(context);
    
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
                l10n.exportFormat,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Spectral',
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(l10n.markdown),
              subtitle: Text(l10n.markdownDesc),
              onTap: () {
                Navigator.pop(context);
                _exportAsMarkdown(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code_outlined),
              title: Text(l10n.json),
              subtitle: Text(l10n.jsonDesc),
              onTap: () {
                Navigator.pop(context);
                _exportAsJson(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet_outlined),
              title: Text(l10n.plainText),
              subtitle: Text(l10n.plainTextDesc),
              onTap: () {
                Navigator.pop(context);
                _exportAsText(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: Text(l10n.html),
              subtitle: Text(l10n.htmlDesc),
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
    final l10n = AppLocalizations.of(context);
    final result = await exportService.exportAsMarkdown();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportedAsMarkdown),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAsJson(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final l10n = AppLocalizations.of(context);
    final result = await exportService.exportAsJson();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportedAsJson),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAsText(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final l10n = AppLocalizations.of(context);
    final result = await exportService.exportAsText();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportedAsText),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportAsHtml(BuildContext context, WidgetRef ref) async {
    final exportService = ref.read(exportServiceProvider);
    final l10n = AppLocalizations.of(context);
    final result = await exportService.exportAsHtml();
    
    if (context.mounted) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportedAsHtml),
            backgroundColor: RetroTheme.mutedTeal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailed),
            backgroundColor: RetroTheme.dustyRose,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
