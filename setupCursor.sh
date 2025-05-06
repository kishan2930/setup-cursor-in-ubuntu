#!/bin/bash

set -e

# Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${CYAN}"
echo " _______  __   __  ______    _______  _______  ______   
|       ||  | |  ||    _ |  |       ||       ||    _ |  
|       ||  | |  ||   | ||  |  _____||   _   ||   | ||  
|       ||  |_|  ||   |_||_ | |_____ |  | |  ||   |_||_ 
|      _||       ||    __  ||_____  ||  |_|  ||    __  |
|     |_ |       ||   |  | | _____| ||       ||   |  | |
|_______||_______||___|  |_||_______||_______||___|  |_|"
echo -e "${YELLOW}"
echo "       CURSOR INSTALLER SCRIPT BY KISHAN AMBALIYA"
echo -e "${GREEN}       GitHub: https://github.com/kishan2930${NC}"
echo ""

# Define variables
CURSOR_URL="https://downloads.cursor.com/production/0781e811de386a0c5bcb07ceb259df8ff8246a52/linux/x64/Cursor-0.49.6-x86_64.AppImage"
SVG_ICON_URL="https://www.cursor.com/favicon.svg"
ICON_PATH="/opt/cursor.svg"
DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"
APPIMAGE_PATH="/opt/cursor.appimage"

# First prompt: Install or Exit
echo -e "${CYAN}What do you want to do?${NC}"
echo -e "${GREEN}  1) Install Cursor"
echo -e "  2) Exit${NC}"
read -p "Enter your choice (1 or 2): " start_choice
echo ""

if [ "$start_choice" == "2" ]; then
    echo -e "${RED}Exiting...${NC}"
    exit 0
elif [ "$start_choice" != "1" ]; then
    echo -e "${RED}Invalid choice. Exiting...${NC}"
    exit 1
fi

# Check if already installed
if [ -f "$APPIMAGE_PATH" ] || [ -f "$DESKTOP_ENTRY_PATH" ]; then
    echo -e "${YELLOW}Cursor is already installed on your system.${NC}"
    echo -e "${CYAN}What do you want to do now?${NC}"
    echo -e "${GREEN}  1) Uninstall Cursor completely"
    echo -e "  2) Delete old and reinstall fresh"
    echo -e "  3) Exit${NC}"
    read -p "Enter your choice (1/2/3): " already_choice
    echo ""

    if [ "$already_choice" == "1" ]; then
        echo -e "${YELLOW}Uninstalling Cursor...${NC}"
        sudo rm -f "$APPIMAGE_PATH" "$DESKTOP_ENTRY_PATH" "$ICON_PATH"
        sudo sed -i '/# Cursor launcher/,+3d' "$HOME/.bashrc"
        echo -e "${GREEN}Cursor uninstalled successfully.${NC}"
        exit 0

    elif [ "$already_choice" == "2" ]; then
        echo -e "${YELLOW}Removing old Cursor installation...${NC}"
        sudo rm -f "$APPIMAGE_PATH" "$DESKTOP_ENTRY_PATH" "$ICON_PATH"
        sudo sed -i '/# Cursor launcher/,+3d' "$HOME/.bashrc"
        echo -e "${GREEN}Old installation removed. Proceeding to install fresh...${NC}"

    elif [ "$already_choice" == "3" ]; then
        echo -e "${RED}Exiting without making any changes.${NC}"
        exit 0
    else
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
    fi
fi

# Function to install libfuse2
install_fuse_v2() {
    echo -e "${YELLOW}Checking for FUSE v2 support...${NC}"
    if ! dpkg -l | grep -q "libfuse2"; then
        echo -e "${CYAN}Installing libfuse2...${NC}"
        sudo apt update
        sudo apt install -y libfuse2
    else
        echo -e "${GREEN}FUSE v2 is already installed.${NC}"
    fi
}

# Function to update cursor icon
update_cursor_icon() {
    echo -e "${YELLOW}Updating Cursor icon...${NC}"

    if ! command -v curl &> /dev/null; then
        echo -e "${CYAN}Installing curl...${NC}"
        sudo apt update
        sudo apt install -y curl
    fi

    echo -e "${CYAN}Downloading SVG icon...${NC}"
    curl -L "$SVG_ICON_URL" -o "$ICON_PATH"
    echo -e "${GREEN}SVG icon downloaded to $ICON_PATH${NC}"

    echo -e "${CYAN}Updating desktop entry icon path...${NC}"
    if [ -f "$DESKTOP_ENTRY_PATH" ]; then
        sudo sed -i "s|^Icon=.*|Icon=$ICON_PATH|" "$DESKTOP_ENTRY_PATH"
    fi
    echo -e "${GREEN}Cursor icon updated successfully.${NC}"
}

# Function to install Cursor
install_cursor() {
    echo -e "${YELLOW}Starting Cursor AI installation...${NC}"

    install_fuse_v2

    if ! command -v curl &> /dev/null; then
        echo -e "${CYAN}Installing curl...${NC}"
        sudo apt update
        sudo apt install -y curl
    fi

    echo -e "${CYAN}Downloading Cursor AppImage...${NC}"
    sudo curl -L "$CURSOR_URL" -o "$APPIMAGE_PATH"
    sudo chmod +x "$APPIMAGE_PATH"

    update_cursor_icon

    echo -e "${CYAN}Creating desktop entry...${NC}"
    sudo bash -c "cat > $DESKTOP_ENTRY_PATH" <<EOL
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;
EOL

    if ! grep -q "function cursor()" "$HOME/.bashrc"; then
        echo -e "${CYAN}Adding 'cursor' function to .bashrc...${NC}"
        cat >> "$HOME/.bashrc" <<'EOL'

# Cursor launcher
function cursor() {
    /opt/cursor.appimage --no-sandbox "$@" > /dev/null 2>&1 & disown
}
EOL
        source "$HOME/.bashrc"
    fi

    echo -e ""
    echo -e "${GREEN}Cursor installation complete! You can now run it using the 'cursor' command.${NC}"
    echo -e ""
}

# Start installation
install_cursor
