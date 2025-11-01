import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('nl'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'reis',
      'timeline': 'Timeline',
      'explore': 'Explore',
      'capture_memory': 'Capture Memory',
      'export': 'Export',
      'organizing_memories': 'Organizing memories...',
      'error_loading': 'Error loading grouped events',
      'no_grouped_memories': 'No grouped memories yet',
      'create_memories_hint':
          'Create some memories and they\'ll be organized here by time and location',
      'export_format': 'Export Format',
      'markdown': 'Markdown',
      'markdown_desc': 'Great for notes apps and GitHub',
      'json': 'JSON',
      'json_desc': 'Technical export with all data',
      'plain_text': 'Plain Text',
      'plain_text_desc': 'Simple text format',
      'html': 'HTML',
      'html_desc': 'Rich formatting for web and email',
      'exported_as_markdown': 'Exported as Markdown',
      'exported_as_json': 'Exported as JSON',
      'exported_as_text': 'Exported as Text',
      'exported_as_html': 'Exported as HTML',
      'export_failed': 'Export failed',
      'no_events': 'No events yet',
      'start_capturing': 'Start capturing your memories!',
      'loading': 'Loading...',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'delete_event': 'Delete Event',
      'delete_confirmation': 'Are you sure you want to delete this event?',
      'event_deleted': 'Event deleted',
      'backup_data': 'Backup Data',
      'backup_created': 'Backup created successfully',
      'backup_failed': 'Backup failed',
      'creating_backup': 'Creating backup...',
      'share': 'Share',
      'location': 'Location',
      'unknown_location': 'Unknown location',
      'photo': 'Photo',
      'video': 'Video',
      'audio': 'Audio',
      'sketch': 'Sketch',
      'note': 'Note',
      'rating': 'Rating',
      'take_photo': 'Take Photo',
      'record_video': 'Record Video',
      'record_audio': 'Record Audio',
      'draw_sketch': 'Draw Sketch',
      'write_note': 'Write Note',
      'add_rating': 'Add Rating',
      'save': 'Save',
      'discard': 'Discard',
      'edit': 'Edit',
      'add_text': 'Add text...',
      'distance': 'Distance',
      'time_elapsed': 'Time elapsed',
      'collapse': 'Collapse',
      'expand': 'Expand',
    },
    'nl': {
      'app_title': 'reis',
      'timeline': 'Tijdlijn',
      'explore': 'Ontdek',
      'capture_memory': 'Leg Herinnering Vast',
      'export': 'Exporteer',
      'organizing_memories': 'Herinneringen organiseren...',
      'error_loading': 'Fout bij laden gegroepeerde gebeurtenissen',
      'no_grouped_memories': 'Nog geen gegroepeerde herinneringen',
      'create_memories_hint':
          'Maak wat herinneringen en ze worden hier georganiseerd op tijd en locatie',
      'export_format': 'Exporteer Formaat',
      'markdown': 'Markdown',
      'markdown_desc': 'Geweldig voor notitie apps en GitHub',
      'json': 'JSON',
      'json_desc': 'Technische export met alle data',
      'plain_text': 'Platte Tekst',
      'plain_text_desc': 'Eenvoudig tekstformaat',
      'html': 'HTML',
      'html_desc': 'Rijke opmaak voor web en e-mail',
      'exported_as_markdown': 'Geëxporteerd als Markdown',
      'exported_as_json': 'Geëxporteerd als JSON',
      'exported_as_text': 'Geëxporteerd als Tekst',
      'exported_as_html': 'Geëxporteerd als HTML',
      'export_failed': 'Exporteren mislukt',
      'no_events': 'Nog geen gebeurtenissen',
      'start_capturing': 'Begin met het vastleggen van je herinneringen!',
      'loading': 'Laden...',
      'delete': 'Verwijder',
      'cancel': 'Annuleer',
      'delete_event': 'Verwijder Gebeurtenis',
      'delete_confirmation':
          'Weet je zeker dat je deze gebeurtenis wilt verwijderen?',
      'event_deleted': 'Gebeurtenis verwijderd',
      'backup_data': 'Backup Data',
      'backup_created': 'Backup succesvol gemaakt',
      'backup_failed': 'Backup mislukt',
      'creating_backup': 'Backup maken...',
      'share': 'Delen',
      'location': 'Locatie',
      'unknown_location': 'Onbekende locatie',
      'photo': 'Foto',
      'video': 'Video',
      'audio': 'Audio',
      'sketch': 'Schets',
      'note': 'Notitie',
      'rating': 'Beoordeling',
      'take_photo': 'Maak Foto',
      'record_video': 'Neem Video Op',
      'record_audio': 'Neem Audio Op',
      'draw_sketch': 'Teken Schets',
      'write_note': 'Schrijf Notitie',
      'add_rating': 'Voeg Beoordeling Toe',
      'save': 'Opslaan',
      'discard': 'Weggooien',
      'edit': 'Bewerk',
      'add_text': 'Voeg tekst toe...',
      'distance': 'Afstand',
      'time_elapsed': 'Verstreken tijd',
      'collapse': 'Inklappen',
      'expand': 'Uitklappen',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get timeline => translate('timeline');
  String get explore => translate('explore');
  String get captureMemory => translate('capture_memory');
  String get export => translate('export');
  String get organizingMemories => translate('organizing_memories');
  String get errorLoading => translate('error_loading');
  String get noGroupedMemories => translate('no_grouped_memories');
  String get createMemoriesHint => translate('create_memories_hint');
  String get exportFormat => translate('export_format');
  String get markdown => translate('markdown');
  String get markdownDesc => translate('markdown_desc');
  String get json => translate('json');
  String get jsonDesc => translate('json_desc');
  String get plainText => translate('plain_text');
  String get plainTextDesc => translate('plain_text_desc');
  String get html => translate('html');
  String get htmlDesc => translate('html_desc');
  String get exportedAsMarkdown => translate('exported_as_markdown');
  String get exportedAsJson => translate('exported_as_json');
  String get exportedAsText => translate('exported_as_text');
  String get exportedAsHtml => translate('exported_as_html');
  String get exportFailed => translate('export_failed');
  String get noEvents => translate('no_events');
  String get startCapturing => translate('start_capturing');
  String get loading => translate('loading');
  String get delete => translate('delete');
  String get cancel => translate('cancel');
  String get deleteEvent => translate('delete_event');
  String get deleteConfirmation => translate('delete_confirmation');
  String get eventDeleted => translate('event_deleted');
  String get backupData => translate('backup_data');
  String get backupCreated => translate('backup_created');
  String get backupFailed => translate('backup_failed');
  String get creatingBackup => translate('creating_backup');
  String get share => translate('share');
  String get location => translate('location');
  String get unknownLocation => translate('unknown_location');
  String get photo => translate('photo');
  String get video => translate('video');
  String get audio => translate('audio');
  String get sketch => translate('sketch');
  String get note => translate('note');
  String get rating => translate('rating');
  String get takePhoto => translate('take_photo');
  String get recordVideo => translate('record_video');
  String get recordAudio => translate('record_audio');
  String get drawSketch => translate('draw_sketch');
  String get writeNote => translate('write_note');
  String get addRating => translate('add_rating');
  String get save => translate('save');
  String get discard => translate('discard');
  String get edit => translate('edit');
  String get addText => translate('add_text');
  String get distance => translate('distance');
  String get timeElapsed => translate('time_elapsed');
  String get collapse => translate('collapse');
  String get expand => translate('expand');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'nl'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
