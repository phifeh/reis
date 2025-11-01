# Travel Journal Flutter App - Core Architecture

## Context
Building a location-based travel journal app with 5-day deadline for MVP.
Must work 100% offline on Android. iOS is future scope.

## Key Uncertainties to Handle
1. Moment boundaries (automatic vs manual grouping)
2. Capture modes (photo/audio/text/import)
3. Location clustering logic
4. Export formats

## Core Requirements
- Capture photos/audio/text/ratings with GPS metadata
- Flexible moment grouping (auto-detect + manual override)
- Background GPS tracking (every 5 min for battery efficiency)
- Export to Obsidian-compatible markdown
- Completely offline, no backend

## Task
Create a flexible architecture with:
1. Event-based capture system (events can be regrouped into moments later)
2. Pluggable capture modes
3. Configurable moment detection strategies
4. Clean separation between data capture and organization

## Architecture Constraints
- Use Repository pattern for data persistence
- Events are immutable once captured
- Moments are mutable containers of events
- All business logic testable without UI
- Maximum 150 lines per file

## Data Model Structure
```dart
// Core immutable event
class CaptureEvent {
  final String id;
  final DateTime timestamp;
  final Location? location;
  final Map<String, dynamic> data; // Flexible for different capture types
  final CaptureType type;
}

// Flexible moment grouping
class Moment {
  String id;
  String? name;
  List<String> eventIds;
  MomentType type; // auto/manual/journey
  DateTime startTime;
  DateTime? endTime;
}

// Configuration
class GroupingStrategy {
  Duration timeThreshold;
  double distanceThreshold;
  // ... extensible
}
```

## Expected Output
Create these files:
1. `/lib/core/models/` - Data models with freezed
2. `/lib/core/services/capture_service.dart` - Event capture pipeline
3. `/lib/core/services/moment_service.dart` - Moment detection/management
4. `/lib/core/repositories/` - Data persistence layer

Focus on extensibility over features. Must be easy to add new capture modes.
