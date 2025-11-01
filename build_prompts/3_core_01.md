# Day 1: Core Capture Implementation

## Goal
Working photo capture with GPS that persists locally.
Test: Take 10 photos, force-quit app, photos still there.

## Implementation Order
1. Models (30 min)
2. Database setup (1 hour)
3. Photo capture (2 hours)
4. Basic UI (1 hour)
5. Testing on device (rest of day)

## Specific Requirements

### Models (freezed)
```dart
// Keep it simple for day 1
@freezed
class CaptureEvent with _$CaptureEvent {
  factory CaptureEvent({
    required String id,
    required DateTime timestamp,
    required CaptureType type,
    @JsonKey(name: 'location') LocationData? location,
    required Map<String, dynamic> data,
  }) = _CaptureEvent;

  factory CaptureEvent.photo({
    required String id,
    required DateTime timestamp,
    LocationData? location,
    required String filePath,
    String? note,
  }) => CaptureEvent(
    id: id,
    timestamp: timestamp,
    type: CaptureType.photo,
    location: location,
    data: {'filePath': filePath, 'note': note},
  );
}
```

### Critical Error Scenarios
Handle these explicitly:
1. No GPS permission → Continue without location
2. Storage full → Show clear error
3. Camera in use → Retry mechanism
4. Database locked → Queue operations

### Testing Checklist
- [ ] Works in airplane mode
- [ ] Survives force quit
- [ ] Handles rapid captures (5 photos in 10 seconds)
- [ ] GPS timeout doesn't block capture
- [ ] Photos actually saved to disk

Generate runnable code, not pseudocode.
