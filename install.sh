#!/bin/bash
set -e

echo -e "\e[35m  ╱|、       meow.\e[0m"
echo -e "\e[35m(˚ˎ 。7     /\e[0m"
echo -e "\e[35m |、˜〵          \e[0m"
echo -e "\e[35m じしˍ,)ノ\e[0m"
echo ""
echo -e "\e[36m Universal YT-DLP Manager\e[0m"
echo ""

install_ytdlp() {
    INSTALL_DIR="$HOME/.yt-dlp"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        URL="https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos"
    else
        URL="https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux"
    fi
    
    BIN_PATH="$INSTALL_DIR/yt-dlp"

    echo -e "\e[33m [*] Preparing installation directory...\e[0m"
    mkdir -p "$INSTALL_DIR"

    echo -e "\e[33m [*] Downloading YT-DLP...\e[0m"
    curl -L --progress-bar "$URL" -o "$BIN_PATH"

    echo -e "\e[33m [*] Adding to system PATH...\e[0m"
    EXPORT_LINE="\nexport PATH=\"\$PATH:$INSTALL_DIR\""
    
    for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile"; do
        if [ -f "$profile" ]; then
            if ! grep -q "$INSTALL_DIR" "$profile"; then
                echo -e "$EXPORT_LINE" >> "$profile"
            fi
        fi
    done
    
    chmod +x "$BIN_PATH"

    echo -e "\e[32m [v] Successfully installed YT-DLP!\e[0m"
    echo -e "\e[90m     Please restart your terminal to use 'yt-dlp'.\e[0m"
}

uninstall_ytdlp() {
    INSTALL_DIR="$HOME/.yt-dlp"

    echo -e "\e[33m [*] Removing YT-DLP files...\e[0m"
    rm -rf "$INSTALL_DIR"

    echo -e "\e[33m [*] Removing from system PATH...\e[0m"
    echo -e "\e[90m     Please manually remove $INSTALL_DIR from your .bashrc or .zshrc\e[0m"

    echo -e "\e[32m [v] Successfully uninstalled YT-DLP!\e[0m"
}

echo -e "\e[37m 1. Install YT-DLP\e[0m"
echo -e "\e[37m 2. Uninstall YT-DLP\e[0m"
echo ""
read -p " Select an option (1/2): " choice

echo ""
if [ "$choice" == "1" ]; then
    install_ytdlp
elif [ "$choice" == "2" ]; then
    uninstall_ytdlp
else
    echo -e "\e[31m [x] Invalid option selected.\e[0m"
fi
