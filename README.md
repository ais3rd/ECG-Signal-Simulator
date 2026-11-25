# ECG Signal Simulator

A Delphi VCL app that loads a recorded ECG from a CSV file and plays it back page by page on a chart, like a simple ECG monitor.

## Features
- **Cari Data ECG** loads `.csv` ECG data sampled at **360 Hz**, the MIT-BIH Arrhythmia Database format exported from PhysioNet
- Reads the total sample count from the last row and shows the recording length in seconds
- Adjustable window length: 1, 5, 10, 15, 20, 30, 35, 40, 45, 50, 55 or 60 seconds
- **Previous** and **Next** buttons to step through the recording
- Chart axes are labeled in mV and time (s)

## Expected CSV format
```
'sample #','MLII','V5'
0,-0.145,-0.065
1,-0.145,-0.065
...
```
The first column is the sample index, and the next column holds the ECG amplitude.

## Build
Open `KPPbro.dproj` in Delphi (RAD Studio, Community Edition works) and run it. It needs the VCL and TeeChart.

## Files
- `KPP.pas` / `.dfm`: main form and logic
- `KPPbro.dpr`: project entry point

## License
Released under the [MIT License](LICENSE).
