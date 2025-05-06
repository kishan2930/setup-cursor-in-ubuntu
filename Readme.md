# 🖱️ Cursor AI Installer Script

A user-friendly Bash script to **install**, **uninstall**, or **reinstall** [Cursor AI](https://www.cursor.com) — the AI-powered coding IDE — on your **Linux system**.

---

## 📜 Features

- Installs the latest **Cursor AppImage**.
- Automatically installs dependencies like `libfuse2` and `curl`.
- Adds a launcher function `cursor` to your terminal via `.bashrc`.
- Creates a **desktop shortcut** with the official icon.
- Checks if Cursor is already installed and provides options:
  - ✅ Uninstall it
  - 🔁 Delete and Reinstall
  - ❌ Exit

---

## 📂 Files Managed by Script

| File                                     | Description                        |
| ---------------------------------------- | ---------------------------------- |
| `/opt/cursor.appimage`                   | The main Cursor IDE AppImage       |
| `/opt/cursor.svg`                        | The official Cursor icon           |
| `/usr/share/applications/cursor.desktop` | Desktop launcher entry             |
| `~/.bashrc`                              | Adds the `cursor` terminal command |

---

## 🛠️ Requirements

- 🐧 Linux (Ubuntu/Debian-based preferred)
- `bash` shell
- `curl` installed (if not, script will auto-install)
- `libfuse2` (if not, script will auto-install)

---

## 📦 Installation & Usage

### 🔽 Step 1: Download the Script

```bash
curl -O https://raw.githubusercontent.com/kishan2930/setup-cursor-in-ubuntu/main/setupCursor.sh
```
### ✅ Step 2: Make it Executable

```bash
chmod +x install_cursor.sh
```

### 🚀 Step 3: Run the Script

```bash
./install_cursor.sh
```
## 🧼 To Uninstall Cursor (manually)
```bash
sudo rm -f /opt/cursor.appimage
sudo rm -f /opt/cursor.svg
sudo rm -f /usr/share/applications/cursor.desktop
```