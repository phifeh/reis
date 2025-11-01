# Testing Checklist for Day 1 Core Capture

## Prerequisites
- Android device or emulator connected
- Camera permission granted
- Location permission granted

## Manual Test Cases

### 1. Works in Airplane Mode
**Steps:**
1. Enable airplane mode on device
2. Open app
3. Tap camera button
4. Take a photo
5. Verify photo is saved (check events list)

**Expected:** Photo saves without GPS data, no crash

---

### 2. Survives Force Quit
**Steps:**
1. Take 3 photos
2. Force quit app (Settings > Apps > Reis > Force Stop)
3. Reopen app
4. Check events list

**Expected:** All 3 photos still visible

---

### 3. Handles Rapid Captures
**Steps:**
1. Open camera
2. Take 5 photos as quickly as possible (within 10 seconds)
3. Close camera
4. Check events list

**Expected:** All 5 photos saved and visible

---

### 4. GPS Timeout Doesn't Block Capture
**Steps:**
1. Disable GPS/Location services
2. Open camera
3. Take a photo
4. Check if photo saves within 2 seconds

**Expected:** Photo saves immediately without waiting for GPS

---

### 5. Photos Actually Saved to Disk
**Steps:**
1. Take 3 photos
2. Use Android file browser or adb to check:
   ```
   /data/data/com.reis.reis/app_flutter/media/photos/
   ```
3. Verify files exist with correct naming pattern

**Expected:** Files exist with format: `YYYY-MM-DD_HH-mm-ss_[uuid].jpg`

---

### 6. No GPS Permission
**Steps:**
1. Deny GPS permission when requested
2. Take a photo
3. Check if photo saves

**Expected:** Photo saves without location data

---

### 7. No Camera Permission
**Steps:**
1. Deny camera permission
2. Try to open camera
3. Check for error message
4. Grant permission via settings
5. Try again

**Expected:** Clear error message, retry works after granting

---

### 8. Storage Full Scenario
**Manual simulation:**
1. Fill device storage to <100MB
2. Try to take photo

**Expected:** Clear error message about storage

---

### 9. Camera In Use
**Steps:**
1. Open another camera app
2. Without closing it, open Reis
3. Try to access camera

**Expected:** Graceful error handling

---

### 10. Database Integrity After Multiple Operations
**Steps:**
1. Take 10 photos
2. Force quit app
3. Reopen
4. Take 10 more photos
5. Force quit again
6. Reopen and verify all 20 photos

**Expected:** All photos persist correctly

---

## Automated Checks

Run these commands to verify:

```bash
# Check database exists
adb shell run-as com.reis.reis ls -la /data/user/0/com.reis.reis/app_flutter/database/

# Check photos directory
adb shell run-as com.reis.reis ls -la /data/user/0/com.reis.reis/app_flutter/media/photos/

# Count photos
adb shell run-as com.reis.reis ls /data/user/0/com.reis.reis/app_flutter/media/photos/ | wc -l

# View database (if sqlite3 available)
adb shell run-as com.reis.reis sqlite3 /data/user/0/com.reis.reis/app_flutter/database/travel_journal.db "SELECT COUNT(*) FROM events;"
```

## Performance Checks

- Photo capture latency: Should be < 2 seconds from tap to save
- App launch time: Should be < 3 seconds
- List scrolling: Should be smooth with 100+ items

## Pass Criteria

- [ ] All 10 manual test cases pass
- [ ] No crashes during any scenario
- [ ] Data persists across force quits
- [ ] Graceful degradation when permissions denied
- [ ] Clear error messages for all failure scenarios
