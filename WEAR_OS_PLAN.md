# Wear OS Voice Memo Implementation - Phase 2

## Goal
Enable quick voice memos from smartwatch without phone interaction

## Architecture

### Two-App Approach:
1. **Main Phone App** (existing) - Full features
2. **Wear Companion App** (new) - Voice memos only

### Data Flow:
```
Watch: Record → Save locally → Queue for sync
  ↓ (Bluetooth when connected)
Phone: Receive → Add GPS → Save DB → Notify
```

## Implementation Plan

### Step 1: Wear OS App Setup (Day 1)
- Create separate `wear_app/` directory
- Configure Wear OS manifest
- Add `wear` package dependency
- Setup Wear OS emulator/physical device
- Basic "Hello Wear" POC

### Step 2: Voice Recording on Watch (Day 2)
- Reuse `AudioCaptureService` from main app
- Create minimal watch UI (single button)
- Implement local SQLite storage on watch
- Test recording + local save

### Step 3: Phone-Watch Sync (Day 3-4)
- Implement Wear Data Layer API
- Create platform channels for sync
- Queue-based transfer system
- Handle disconnections gracefully
- Resume interrupted transfers

### Step 4: Phone Integration (Day 5)
- Receive audio from watch
- Add GPS location from phone
- Save to main app database
- Show notification
- Delete from watch after sync

### Step 5: Testing & Polish (Day 6-7)
- Test sync reliability
- Battery optimization
- Error handling
- User feedback
- Documentation

## Files to Create

### Wear App:
```
wear_app/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── recording_screen.dart
│   ├── services/
│   │   ├── audio_recorder.dart (shared)
│   │   └── local_storage.dart
│   └── models/
│       └── pending_sync.dart
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml
│       └── res/
└── pubspec.yaml
```

### Phone Integration:
```
lib/platform/
├── wear_data_layer.dart
├── wear_sync_service.dart
└── wear_message_handler.dart
```

## Next Steps

Starting implementation now...
