# Testing Guide - Daily Notes & Journal

## 🧪 Manual Testing Checklist

Use this checklist to verify all features work correctly.

---

## ✅ Initial Setup Testing

### 1. App Launch
- [ ] App launches without errors
- [ ] Bottom navigation bar displays with 3 tabs
- [ ] Default tab is "Notes"
- [ ] Theme matches system (or default light)

---

## 📝 Notes Feature Testing

### Create Note
- [ ] Tap "+" floating action button
- [ ] See "New Note" screen
- [ ] Enter title: "Test Note"
- [ ] Enter description: "This is a test note"
- [ ] (Optional) Tap "Add Image" and select image
- [ ] Tap "✓" to save
- [ ] See note appear in list

### View Note
- [ ] Note displays with title
- [ ] Note displays description (preview)
- [ ] If image added, image displays
- [ ] Date and time display correctly

### Edit Note
- [ ] Tap existing note
- [ ] See "Edit Note" screen
- [ ] Title and description populate
- [ ] Modify title to "Updated Test Note"
- [ ] Tap "✓" to save
- [ ] See updated note in list

### Delete Note
- [ ] Tap trash icon on note
- [ ] See confirmation dialog
- [ ] Tap "Delete"
- [ ] Note disappears from list

### Empty State
- [ ] Delete all notes
- [ ] See empty state message
- [ ] See icon and "No notes yet" text

---

## 📖 Journal Feature Testing

### Today's Entry
- [ ] Tap "Journal" tab
- [ ] See today's date displayed
- [ ] See "Today's Journal" card
- [ ] Type: "My first journal entry"
- [ ] Tap "Save Entry" button
- [ ] See success snackbar

### Date Navigation
- [ ] Tap calendar icon
- [ ] Select yesterday's date
- [ ] See empty journal (if no entry)
- [ ] Type entry for yesterday
- [ ] Save entry
- [ ] Navigate back to today
- [ ] See today's entry still there

### Edit Existing Entry
- [ ] Navigate to date with entry
- [ ] Entry content displays
- [ ] Modify text
- [ ] Tap "Update Entry"
- [ ] Changes persist

### Delete Entry
- [ ] Navigate to date with entry
- [ ] Tap trash icon
- [ ] See confirmation dialog
- [ ] Tap "Delete"
- [ ] Entry disappears
- [ ] Empty state appears

### Date Picker
- [ ] Tap calendar icon
- [ ] See date picker dialog
- [ ] Select different dates
- [ ] Verify entries load correctly

---

## ✅ To-Do Feature Testing

### Add Task
- [ ] Tap "To-Do" tab
- [ ] See today's date
- [ ] Type task: "Buy groceries"
- [ ] Press Enter or tap "+" button
- [ ] Task appears in list
- [ ] Add 2-3 more tasks

### Complete Task
- [ ] Tap checkbox on a task
- [ ] Task moves to "Completed" section
- [ ] Text shows strikethrough
- [ ] Task order updates

### Uncomplete Task
- [ ] Tap checkbox on completed task
- [ ] Task moves back to "Tasks" section
- [ ] Strikethrough removed
- [ ] Task reappears in correct position

### Delete Task
- [ ] Tap trash icon on task
- [ ] Task disappears immediately
- [ ] No confirmation dialog (instant delete)

### Date Navigation
- [ ] Tap left chevron (<)
- [ ] Date changes to yesterday
- [ ] Tasks list updates (may be empty)
- [ ] Tap right chevron (>)
- [ ] Return to today
- [ ] Today's tasks reappear

### Date Picker
- [ ] Tap calendar icon
- [ ] Select future date
- [ ] Add task for that date
- [ ] Navigate to different date
- [ ] Return to future date
- [ ] Task still there

### Empty State
- [ ] Delete all tasks for today
- [ ] See empty state message
- [ ] See "No tasks for today" text

---

## 🎨 Theme Testing

### Current Implementation
The app currently loads with system theme or light mode by default.

### To Test Theme Toggle (requires UI addition)
To add theme toggle button:

1. Modify `home_screen.dart` AppBar:
```dart
AppBar(
  title: Text('...'),
  actions: [
    IconButton(
      icon: Icon(Icons.brightness_6),
      onPressed: () {
        context.read<ThemeBloc>().add(ToggleThemeEvent());
      },
    ),
  ],
)
```

2. Test toggle:
- [ ] Tap brightness icon
- [ ] Theme switches instantly
- [ ] All screens update
- [ ] Restart app
- [ ] Theme persists

---

## 💾 Data Persistence Testing

### Test 1: Note Persistence
1. [ ] Add 3 notes
2. [ ] Close app completely
3. [ ] Reopen app
4. [ ] All 3 notes still there

### Test 2: Journal Persistence
1. [ ] Write entries for 3 different days
2. [ ] Close app
3. [ ] Reopen app
4. [ ] Navigate to those dates
5. [ ] All entries still there

### Test 3: To-Do Persistence
1. [ ] Add 5 tasks for today
2. [ ] Complete 2 tasks
3. [ ] Close app
4. [ ] Reopen app
5. [ ] All tasks still there
6. [ ] Completion status preserved

### Test 4: Theme Persistence
1. [ ] Toggle theme to dark
2. [ ] Close app
3. [ ] Reopen app
4. [ ] Dark theme still active

---

## 📱 UI/UX Testing

### Material Design 3
- [ ] Cards have proper elevation
- [ ] Border radius is consistent
- [ ] Colors match theme
- [ ] Typography is clear
- [ ] Spacing feels balanced

### Animations
- [ ] Tab switching is smooth
- [ ] No jank or stuttering
- [ ] Transitions feel natural

### Responsiveness
- [ ] Text fields respond immediately
- [ ] Buttons provide feedback
- [ ] Loading states display when needed
- [ ] No frozen UI

### Dialogs
- [ ] Delete confirmations appear
- [ ] Can cancel or confirm
- [ ] Dialogs dismiss properly

---

## 🐛 Edge Cases Testing

### Empty States
- [ ] Empty notes list
- [ ] Empty journal (no entry for date)
- [ ] Empty to-do list
- [ ] All show helpful messages

### Long Content
- [ ] Long note title (100+ chars)
- [ ] Long note description (1000+ chars)
- [ ] Long journal entry (5000+ chars)
- [ ] Long task name (200+ chars)
- [ ] All display/truncate properly

### Special Characters
- [ ] Note title with emojis: "🎉 Party Notes 🎊"
- [ ] Description with line breaks
- [ ] Special characters: @#$%^&*()
- [ ] All save and display correctly

### Date Boundaries
- [ ] First day of month
- [ ] Last day of month
- [ ] Leap year dates
- [ ] Year boundaries (Dec 31 → Jan 1)

### Image Testing (Notes)
- [ ] Add large image (5MB+)
- [ ] Add small image (100KB)
- [ ] Different formats (JPG, PNG)
- [ ] Remove image from note
- [ ] Edit note with image

---

## ⚡ Performance Testing

### Stress Test
1. [ ] Add 50 notes
2. [ ] Scroll through list smoothly
3. [ ] Add 100 to-do tasks
4. [ ] No lag when marking complete

### Memory
1. [ ] Open all 3 tabs multiple times
2. [ ] Add/delete items repeatedly
3. [ ] No memory leaks
4. [ ] App doesn't crash

---

## 📋 Bug Report Template

If you find a bug, document it:

```
**Bug Title**: [Short description]

**Steps to Reproduce**:
1. Go to...
2. Tap...
3. See error

**Expected Behavior**: [What should happen]

**Actual Behavior**: [What actually happens]

**Screenshots**: [If applicable]

**Device**: [Android/iOS, version]

**App Version**: 0.1.0
```

---

## ✅ Final Checklist

Before considering testing complete:

### Functionality
- [ ] All features work as designed
- [ ] No crashes or errors
- [ ] Data persists correctly
- [ ] Navigation works smoothly

### UI/UX
- [ ] Theme looks good
- [ ] Animations are smooth
- [ ] Text is readable
- [ ] Icons are clear
- [ ] Spacing is consistent

### Edge Cases
- [ ] Empty states handled
- [ ] Long content handled
- [ ] Special characters work
- [ ] Date boundaries work

### Performance
- [ ] No lag or stuttering
- [ ] Smooth scrolling
- [ ] Quick responses
- [ ] No memory issues

---

## 🎉 Test Results

Date Tested: __________

Tester: __________

**Overall Status**: [ ] PASS [ ] FAIL

**Notes**:
_____________________________________
_____________________________________
_____________________________________

**Issues Found**: ___ (count)

**Critical**: ___ (blocking release)
**Major**: ___ (should fix soon)
**Minor**: ___ (nice to fix)

---

## 📞 Support

For questions about testing:
- Check ARCHITECTURE.md for code details
- Check README.md for feature descriptions
- Check SETUP.md for setup help

---

**Happy Testing! 🧪**
