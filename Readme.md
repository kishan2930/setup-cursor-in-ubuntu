# 🖱️ Cursor AI Installer Script

A user-friendly Bash script to **install**, **update**, **uninstall**, or **customize** [Cursor AI](https://www.cursor.com) — the AI-powered coding IDE — on your **Linux system**.

---

## 📜 Features

- Installs the latest **Cursor AppImage** directly from official source.
- Automatically installs dependencies like `libfuse2`.
- Automatically detects your shell (bash, zsh, or others) and adds launcher function.
- Creates a **desktop shortcut** with the official icon.
- Interactive menu with multiple options:
  - ✅ Install Cursor
  - 🗑️ Uninstall Cursor
  - 🔄 Update Cursor to latest version
  - 🎨 Change Cursor icon (custom SVG)
  - ❌ Exit

---

## 📂 Files Managed by Script

| File                                     | Description                        |
| ---------------------------------------- | ---------------------------------- |
| `/opt/cursor/cursor.appimage`            | The main Cursor IDE AppImage       |
| `/opt/cursor/cursor.svg`                 | The Cursor icon (default or custom)|
| `/opt/cursor/version`                    | The installed Cursor Version       |
| `/usr/share/applications/cursor.desktop` | Desktop launcher entry             |
| `~/.bashrc` or `~/.zshrc` or `~/.profile`| Adds the `cursor` terminal command |

---

## 🛠️ Requirements

- 🐧 Linux (Ubuntu/Debian-based preferred)
- `bash` shell
- `curl` for downloading resources
- `libfuse2` (script will auto-install if missing)

---

## 📦 Installation & Usage

### 🔽 Step 1: Download the Script

```bash
curl -O https://raw.githubusercontent.com/kishan2930/setup-cursor-in-ubuntu/main/setupCursor.sh
```

### ✅ Step 2: Make it Executable

```bash
chmod +x setupCursor.sh
```

### 🚀 Step 3: Run the Script

```bash
sudo ./setupCursor.sh
```

### 🎮 Step 4: Choose an Option

The script will present an interactive menu:
1. Install Cursor
2. Uninstall Cursor
3. Update Cursor
4. Change Icon
5. Exit

## 💻 Using Cursor After Installation

Once installed, you can launch Cursor in two ways:
- From your applications menu/launcher
- By typing `cursor` in your terminal

## 🧼 To Uninstall Cursor (manually)

```bash
sudo rm -rf /opt/cursor
sudo rm -f /usr/share/applications/cursor.desktop
```
And remove the cursor function from your shell configuration file:

```bash
# For Bash users
sed -i '/# Cursor launcher/,+4d' ~/.bashrc

# For Zsh users
sed -i '/# Cursor launcher/,+4d' ~/.zshrc

# For other shells
sed -i '/# Cursor launcher/,+4d' ~/.profile
```
