daveXtract – macOS-Style Archive Extraction for Windows
===================================================

**daveXtract** brings macOS-style archive extraction to Windows. Double-click any archive → extract to folder → delete original → open folder. Simple as that.

The Problem
-----------

Windows archive extraction sucks:

*   Right-click → Extract → Choose folder → Navigate → Extract → Delete original → Open folder
*   Too many clicks, too slow, too annoying
*   macOS does it in one double-click

The Solution
------------

**Double-click any archive** and XTRACT will:

1.  ✅ Extract to folder with same name
2.  ✅ Handle folder collisions intelligently
3.  ✅ Ask: delete archive + open folder? 
4.  ✅ Fast operation with 7-Zip backend

Installation
------------

### 1. Install 7-Zip

Download and install [7-Zip](https://www.7-zip.org/) first.

### 2. Download XTRACT

Save `xtract.bat` to your computer (anywhere you want).

### 3. Set as Default

1.  Right-click any `.zip` file → **Open with** → **Choose another app**
2.  Click **More apps** → **Look for another app on this PC**
3.  Browse to `xtract.bat` and select it
4.  ✅ Check **Always use this app** to set as default

Done! Now double-click any archive to extract it.

Usage
-----

### Basic Extraction

Double-click any archive → automatically extracts to folder → choose what to do next:

* **ENTER** – delete archive and open folder  
* **DEL** – delete archive only  
* **Any other key** – exit without changes  

### ⏱ 2.5-Second Countdown

After extraction, the script waits **2.5 seconds** for your key press:

- If you press **ENTER** or **DEL** within the countdown → action happens immediately.  
- If no key is pressed in that time → the script exits and leaves the archive untouched.  

### Folder Collisions

If target folder exists, choose:

*   **[O] Overwrite** – replace all files
*   **[C] Cancel** – abort operation
*   **[M] Merge** – skip existing files
*   **[I] Increment** – create numbered folder (e.g., Archive-01)
*   **[Z] 7-Zip** – open in 7-Zip File Manager

Requirements
------------

*   **7-Zip** installed in default location (`C:\Program Files\7-Zip\`)

Supported Formats
-----------------

All 7-Zip supported formats: `.zip`, `.rar`, `.7z`, `.tar`, `.gz`, `.bz2`, `.iso`, `.cab`, and more.

**⭐ Star if this saved you time!**
