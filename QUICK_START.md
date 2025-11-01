# Reis - Quick Start Guide

## Installation
```bash
# Build and install on Android device
flutter build apk --release
flutter install

# Or for development
flutter run
```

## Permissions
On first launch, grant:
- ✅ Camera (for photos)
- ✅ Microphone (for voice memos)
- ✅ Location (for GPS tagging)

## Capturing Memories

### Photo
1. Tap the camera FAB button
2. Select **PHOTO** tab
3. Tap shutter button
4. GPS location automatically captured
5. Add optional note

### Voice Memo
1. Tap camera button → **AUDIO** tab
2. Tap red record button
3. Record your thoughts
4. Tap stop when done
5. Add optional note

### Text Note
1. Tap camera button → **NOTE** tab
2. Add title (optional)
3. Write your note
4. GPS tagged automatically
5. Tap save

### Rating
1. Tap camera button → **RATING** tab
2. Select stars (1-5)
3. Add place name (optional)
4. Add note (optional)
5. Tap save

## Viewing Memories
- Main screen shows all captures in reverse chronological order
- Each card shows:
  - Type badge (PHOTO/AUDIO/NOTE/RATING)
  - Timestamp in retro format
  - GPS coordinates (if available)
  - Content preview

## Settings
- Tap settings icon (top right)
- Background tracking: Coming soon
- Tracking interval: For future use

## Data Storage
All data saved locally:
- Database: `app_documents/database/travel_journal.db`
- Photos: `app_documents/media/photos/`
- Audio: `app_documents/media/audio/`

## Troubleshooting

### GPS not working
- Check location permission
- Try outdoors for better signal
- Indoor captures still work (no GPS tag)

### Photos not saving
- Check storage permission
- Ensure sufficient storage space

### Audio recording fails
- Check microphone permission
- Close other apps using microphone

## Tips for Travel

1. **Enable location always** for best GPS accuracy
2. **Photo burst**: Take multiple photos quickly
3. **Voice journal** while walking between places
4. **Rate immediately** - capture the moment
5. **Add notes** to remember context

## Coming Soon
- 🔜 Automatic moment grouping
- 🔜 Manual moment creation
- 🔜 Export to Markdown
- 🔜 Background GPS tracking
- 🔜 Import photos from gallery

## Keyboard Shortcuts (Development)
- `r` - Hot reload
- `R` - Hot restart
- `h` - Help
- `q` - Quit

---

**Enjoy your journey! 🌍**
