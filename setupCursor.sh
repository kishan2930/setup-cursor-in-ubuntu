#!/bin/bash

set -e

# === Color Codes ===
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# === Variables ===
JSON=$(curl -s "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable")
CURSOR_URL=$(echo "$JSON" | grep -oP '(?<="downloadUrl":")[^"]+')
LATEST_VERSION=$(echo "$JSON" | grep -oP '(?<="version":")[^"]+')
DEFAULT_ICON_URL="https://www.cursor.com/favicon.svg"

INSTALL_DIR="/opt/cursor"
APPIMAGE_PATH="$INSTALL_DIR/cursor.appimage"
ICON_PATH="$INSTALL_DIR/cursor.svg"
VERSION_FILE="$INSTALL_DIR/version"
DESKTOP_PATH="/usr/share/applications/cursor.desktop"

get_shell_rc() {
    case "$(basename "$SHELL")" in
        bash) echo "$HOME/.bashrc" ;;
        zsh) echo "$HOME/.zshrc" ;;
        *) echo "$HOME/.profile" ;;
    esac
}

install_fuse2() {
    echo -e "${YELLOW}Checking FUSE support...${NC}"
    if ! dpkg -l | grep -q "libfuse2"; then
        echo -e "${CYAN}Installing libfuse2...${NC}"
        sudo apt update && sudo apt install -y libfuse2
    else
        echo -e "${GREEN}FUSE v2 is already installed.${NC}"
    fi
}

add_cursor_function() {
    SHELL_RC=$(get_shell_rc)
    if ! grep -q "# Cursor launcher" "$SHELL_RC"; then
        echo -e "${CYAN}Adding 'cursor' command to $SHELL_RC...${NC}"
        cat >> "$SHELL_RC" <<EOF

# Cursor launcher
function cursor() {
    $APPIMAGE_PATH --no-sandbox "\$@" > /dev/null 2>&1 & disown
}
EOF
    fi
}

remove_cursor_function() {
    SHELL_RC=$(get_shell_rc)
    echo -e "${CYAN}Removing 'cursor' command from $SHELL_RC...${NC}"
    sed -i '/# Cursor launcher/,+4d' "$SHELL_RC" || true
}

set_default_icon() {
    echo -e "${CYAN}Setting default icon from Cursor website...${NC}"
    sudo mkdir -p "$INSTALL_DIR"
    curl -sL "$DEFAULT_ICON_URL" -o /tmp/default_cursor.svg
    sudo mv /tmp/default_cursor.svg "$ICON_PATH"
    rm -f /tmp/default_cursor.svg
    echo -e "${GREEN}Default icon set at $ICON_PATH${NC}"
}

update_icon() {
    echo -e "${YELLOW}Enter .svg URL for custom icon:${NC}"
    read -p "SVG URL: " SVG_URL
    if [[ ! "$SVG_URL" =~ \.svg$ ]]; then
        echo -e "${RED}Only .svg files are allowed.${NC}"
        exit 1
    fi
    echo -e "${CYAN}Downloading icon...${NC}"
    curl -sL "$SVG_URL" -o /tmp/custom_cursor.svg
    sudo mv /tmp/custom_cursor.svg "$ICON_PATH"
    rm -f /tmp/custom_cursor.svg
    echo -e "${GREEN}Icon updated at $ICON_PATH${NC}"
    sudo sed -i "s|^Icon=.*|Icon=$ICON_PATH|" "$DESKTOP_PATH" || true
}

install_cursor() {
    echo -e "${YELLOW}Installing Cursor...${NC}"
    install_fuse2
    sudo mkdir -p "$INSTALL_DIR"
    sudo curl -L "$CURSOR_URL" -o "$APPIMAGE_PATH"
    sudo chmod +x "$APPIMAGE_PATH"
    echo "$LATEST_VERSION" | sudo tee "$VERSION_FILE" > /dev/null
    set_default_icon

    echo -e "${CYAN}Creating desktop entry...${NC}"
    sudo bash -c "cat > $DESKTOP_PATH" <<EOF
[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;
EOF

    add_cursor_function

    echo -e "${GREEN}Cursor installed successfully! Use 'cursor' to launch.${NC}"
}

uninstall_cursor() {
    echo -e "${YELLOW}Uninstalling Cursor...${NC}"
    sudo rm -rf "$INSTALL_DIR"
    sudo rm -f "$DESKTOP_PATH"
    remove_cursor_function
    echo -e "${GREEN}Uninstalled successfully.${NC}"
}

update_cursor() {
    echo -e "${YELLOW}Updating Cursor to version $LATEST_VERSION...${NC}"
    sudo rm -f "$APPIMAGE_PATH"
    sudo curl -L "$CURSOR_URL" -o "$APPIMAGE_PATH"
    sudo chmod +x "$APPIMAGE_PATH"
    echo "$LATEST_VERSION" | sudo tee "$VERSION_FILE" > /dev/null
    echo -e "${GREEN}Updated successfully. Icon remains unchanged.${NC}"
}

# === Menu ===
echo -e "${CYAN}Choose an option:${NC}"
echo -e "${GREEN}1) Install Cursor"
echo "2) Uninstall Cursor"
echo "3) Update Cursor"
echo "4) Change Icon"
echo -e "5) Exit${NC}"
read -p "Enter your choice: " choice

case "$choice" in
  1) install_cursor ;;
  2) uninstall_cursor ;;
  3) update_cursor ;;
  4) update_icon ;;
  5) echo -e "${RED}Bye!${NC}" && exit 0 ;;
  *) echo -e "${RED}Invalid option.${NC}" && exit 1 ;;
esac
