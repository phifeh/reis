# REIS Enhancement Roadmap

## Overview
**Total Timeline**: 24-35 days
**Phases**: 6 phases covering all requested features
**Current Status**: MVP complete, 46/46 tests passing

---

## Phase 1: Quick Capture Improvements (3-5 days)
**Goal**: Minimize phone interaction for captures

### 1.1 Android Quick Tile (2 days)
**What**: Swipe down notification shade → tap tile → instant photo
**Priority**: 🔥 HIGH - Most impactful for low-phone usage

**Tech Stack**:
- Android TileService API
- Flutter platform channels (MethodChannel)
- Background camera initialization

**Implementation**:
```
android/app/src/main/kotlin/
  └── QuickCaptureTileService.kt
lib/platform/
  └── quick_capture_channel.dart
```

**Steps**:
1. Create TileService in native Android (Kotlin)
2. Add platform channel for Flutter-Android communication
3. Handle camera initialization from background
4. Store photo with GPS, trigger notification on success
5. Update tile icon to show success/failure

**Complexity**: Medium (native Android + platform channels)
**Testing**: Unit tests + manual device testing

---

### 1.2 Photo Burst Mode (1 day)
**What**: Hold capture button → takes 3-5 photos rapidly
**Priority**: ⚡ MEDIUM - Easy win for multiple shots

**Tech Stack**:
- Existing camera package
- GestureDetector with onLongPress
- Timer-based rapid capture

**Implementation**:
- Modify `lib/features/events/presentation/camera_screen.dart`
- Add long-press handler to capture button
- Loop capture with 500ms intervals
- Store all photos as separate events
- Show progress indicator during burst

**Complexity**: Low (pure Flutter)
**Testing**: Widget tests for gesture handling

---

## Phase 2: Smartwatch Integration (5-7 days)
**Goal**: Voice memos from watch without phone interaction
**Priority**: 🎯 HIGH - Unique value proposition

### 2.1 Research & Setup (1 day)
**Wear OS Feasibility Analysis**:
- ✅ **Flutter Wear Support**: `wear` package available
- ✅ **Audio Recording**: `record` package compatible
- ✅ **Data Sync**: Platform channels + Bluetooth
- ⚠️ **Device Required**: Wear OS emulator or physical device

**Setup Tasks**:
1. Install Wear OS emulator/pair physical device
2. Add `wear` package dependency
3. Create separate Wear OS app target
4. Configure Wear-specific manifest

**Deliverable**: POC running on Wear OS device

---

### 2.2 Wear OS Companion App (3-4 days)
**Features**:
- Single screen with big "Record Memo" button
- Voice recording on watch
- Local storage on watch
- Auto-sync to phone when connected
- Battery-aware recording (max 5 min)

**Implementation**:
```
wear_app/
├── lib/
│   ├── main.dart                 # Minimal watch UI
│   ├── audio_recorder.dart       # Reuse from main app
│   └── widgets/
│       └── record_button.dart    # Large touch target
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml   # Wear-specific config
│       └── res/                  # Wear launcher icon
└── pubspec.yaml                  # Wear dependencies

lib/platform/
├── wear_sync_channel.dart        # Phone-side sync
└── wear_message_handler.dart     # Receive audio from watch
```

**User Flow**:
1. Open watch app
2. Tap record button (haptic feedback)
3. Speak memo (max 5 min, vibrate at 4:30)
4. Tap stop (auto-save locally)
5. Next time phone connects → auto-sync
6. Phone processes: GPS tag, DB insert, notification

**Complexity**: High (new app + platform channels + BT sync)
**Testing**: Both watch and phone unit/integration tests

---

### 2.3 Phone-Watch Sync Service (1-2 days)
**What**: Bidirectional data sync over Bluetooth

**Tech Stack**:
- Wear OS Data Layer API
- Platform channels (MethodChannel + EventChannel)
- SQLite on both devices

**Features**:
- Auto-detect watch connection
- Queue audio files for transfer
- Resume interrupted transfers
- Show sync status in phone settings
- Delete from watch after successful sync

**Implementation**:
```
lib/core/services/
├── wear_sync_service.dart        # Main sync logic
└── wear_connection_monitor.dart  # BT status

android/app/src/main/kotlin/
└── WearDataSyncService.kt        # Native data layer
```

**Complexity**: High (native Android + state management)
**Testing**: Mock Bluetooth for unit tests

---

## Phase 3: Maps & Visualization (4-6 days)
**Goal**: See your journey on offline maps
**Priority**: 🗺️ MEDIUM - Post-trip value

### 3.1 Offline Map Integration (3 days)
**What**: Download map tiles before trip, view journey offline

**Tech Stack**:
- `flutter_map` (v6.0+) - Open source map widget
- `flutter_map_tile_caching` - Offline tile storage
- OpenStreetMap tiles (free, no API key needed)
- `latlong2` - Coordinate calculations

**Implementation**:
```
lib/features/map/
├── presentation/
│   ├── journey_map_screen.dart   # Full-screen map
│   ├── map_download_screen.dart  # Pre-download UI
│   └── widgets/
│       ├── event_marker.dart     # Clustered markers
│       ├── moment_polyline.dart  # Connect events
│       └── download_progress.dart
├── services/
│   └── map_tile_service.dart     # Download/cache logic
└── models/
    └── map_bounds.dart           # City bounding boxes
```

**Features**:
- Pre-download tiles for Budapest (zoom 10-18)
- Show all events as color-coded markers (photo/audio/text/rating)
- Polyline connecting events chronologically
- Cluster markers by moments
- Tap marker to see event details
- Zoom controls + current location button

**Pre-configured Cities**:
- Budapest, Paris, Rome, Barcelona (others on request)

**Storage**: ~50-100MB per city (zoom 10-18)

**Complexity**: Medium (package integration + tile management)
**Testing**: Mock tile provider for unit tests

---

### 3.2 Timeline View (1-2 days)
**What**: Vertical timeline showing events/moments graphically

**Tech Stack**:
- `timeline_tile` package
- CustomPainter for connecting lines
- Pure Flutter widgets

**UI Design**:
```
┌─────────────────────────────┐
│ Nov 1, 2025                 │
│                             │
│ 09:00 📷 Photo              │
│   ●────┐                    │
│   │    └─ "Eiffel Tower"    │
│   │                         │
│ 10:30 🎤 Voice memo         │
│   ●────┐                    │
│   │    └─ 2:34 duration     │
│   ┃                         │
│   ├─── [Moment: Morning]    │
│   ┃                         │
│ 12:00 🚶 Journey            │
│   ●····· 2.3km traveled     │
│                             │
└─────────────────────────────┘
```

**Features**:
- Group by day
- Moment containers (expandable)
- Journey segments (dotted line)
- Tap to view details
- Smooth scroll to date

**Complexity**: Low (UI only)
**Testing**: Widget tests for timeline layout

---

### 3.3 Map-Timeline Integration (1 day)
**What**: Switch between map/timeline views with shared state

**Implementation**:
- Bottom navigation: Map | Timeline
- Shared event filter state
- Tap event on map → highlight on timeline
- Tap event on timeline → center on map

**Complexity**: Low (state management)

---

## Phase 4: Battery & Performance (2-3 days)
**Goal**: All-day tracking without killing battery
**Priority**: 🔋 HIGH - Critical for travel

### 4.1 Battery Monitoring (1 day)
**What**: Detect battery level and auto-adjust settings

**Tech Stack**:
- `battery_plus` package
- StreamProvider for reactive updates
- Settings persistence

**Implementation**:
```
lib/core/services/
├── battery_monitor_service.dart
│   ├── listenToBatteryLevel()
│   ├── getBatteryState() → charging/discharging
│   └── shouldEnablePowerSaving() → bool
└── power_profile_service.dart
    ├── applyPowerSavingMode()
    └── restoreNormalMode()
```

**Power Profiles**:
1. **Normal** (> 40%):
   - GPS: 5min intervals
   - Accuracy: high
   - Camera: pre-load preview
   
2. **Balanced** (20-40%):
   - GPS: 10min intervals
   - Accuracy: medium
   - Camera: on-demand loading
   
3. **Power Saving** (< 20%):
   - GPS: 15min intervals
   - Accuracy: low
   - Camera: basic mode only
   - Disable burst mode

**Complexity**: Low
**Testing**: Mock battery service

---

### 4.2 Adaptive Tracking (1-2 days)
**What**: Smart interval adjustment based on movement

**Logic**:
```dart
if (stationary < 50m in 10min) {
  pauseTracking(); // Save battery
} else if (moving > 200m in 5min) {
  setInterval(3.minutes); // Frequent updates
} else if (speed > 30km/h) {
  setInterval(2.minutes); // Vehicle mode
} else {
  setInterval(5.minutes); // Walking
}
```

**Implementation**:
- Analyze last N location points
- Calculate speed/distance
- Auto-adjust tracking interval
- Show mode in UI: 🚶 Walking | 🚗 Driving | 🏠 Stationary

**Complexity**: Medium (location analysis)
**Testing**: Unit tests with mock GPS tracks

---

## Phase 5: Export & Backup (3-4 days)
**Goal**: Get data out in usable formats
**Priority**: 📤 HIGH - Essential for Obsidian workflow

### 5.1 Obsidian Export (2-3 days)
**What**: Export to Markdown files with embedded media

**Format**:
```markdown
---
title: Eiffel Tower Visit
date: 2025-11-01
time: 09:30
location: [48.8584, 2.2945]
moment: Morning Tour
tags: [travel, paris, landmark]
---

# Eiffel Tower Visit

![Photo](../media/2025-11-01_09-30-15.jpg)

## Voice Memo
![[2025-11-01_09-35-22.m4a]]

## Notes
Amazing architecture, sunny day, lots of tourists.

**Rating**: ⭐⭐⭐⭐⭐

**GPS**: 48.8584, 2.2945  
**Accuracy**: 12m  
**Duration**: 45 minutes
```

**Directory Structure**:
```
export/
├── 2025-11-01-Budapest/
│   ├── moments/
│   │   ├── morning-tour.md
│   │   ├── lunch-break.md
│   │   └── evening-walk.md
│   ├── daily/
│   │   └── 2025-11-01.md (all events)
│   └── media/
│       ├── photos/
│       └── audio/
└── journey-map.md (overview with map link)
```

**Implementation**:
```
lib/features/export/
├── services/
│   ├── obsidian_exporter.dart
│   ├── markdown_generator.dart
│   └── file_copier.dart
├── presentation/
│   ├── export_screen.dart
│   └── widgets/
│       ├── export_preview.dart
│       └── format_selector.dart
└── models/
    └── export_config.dart
```

**Features**:
- Choose date range
- Include/exclude media
- Organize by moments or chronological
- Preview before export
- Export to Downloads or custom path
- Copy to $GOOGLE_DRIVE_PATH if set

**Complexity**: Medium (file I/O + formatting)
**Testing**: Golden tests for markdown output

---

### 5.2 Google Drive Backup (1-2 days)
**What**: Auto-backup database + media to Google Drive

**Tech Stack**:
- `google_sign_in` package
- `googleapis` (Drive API v3)
- Background upload service

**Implementation**:
```
lib/features/backup/
├── services/
│   ├── google_drive_service.dart
│   ├── backup_scheduler.dart
│   └── incremental_backup.dart
└── presentation/
    └── backup_settings_screen.dart
```

**Features**:
- One-time OAuth setup
- Auto-backup when on WiFi
- Incremental uploads (only new files)
- Restore from backup
- View backup history
- Manual trigger

**Storage Structure**:
```
Google Drive/REIS Backups/
├── database/
│   └── travel_journal_2025-11-01.db
└── media/
    ├── photos/
    └── audio/
```

**Complexity**: Medium (OAuth + API + scheduling)
**Testing**: Mock Drive API

---

## Phase 6: UX Polish (2-3 days)
**Goal**: Improve overall user experience

### 6.1 Lock Screen Widget (2 days)
**What**: Quick capture widget on lock screen (Android 5.0+)

**Tech Stack**:
- Android App Widgets API
- Platform channels
- Background service

**Widget Types**:
1. **Photo Button**: 1x1 widget, instant capture
2. **Capture Menu**: 2x1 widget, choose mode
3. **Last Event**: 2x2 widget, show recent capture

**Implementation**:
```
android/app/src/main/kotlin/
├── QuickCaptureWidget.kt
├── WidgetConfigActivity.kt
└── BackgroundCaptureService.kt

lib/platform/
└── widget_channel.dart
```

**Complexity**: Medium (native Android)
**Testing**: Manual device testing

---

### 6.2 Search & Filters (1 day)
**What**: Find events quickly

**Features**:
- Search by text content
- Filter by type (photo/audio/text/rating)
- Filter by date range
- Filter by moment
- Filter by location (nearby events)
- Sort by date/type/rating

**Implementation**:
```
lib/features/search/
├── presentation/
│   ├── search_screen.dart
│   └── widgets/
│       ├── search_bar.dart
│       └── filter_chips.dart
└── services/
    └── search_service.dart
```

**SQL Queries**:
```sql
-- Full-text search
SELECT * FROM events 
WHERE json_extract(data, '$.note') LIKE '%keyword%'
OR json_extract(data, '$.title') LIKE '%keyword%'

-- Nearby events
SELECT * FROM events
WHERE latitude IS NOT NULL
AND (latitude - ?) * (latitude - ?) + 
    (longitude - ?) * (longitude - ?) < ?
```

**Complexity**: Low (UI + SQL)
**Testing**: Repository tests for queries

---

## Implementation Priority

### Phase A: Pre-Budapest (1 week) - CRITICAL
**Goal**: Maximum value for minimal phone interaction
**Timeline**: Days 1-7

1. ✅ **Quick Tile** (2 days) - Swipe-down instant capture
2. ✅ **Burst Mode** (1 day) - Hold for rapid photos
3. ✅ **Battery Saver** (2 days) - All-day tracking
4. ⚠️ **Offline Maps POC** (2 days) - Download Budapest tiles

**Deliverable**: App with quick capture + battery optimization

---

### Phase B: Post-Trip 1 (2 weeks) - HIGH VALUE
**Goal**: Review and visualize journey
**Timeline**: Days 8-21

5. **Offline Maps** (2 days) - Complete implementation
6. **Timeline View** (2 days) - Visualize journey
7. **Obsidian Export** (3 days) - Get data into notes
8. **Search & Filters** (1 day) - Find events quickly

**Deliverable**: Full visualization + export workflow

---

### Phase C: Post-Trip 2 (2-3 weeks) - NICE TO HAVE
**Goal**: Advanced features
**Timeline**: Days 22-35

9. **Wear OS App** (7 days) - Watch voice memos
10. **Google Drive Backup** (2 days) - Cloud safety net
11. **Lock Screen Widget** (2 days) - Even faster capture
12. **Adaptive Tracking** (1 day) - Smart intervals

**Deliverable**: Complete feature set

---

## Smartwatch Deep Dive

### Wear OS Architecture

**Two Apps Approach**:
1. **Main App** (existing): Phone-based, full features
2. **Wear App** (new): Watch-based, voice memos only

**Shared Code**:
```
packages/
└── shared/
    ├── models/
    │   ├── capture_event.dart  # Reused
    │   └── location.dart       # Reused
    └── services/
        └── audio_recorder.dart # Reused
```

**Wear-Specific Code**:
```
wear_app/
├── lib/
│   ├── main.dart               # Watch UI
│   ├── screens/
│   │   ├── home_screen.dart    # Record button
│   │   └── recording_screen.dart
│   └── services/
│       └── local_storage.dart  # SQLite on watch
└── android/
    └── app/src/main/
        ├── AndroidManifest.xml # Wear features
        └── kotlin/
            └── WearMessageService.kt
```

**Data Flow**:
```
Watch: Record audio → Save locally → Queue for sync
  ↓ (Bluetooth connection)
Phone: Receive audio → Add GPS → Save to DB → Notify user
```

**Challenges**:
1. **Wear OS Setup**: Need physical watch or emulator
2. **UI Constraints**: Small screen (1-2 buttons max)
3. **Battery**: Limit recording to 5 min max
4. **Sync Reliability**: Handle disconnections gracefully
5. **Testing**: Harder to automate

**Recommendation**: 
- Start with Quick Tile (2 days)
- If successful, invest in Wear OS (7 days)
- Fallback: Use Bluetooth headset button for voice memos

---

## Development Setup

### Required for All Phases:
- Flutter SDK 3.0+
- Android Studio / VS Code
- Android device/emulator (API 21+)

### Additional for Wear OS:
- Wear OS emulator or physical Wear OS device
- Wear OS system image (API 28+)
- `wear` package dependencies

### Additional for Maps:
- OpenStreetMap account (free)
- Tile download quota (check limits)

---

## Testing Strategy

### Unit Tests
- All services (capture, moment, battery, sync)
- All algorithms (location clustering, grouping)
- Repository layer with mocks

### Widget Tests
- All screens and major widgets
- Gesture handling (burst mode, long press)
- Search/filter UI

### Integration Tests
- End-to-end capture flows
- Map tile download and display
- Export generation
- Wear sync (if implemented)

### Manual Testing
- Battery drain over 8 hours
- Offline map performance
- Quick tile reliability
- Wear OS sync stability

**Target**: Maintain 80%+ code coverage

---

## Risk Assessment

### High Risk
1. **Wear OS Sync**: Bluetooth reliability issues
   - *Mitigation*: Queue-based retry mechanism
   
2. **Battery Life**: GPS draining battery too fast
   - *Mitigation*: Adaptive tracking + power profiles

### Medium Risk
3. **Offline Maps**: Tile storage size
   - *Mitigation*: Configurable zoom levels, city presets
   
4. **Quick Tile**: Background camera permissions
   - *Mitigation*: Clear user messaging, fallback to foreground

### Low Risk
5. **Burst Mode**: Camera lock issues
   - *Mitigation*: Proper resource cleanup
   
6. **Export**: File path permissions
   - *Mitigation*: Use scoped storage APIs

---

## Success Metrics

### Pre-Budapest
- [ ] Quick capture < 3 seconds from lock screen
- [ ] Battery lasts 8+ hours with tracking
- [ ] Budapest map tiles downloaded (< 100MB)

### Post-Budapest
- [ ] 90%+ of events captured successfully
- [ ] Export generates valid Obsidian notes
- [ ] Map visualizes full journey

### Wear OS (Optional)
- [ ] Voice memos sync within 5 minutes
- [ ] No missed recordings due to sync failures
- [ ] Watch battery lasts 12+ hours

---

## Total Effort Estimate

| Phase | Days | Priority | Status |
|-------|------|----------|--------|
| Phase 1: Quick Capture | 3-5 | HIGH | ✅ COMPLETE (1.5 hours) |
| Phase 2: Wear OS | 5-7 | MEDIUM | Not started |
| Phase 3: Maps | 4-6 | MEDIUM | Not started |
| Phase 4: Battery | 2-3 | HIGH | ✅ COMPLETE (2 hours) |
| Phase 5: Export | 3-4 | HIGH | Not started |
| Phase 6: UX Polish | 2-3 | LOW | Not started |
| **TOTAL** | **24-35** | - | **2/6 phases done (33%)** |

**Recommended Approach**: 
- Sprint 1 (Pre-trip): Phase 1 + 4 = 1 week
- Sprint 2 (Post-trip): Phase 3 + 5 = 2 weeks  
- Sprint 3 (Optional): Phase 2 + 6 = 2 weeks

**Minimum Viable**: Phases 1, 4, 5 = 8-12 days
**Complete Feature Set**: All phases = 24-35 days

---

## Next Steps

1. **Immediate** (this week):
   - Implement Android Quick Tile
   - Add photo burst mode
   - Basic battery monitoring

2. **Budapest Prep** (before travel):
   - Download offline map tiles for Budapest
   - Test battery life over full day
   - Create backup of app data

3. **Post-Budapest** (after travel):
   - Implement Obsidian export
   - Build map visualization
   - Consider Wear OS based on trip experience

**Ready to start? Let's begin with Phase 1.1 - Quick Tile! 🚀**
