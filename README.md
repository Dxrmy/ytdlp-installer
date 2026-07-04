# YT-DLP Installer

Automatically downloads and installs the latest `yt-dlp` binary directly from GitHub, and adds it to your system's PATH.

Works cleanly without needing any prior software or package managers installed.

## Installation

### Windows
Open **PowerShell** and run the following command:
```powershell
irm https://raw.githubusercontent.com/Dxrmy/ytdlp-installer/main/install.ps1 | iex
```

### macOS & Linux
Open your **Terminal** and run the following command:
```bash
curl -sL https://raw.githubusercontent.com/Dxrmy/ytdlp-installer/main/install.sh | bash
```

## What this does

1. Detects your OS and downloads the correct official `yt-dlp` binary.
2. Saves it to a safe, hidden location (`~/.yt-dlp/`).
3. Adds the folder to your `PATH` so the `yt-dlp` command works globally.

## Usage

### Running yt-dlp

Once installed, you can use `yt-dlp` from any terminal or command prompt (you may need to restart your terminal first).

To download a video, just run:
```bash
yt-dlp "https://www.youtube.com/watch?v=YOUR_VIDEO_ID"
```

### Uninstalling

To uninstall `yt-dlp`, simply run the installation script again and select the **Uninstall** option (`2`) from the interactive menu.
