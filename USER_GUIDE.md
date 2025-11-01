# Quick Start Guide - REIS Travel Journal

## 🚀 Getting Started

### Installation
```bash
# Clone the repository
cd /path/to/reis

# Get dependencies
flutter pub get

# Run on Android device
flutter run

# Or build APK
flutter build apk --release
```

### First Launch
1. App requests camera, location, and microphone permissions
2. Grant all permissions for full functionality
3. Main screen shows empty event list
4. Tap floating + button to start capturing

---

## 📸 Capturing Memories

### Photo Capture
1. Tap **+ button** → Select **PHOTO** tab
2. Point camera and tap **capture button**
3. Photo automatically saved with GPS location
4. Optionally add a note
5. Tap **Save** to store event

### Voice Memo
1. Tap **+ button** → Select **AUDIO** tab
2. Tap **microphone icon** to start recording
3. Watch timer count up
4. Tap **stop** when done
5. Add optional note
6. Tap **Save**

### Text Note
1. Tap **+ button** → Select **NOTE** tab
2. Enter title (optional)
3. Type your note
4. Tap **Save**

### Rating/Review
1. Tap **+ button** → Select **RATING** tab
2. Select star rating (1-5)
3. Enter place name (optional)
4. Add notes (optional)
5. Tap **Save**

---

## 📍 Location Tracking

### Enable Background Tracking
1. Tap **settings icon** (top right)
2. Toggle **"Enable Location Tracking"** ON
3. Choose interval (5, 10, or 15 minutes)
4. Location updates automatically in foreground

### Understanding Moments
- **Auto Moments**: Events within 100m and 30 minutes auto-group
- **Manual Moments**: Create custom groupings
- **Journey Moments**: Travel segments between locations

---

## 🎨 Understanding the Interface

### Event List Screen
- **Scroll**: View all captures chronologically
- **Tap event**: View details (future feature)
- **Pull down**: Refresh event list
- **Settings icon**: Access configuration
- **+ button**: Quick capture access

### Capture Modes (4 tabs)
- **PHOTO** (camera icon): Camera capture
- **AUDIO** (microphone icon): Voice recording
- **NOTE** (edit icon): Text notes
- **RATING** (star icon): Rate places/experiences

### Settings Screen
- **Location Tracking**: Toggle on/off
- **Tracking Interval**: 5/10/15 minutes
- **Moment Settings**: Auto-grouping config
- **Export Options**: (Coming soon)

---

## 💡 Pro Tips

### Battery Saving
- Use 15-minute tracking interval
- Disable tracking when stationary
- Re-enable when moving

### Best Practices
1. **Take photos first**: Captures location automatically
2. **Add notes immediately**: While details are fresh
3. **Use ratings**: Quick way to mark memorable places
4. **Voice memos**: Capture thoughts while walking
5. **Check moments daily**: Verify auto-grouping makes sense

### GPS Accuracy
- **Outdoors**: ~5-20m accuracy
- **Indoors**: ~50-100m accuracy
- **No GPS**: Event saved without location (okay!)

---

## 🔧 Troubleshooting

### Camera Won't Open
- Check camera permission granted
- Close other apps using camera
- Restart app

### No GPS Location
- Enable location services in Android settings
- Wait 10-30 seconds for GPS lock
- Move outdoors for better signal
- Event still saves without GPS!

### Audio Recording Fails
- Check microphone permission granted
- Close other apps using microphone
- Check storage space available

### Events Not Appearing
- Tap refresh icon
- Check storage permissions
- Restart app

---

## 📊 Data Storage

### Where is my data?
- **Photos**: `/Android/data/com.yourapp.reis/files/photos/`
- **Audio**: `/Android/data/com.yourapp.reis/files/audio/`
- **Database**: `/Android/data/com.yourapp.reis/databases/`

### Backup Your Data
Currently manual (export feature coming):
1. Connect to computer
2. Copy entire app folder
3. Store backup safely

---

## 🌍 Travel Scenario Example

### Day Trip to Paris
```
09:00 - Start tracking (Settings → Enable)
09:30 - Photo of Eiffel Tower → Auto-moment "Eiffel Area"
10:00 - Voice memo about architecture
10:15 - Rating: 5★ "Eiffel Tower View"
12:00 - Travel to Louvre (Journey moment created)
12:30 - Photo at Louvre → New moment "Louvre Visit"
14:00 - Text note about Mona Lisa
18:00 - Return to hotel (Journey moment)
19:00 - Stop tracking
```

Result: 3 auto-moments + 2 journey moments, all organized!

---

## ⚙️ Advanced Configuration

### Moment Detection Tuning
Edit in code (future: UI controls):
```dart
GroupingStrategy(
  timeThreshold: Duration(minutes: 30),  // Group within 30min
  distanceThreshold: 100.0,              // Group within 100m
  autoGroupEnabled: true,
)
```

### Location Accuracy
```dart
BackgroundLocationService(
  interval: Duration(minutes: 5),  // Update frequency
  distanceFilter: 50,              // Min meters between updates
  accuracy: LocationAccuracy.medium,
)
```

---

## 🎯 Recommended Workflow

### Before Trip
1. Install app
2. Test all capture modes
3. Enable location tracking
4. Set 5-minute interval

### During Trip
1. Keep app running in background
2. Capture photos frequently
3. Add voice memos for context
4. Rate memorable places
5. Quick text notes for details

### After Trip
1. Review event list
2. Check moment groupings
3. Export to Obsidian (coming soon)
4. Backup data

---

## 🐛 Reporting Issues

If you encounter problems:
1. Note exact steps to reproduce
2. Check logcat output
3. Verify permissions granted
4. Try on different device
5. File issue with details

---

## 📱 System Requirements

- **Android**: 5.0+ (API 21+)
- **Storage**: 100MB minimum
- **RAM**: 2GB recommended
- **GPS**: Required for location features
- **Camera**: Required for photos
- **Microphone**: Required for audio

---

## 🎨 Theme Customization

The retro theme uses:
- **Warm colors**: Beige, cream, vintage orange
- **Serif fonts**: Spectral typeface
- **Minimal UI**: Focus on content
- **Paper texture**: Vintage journal feel

Future: Allow theme switching

---

## ⏱️ Performance Tips

### Fast Capture
- Keep app in foreground
- Use hardware camera button
- Pre-grant all permissions
- Clear old events periodically

### Battery Optimization
- Use airplane mode when not tracking
- Disable tracking indoors
- Close other GPS apps
- Reduce tracking interval

---

## 🔜 Coming Soon

- [ ] Moment management UI
- [ ] Obsidian markdown export
- [ ] Photo gallery import
- [ ] Search and filters
- [ ] Map visualization
- [ ] Timeline view
- [ ] Batch operations
- [ ] Cloud backup option

---

**Enjoy capturing your travel memories! 📸✈️🗺️**
