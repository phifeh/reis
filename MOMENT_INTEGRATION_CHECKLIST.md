# Moment Detection Integration Checklist

## Goal
Connect the existing moment detection algorithms to the capture flow and build a UI for managing moments.

## Prerequisites ✅
- [x] Database schema created (moments, moment_events tables)
- [x] MomentRepository implemented
- [x] MomentDetectionService with configurable strategies
- [x] Location clustering algorithms
- [x] CaptureEvent model with location data

## Phase 1: Wire Up Auto-Detection (4-6 hours)

### 1.1 Modify Capture Flow
- [ ] Update `EventsNotifier.addEvent()` to trigger moment detection
- [ ] Call `MomentDetectionService.analyzeEvent()` after saving event
- [ ] Handle `MomentDecision` results:
  - CreateNew → create new moment
  - AddToExisting → append to current moment
  - CreateSubMoment → create child moment
  - AskUser → show dialog (Phase 2)

```dart
// In events_provider.dart
Future<void> addEvent(CaptureEvent event) async {
  await captureEventRepository.save(event);
  
  // NEW: Trigger moment detection
  final momentRepo = ref.read(momentRepositoryProvider);
  final momentService = MomentService(momentRepo);
  final detectionService = MomentDetectionService(
    repository: momentRepo,
    strategy: MomentDetectionStrategy.standard(),
  );
  
  final decision = await detectionService.analyzeEvent(event, null);
  
  switch (decision.type) {
    case DecisionType.createNew:
      final moment = await momentService.createMoment(/* ... */);
      await momentService.assignEventToMoment(event.id, moment.id);
      break;
    case DecisionType.addToExisting:
      await momentService.assignEventToMoment(event.id, decision.momentId!);
      break;
    // ... handle other cases
  }
  
  await _loadEvents();
}
```

### 1.2 Create Moment Provider
```dart
// lib/features/moments/presentation/moments_provider.dart
final momentsProvider = StateNotifierProvider<MomentsNotifier, AsyncValue<List<Moment>>>((ref) {
  final repository = ref.watch(momentRepositoryProvider);
  return MomentsNotifier(repository);
});

class MomentsNotifier extends StateNotifier<AsyncValue<List<Moment>>> {
  final MomentRepository repository;
  
  MomentsNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadMoments();
  }
  
  Future<void> loadMoments() async {
    try {
      final moments = await repository.findAll();
      state = AsyncValue.data(moments);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> createMoment({required String name}) async {
    // Implementation
  }
  
  Future<void> splitMoment(String momentId, String atEventId) async {
    // Implementation
  }
}
```

### 1.3 Test Auto-Detection
- [ ] Create test with mock events
- [ ] Verify moment creation
- [ ] Check event assignment
- [ ] Test edge cases (GPS loss, rapid captures)

## Phase 2: Moment Management UI (6-8 hours)

### 2.1 Moments List Screen
```dart
// lib/features/moments/presentation/moments_list_screen.dart
class MomentsListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moments = ref.watch(momentsProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Moments')),
      body: moments.when(
        data: (momentsList) => ListView.builder(
          itemCount: momentsList.length,
          itemBuilder: (context, index) {
            final moment = momentsList[index];
            return MomentCard(moment: moment);
          },
        ),
        loading: () => CircularProgressIndicator(),
        error: (e, s) => ErrorWidget(e),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateMomentDialog(context, ref),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 2.2 Moment Detail Screen
- [ ] Show moment metadata (name, time range, location)
- [ ] List all events in moment
- [ ] Allow event reassignment (drag to other moments)
- [ ] Show sub-moments if hierarchical
- [ ] Edit moment name
- [ ] Delete moment (keeps events)

### 2.3 Moment Card Widget
```dart
// lib/features/moments/presentation/widgets/moment_card.dart
class MomentCard extends StatelessWidget {
  final Moment moment;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RetroTheme.vintageCard,
      child: Column(
        children: [
          // Moment header
          Row(
            children: [
              Icon(Icons.bookmark_outline),
              Text(moment.name ?? 'Unnamed Moment'),
              Spacer(),
              Text('${moment.eventCount} captures'),
            ],
          ),
          
          // Time range
          Text('${formatDate(moment.startTime)} - ${formatDate(moment.endTime)}'),
          
          // Location (if available)
          if (moment.centerLat != null)
            LocationChip(lat: moment.centerLat, lon: moment.centerLon),
          
          // Preview of first few events
          EventPreviewRow(momentId: moment.id),
        ],
      ),
    );
  }
}
```

### 2.4 Manual Moment Controls
- [ ] "Start New Moment" button in capture screen
- [ ] "End Current Moment" action
- [ ] Moment assignment dialog when `AskUser` decision
- [ ] Batch reassignment (select multiple events)

## Phase 3: Enhanced Features (4-6 hours)

### 3.1 Hierarchical Moments
- [ ] UI for creating sub-moments
- [ ] Visual hierarchy (indentation/tree view)
- [ ] Example: "Paris" → "Eiffel Tower" → "Café at base"

### 3.2 Moment Splitting
```dart
// Split moment dialog
void _showSplitDialog(Moment moment) {
  // Show event timeline
  // Let user select split point
  // Call momentService.splitMoment(momentId, atEventId)
}
```

### 3.3 Moment Merging
```dart
// Merge moments dialog
void _showMergeDialog(List<Moment> selectedMoments) {
  // Confirm merge
  // Call momentService.mergeMoments(momentIds)
}
```

### 3.4 Smart Suggestions
- [ ] Suggest moment names based on location reverse geocoding
- [ ] Detect common patterns (e.g., morning routine, lunch break)
- [ ] Suggest moment splits when large time/distance gaps detected

## Phase 4: Settings Integration (2 hours)

### 4.1 Moment Detection Settings
- [ ] Enable/disable auto-detection
- [ ] Choose strategy (Standard/Strict/Relaxed)
- [ ] Custom thresholds (distance, time)
- [ ] Auto-create sub-moments toggle

```dart
// In settings_screen.dart
SwitchListTile(
  title: Text('Auto-detect Moments'),
  value: ref.watch(autoDetectMomentsProvider),
  onChanged: (value) {
    ref.read(autoDetectMomentsProvider.notifier).state = value;
  },
),

DropdownButton<MomentDetectionStrategy>(
  value: ref.watch(detectionStrategyProvider),
  items: [
    DropdownMenuItem(value: MomentDetectionStrategy.strict(), child: Text('Strict')),
    DropdownMenuItem(value: MomentDetectionStrategy.standard(), child: Text('Standard')),
    DropdownMenuItem(value: MomentDetectionStrategy.relaxed(), child: Text('Relaxed')),
  ],
  onChanged: (strategy) {
    ref.read(detectionStrategyProvider.notifier).state = strategy;
  },
),
```

## Phase 5: Navigation & Integration (2 hours)

### 5.1 Add Moments Tab
```dart
// Update main navigation
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
    BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Moments'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ],
)
```

### 5.2 Update Events List
- [ ] Show moment badge on each event
- [ ] Filter events by moment
- [ ] Quick-assign to moment action

### 5.3 Journey Moments
- [ ] Detect when user moves between moments
- [ ] Auto-create "Journey" type moments
- [ ] Show on timeline as connecting lines

## Testing Scenarios

### Scenario 1: Walk to Café
```
1. Take photo at home (10:00, GPS: 40.7128, -74.0060)
   → Creates Moment "Morning at Home"
2. Take photo 5 min later at same location
   → Adds to same moment
3. Walk 500m, take photo at café (10:45, GPS: 40.7138, -74.0050)
   → Creates new Moment "Café Visit"
4. Record voice memo at café (10:50)
   → Adds to "Café Visit"
```

### Scenario 2: GPS Loss
```
1. Photo outdoors (GPS accurate)
   → Creates moment
2. Photo indoors (no GPS / poor accuracy)
   → Uses time-based grouping, adds to same moment
3. Photo back outdoors (GPS returns)
   → Checks if still within time threshold, adds to moment
```

### Scenario 3: Return to Location
```
1. Photo at hotel (08:00)
   → Creates "Morning at Hotel"
2. Photo at museum (10:00, 2km away)
   → Creates "Museum Visit"
3. Photo at hotel (20:00, back at hotel)
   → Decision: Create new moment "Evening at Hotel" (time gap > 30min)
```

## Estimated Timeline

| Phase | Tasks | Hours | Priority |
|-------|-------|-------|----------|
| 1 | Wire up auto-detection | 4-6 | HIGH |
| 2 | Moment management UI | 6-8 | HIGH |
| 3 | Enhanced features | 4-6 | MEDIUM |
| 4 | Settings integration | 2 | MEDIUM |
| 5 | Navigation & polish | 2 | LOW |
| **Total** | | **18-24 hours** | **~3 days** |

## Success Criteria

- [ ] Events automatically grouped into moments
- [ ] User can view all moments
- [ ] User can manually create/split/merge moments
- [ ] User can reassign events between moments
- [ ] Settings allow customization
- [ ] No existing events lost or corrupted
- [ ] All tests still pass

## Next Steps

1. Start with Phase 1.1 - modify capture flow
2. Test with mock data
3. Build moments list screen
4. Iterate based on real usage

**Ready to implement! 🎯**
