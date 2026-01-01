# XDF–ECG Time Alignment and Cropping Script

This MATLAB script aligns **Actiheart ECG data** with multiple **XDF trial recordings** using absolute timestamps and extracts trial-specific ECG segments.  
Each XDF file defines a **time window**, and only the ECG samples that fall within that window are retained.

The final output is a **subject-level `.mat` file** containing ECG segments for all trials.

---

## What this script does (high-level)

1. Loads multiple `.xdf` files corresponding to experimental trials.
2. Extracts **absolute timestamps** from a dedicated XDF stream named `TimestampStream`.
3. Loads Actiheart ECG data from a `.txt` export file.
4. Converts ECG date/time information into MATLAB `datetime`.
5. For each XDF trial:
   - Identifies the trial start and end time
   - Crops ECG samples that fall within this window
6. Saves all cropped ECG segments into a single subject-level `.mat` file.

---

## Input Files

### 1) XDF files
```matlab
xdfFiles = {
  'S2-pr-TWEO-NG-T1.xdf',
  'S2-pr-TWEO-NG-T2.xdf',
  'S2-pr-HOW-NG-T1.xdf',
  'S2-pr-HOW-NG-T2.xdf',
  'S2-pr-FPECWF-NG-T1.xdf',
  'S2-pr-FPECWF-NG-T2.xdf'
};
```

**Requirements**
- Each XDF file must contain a stream named:
```text
TimestampStream
```
- `TimestampStream.time_series` must store **POSIX timestamps in milliseconds**.

---

### 2) Actiheart ECG file
```matlab
filename = 'P1UmairActiheart.txt';
```

**Expected format**
- Tab-delimited text file
- First 15 lines are header metadata
- Data columns:
  1. Date (yyyy-mm-dd)
  2. Time (HH:MM:SS)
  3. Fractional seconds
  4. TotalSeconds (epoch-based counter)
  5. ECG value

---

## How time alignment works

### XDF timestamps
- Extracted from `TimestampStream`
- Converted from milliseconds → seconds → `datetime`
- Interpreted in **local time zone**

### ECG timestamps
- Built by combining:
  - Date
  - Time
  - Fractional seconds
- Converted to `datetime` in the same local time zone

### Cropping logic
For each XDF file:
```matlab
ECG_datetime >= trial_start_time
ECG_datetime <= trial_end_time
```

Only ECG samples inside this interval are retained.

---

## Output

### MATLAB file
The script saves a subject-level MAT file:

```text
S2_HR_allAct.mat
```

### Inside the MAT file
A structure named:
```matlab
S2_HR_allAct
```

with fields corresponding to each XDF trial, for example:
```matlab
S2_HR_allAct.S2_pr_TWEO_NG_T1.extractedECG
S2_HR_allAct.S2_pr_TWEO_NG_T1.extractedEpochTimes
```

Each trial field contains:
- `extractedECG` — ECG samples during that trial
- `extractedEpochTimes` — corresponding epoch-based time values

---

## Typical Use Cases

- Aligning wearable ECG data with task-based XDF recordings
- Trial-wise heart rate / HRV analysis
- Multimodal synchronization (ECG ↔ motion ↔ fNIRS ↔ LSL)
- Post-hoc physiological analysis in human factors and neuroscience studies

---

## Key Assumptions (Important)

1. **TimestampStream uses POSIX epoch time (milliseconds).**  
   If timestamps are relative or use a different reference, alignment will be incorrect.

2. **ECG and XDF clocks are synchronized.**  
   Both must share the same wall-clock reference (or be offset-corrected beforehand).

3. **Local time zone is consistent** across ECG export and XDF timestamps.

---

## Known Limitations

- Uses `eval` for dynamic variable and structure creation (functional but not ideal).
- No automatic verification of clock drift.
- Assumes continuous ECG coverage across all trials.

---

## Suggested Improvements (Optional)

- Replace `eval` with structured containers (maps or nested structs)
- Add sanity-check plots (ECG vs trial window)
- Log trial durations and sample counts
- Support CSV output per trial

---

## Dependencies

- MATLAB
- XDF toolbox (`load_xdf`)
- Actiheart ECG export in text format

---

## Summary

This script performs **trial-wise ECG extraction** by using XDF-based absolute timestamps as ground truth.  
It is designed for **offline physiological analysis** where precise temporal alignment between wearable sensors and experimental tasks is required.
