# Keyboard-Based Touch Counter (Key Press = Event)

This MATLAB script implements simple way to record number of key presses and corresponding timing during finger to nose coordination sensorimotor task. The two programable external keys act as hardware targets for the task. External keys were programed as space and enter inputs. 

---

## File

### `keyPressCounter.m`

> Run this function directly in MATLAB:
```matlab
keyPressCounter
```

---

## What this script does (in plain language)

1. Opens a small MATLAB window.
2. Prompts the user to enter an **input string** (e.g., Subject ID, Trial ID).
3. After input is entered, the keyboard becomes active.
4. Each **key press is treated as a touch event**:
   - **Space bar** → Left touch
   - **Enter / Return** → Right touch
5. For every press, the script:
   - Records the exact timestamp
   - Computes the time gap since the previous press
   - Stores the event in memory
6. Pressing **Escape (Esc)**:
   - Saves all recorded events to Excel
   - Displays final counts
   - Closes the program

---

## Key Mapping

| Key | Meaning | Logged As |
|---|---|---|
| `Space` | Left-side touch | `LeftTouch = 1` |
| `Enter / Return` | Right-side touch | `RightTouch = 1` |
| `Escape` | End trial | Save + exit |

> **Important:**  
> The keyboard **is the response device**.  
> No mouse, touchscreen, or external hardware is required.

---

## Data Recorded Per Key Press

Each key press generates **one row** in the output file with:

| Column | Description |
|---|---|
| `InputString` | User-defined identifier (e.g., subject or trial ID) |
| `LeftTouch` | 1 if left key pressed, else 0 |
| `RightTouch` | 1 if right key pressed, else 0 |
| `Timestamp` | Wall-clock time of the key press |
| `TimeGap(ms)` | Time since previous key press (milliseconds) |

---

## Output

### Excel file
- **Filename:** `KeyPressResults.xlsx`
- Automatically created in the current working directory
- If the file already exists, new rows are **appended**

This makes it easy to:
- Combine multiple trials
- Import into MATLAB, R, Python, or Excel
- Analyze counts, rhythms, and inter-press intervals

---

## Typical Use Cases

- Finger–nose counting tasks
- Alternating finger tapping
- Simple motor rhythm assessments
- Behavioral backup logging during sensor failures

---

## Timing Notes

- Timestamps are generated using:
```matlab
datetime('now')
```
- Time gaps are computed in milliseconds.
- This provides **millisecond resolution**, but timing accuracy is limited by:
  - Operating system scheduling
  - Keyboard polling latency
---

## How to Exit Safely
- Press **Escape (Esc)** to:
  - Save all data
  - Print final counts to the MATLAB Command Window
  - Close the GUI cleanly

Closing the window manually will also display final counts, but **Esc is recommended** to ensure data is saved.

---

## License / Attribution
MIT license

---

## Summary

- **Keyboard = response device**
- **Each key press = one touch event**
- Counts, timestamps, and inter-press timing are logged
- Lightweight, portable, and easy to integrate into behavioral workflows
