# Video Conversion Script

## Overview

This Bash script allows users to convert video files from one format to another. The script utilizes `ffmpeg` for video conversion and `kdialog` for graphical directory and file selection.

## Prerequisites

Before using this script, ensure you have the following packages installed on your system:

- **FFmpeg**
- **KDialog**

### Installation

To install the required packages, you can use the following commands depending on your operating system:

#### On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install ffmpeg kdialog
```

#### On Fedora:

```bash
sudo dnf install ffmpeg kdialog
```

#### On Arch Linux:

```bash
sudo pacman -S ffmpeg kdialog
```

## Usage

1. **Clone the Repository** (if applicable):
   If this script is part of a repository, clone it using:

   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. **Make the Script Executable**:
   You may need to give the script execute permissions:

   ```bash
   chmod +x convert_script.sh
   ```

3. **Run the Script**:
   Execute the script from the terminal:

   ```bash
   ./convert_script.sh
   ```

4. **Follow the Prompts**:
   - Choose to convert video files or exit the script.
   - Select the video format you wish to search for (e.g., `mp4`, `mkv`, `mov`, `avi`).
   - Choose the directory containing your video files using the graphical dialog.
   - Select the files you want to convert.
   - Choose the desired output video format for the conversion.

## Notes

- The script will create a directory called `originals` within the selected directory to store the original video files after conversion.
- Ensure that your paths and file names do not contain special characters or unexpected formats that may interfere with the script's execution.
- This script only converts audio to `pcm_s16le` format, regardless of the video format selected. Ensure this is acceptable for your use case.
- The script has been developed and tested in **EndeavourOS** with **KDE Plasma**. Compatibility may vary in other environments.
