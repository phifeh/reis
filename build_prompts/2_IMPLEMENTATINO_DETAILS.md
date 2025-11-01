# Implementation Specifications

## Tech Stack
```yaml
dependencies:
  flutter: ">=3.0.0"
  # Storage
  sqflite: ^2.3.0
  path_provider: ^2.1.1

  # State & Architecture
  freezed: ^2.4.5
  riverpod: ^2.4.0

  # Capture Features
  camera: ^0.10.5
  geolocator: ^10.1.0
  record: ^5.0.0

  # Utilities
  uuid: ^4.1.0
  intl: ^0.18.1
```

## Storage Structure
```
/app_documents/
  /database/
    travel_journal.db
  /media/
    /photos/
      2025-10-31_19-45-30_[uuid].jpg
    /audio/
      2025-10-31_19-45-30_[uuid].m4a
  /exports/
    /trip_name/
      export_2025-10-31.md
```

## Database Schema
```sql
-- Events table (immutable)
CREATE TABLE events (
  id TEXT PRIMARY KEY,
  timestamp INTEGER NOT NULL,
  type TEXT NOT NULL,
  latitude REAL,
  longitude REAL,
  accuracy REAL,
  data TEXT NOT NULL, -- JSON
  created_at INTEGER NOT NULL
);

-- Moments table (mutable)
CREATE TABLE moments (
  id TEXT PRIMARY KEY,
  name TEXT,
  type TEXT DEFAULT 'auto',
  start_time INTEGER NOT NULL,
  end_time INTEGER,
  updated_at INTEGER NOT NULL
);

-- Event-Moment junction
CREATE TABLE moment_events (
  moment_id TEXT,
  event_id TEXT,
  PRIMARY KEY (moment_id, event_id)
);
```

## Error Handling Pattern
```dart
// Use Result type for all operations
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
```

## Capture Pipeline Flow
1. User initiates capture (photo/audio/text)
2. Get current GPS location (timeout: 10s)
3. Create CaptureEvent with metadata
4. Store media file to disk
5. Save event to SQLite
6. Trigger moment detection algorithm
7. Return Result<CaptureEvent>

## Moment Detection Algorithm
```
IF (no active moment) THEN
  Create new moment
ELSE IF (distance > threshold OR time_gap > threshold) THEN
  Create new moment
ELSE
  Add to current moment
END
```

## First Sprint (Day 1-2)
Build ONLY:
1. CaptureEvent model with freezed
2. SQLite repository setup
3. Photo capture service
4. Basic moment detection
5. Simple list view of events

Generate complete, runnable code. Include all imports.
