<div align="center">

# 🚀 Rapid Texter GUI

![C++](https://img.shields.io/badge/C++-17-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![Qt](https://img.shields.io/badge/Qt-6.8-41CD52?style=for-the-badge&logo=qt&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-lightgrey?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Test your finger speed and mental accuracy with a modern interface.** Rapid Texter now features a stunning **GUI (Graphical User Interface)**, smooth animations, and a more intuitive user experience.

[Features](#-key-features) • [Download](#-download--installation) • [Build](#%EF%B8%8F-build-from-source) • [Contribute](#-license)

</div>

---

## 🔄 Migrated from Rapid Texter (TUI)

> [!IMPORTANT]
> This application is a **GUI (Graphical User Interface)** of the original terminal-based application: **[Rapid Texter (TUI)](https://github.com/aleafarrel-id/rapid-texter)**.

The original Rapid Texter uses a **TUI (Terminal User Interface)** that runs in the terminal. This version brings the same experience with a modern **GUI (Graphical User Interface)** powered by Qt/QML.

### ✅ Full Data Synchronization

Both applications share the **same data directory**, meaning:

- **📜 History**: All your typing session records are preserved and accessible from both versions.
- **📈 Progress**: Your campaign progress, completed levels, and achievements stay intact.
- **⚙️ Personalization**: Settings and preferences are synchronized between TUI and GUI versions.

> [!TIP]
> You can use both versions interchangeably! Switch between the terminal (TUI) and graphical (GUI) versions whenever you prefer, and your data will always be in sync.

---

## ⚡ Key Features

* **✨ Modern GUI:** Built with **Qt/QML 6.8**, delivering an aesthetic and responsive interface.
* **🌐 Multi-Language:** Available in Indonesian & English modes.
* **💻 Programmer Mode:** Practice typing symbols and coding syntax (`#include`, `std::vector`, etc.).
* **📊 Visual Statistics:** Monitor WPM (*Words Per Minute*), Accuracy, and Progress Charts with attractive visuals.
* **🎨 Themes & Animations:** Smooth menu transitions and eye-comfortable interface design.
* **🎵 Sound Effects:** Satisfying audio feedback when typing correctly (ding!) or incorrectly.
* **🖱️ Mouse & Keyboard Friendly:** Navigate menus using the mouse or stick to the keyboard for speed.

---

## 📥 Download & Installation

The easiest way to use Rapid Texter is by downloading the provided installer.

### 🪟 Windows (Recommended)
1. Go to the latest **[Releases](https://github.com/aleafarrel-id/rapidtexter-gui/releases)** page.
2. Download the `RapidTexterGUI_win64-Setup.exe` file.
3. Run the `.exe` file and follow the installation instructions.
4. The application is ready to use! A shortcut will be available on your Desktop and Start Menu.

### 🐧 Linux (RPM)
> [!NOTE]
> For RPM-based distributions. Tested on **Fedora 43**.

1. Go to the latest **[Releases](https://github.com/aleafarrel-id/rapidtexter-gui/releases)** page.
2. Download the `.rpm` file.
3. Install via terminal: `sudo dnf install ./RapidTexterGUI-x86_64.rpm`
4. The application is ready to use!

### 🐧 Linux (Flatpak) - Universal
> [!TIP]
> **Recommended for all Linux distributions!** Works on Debian, Ubuntu, Arch, Fedora, openSUSE, and more.

**Step 1: Install Flatpak** (skip if already installed)
```bash
# Fedora
sudo dnf install flatpak

# Ubuntu/Debian
sudo apt install flatpak

# Arch
sudo pacman -S flatpak
```

**Step 2: Add Flathub repository** (required for runtime dependencies)
```bash
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**Step 3: Install Qt6 runtime** (required, ~800MB, shared with other Qt apps)
```bash
flatpak install --user flathub org.kde.Platform//6.8
```

> [!NOTE]
> **About the runtime size:** The KDE Platform runtime is large (~800MB), but it's a **one-time download**. This runtime is **shared across all Qt/KDE applications** (like Krita, Kdenlive, Kate, etc.). If you already have another KDE app installed via Flatpak, you won't need to download it again!

**Step 4: Download & Install RapidTexter**
1. Download `RapidTexterGUI.flatpak` from **[Releases](https://github.com/aleafarrel/rapidtexter-gui/releases)**
2. Install via terminal:
   ```bash
   flatpak install --user RapidTexterGUI.flatpak
   ```

**Step 5: Run the application**
```bash
flatpak run io.github.aleafarrel.RapidTexter
```

> [!NOTE]
> After installation, RapidTexter will also appear in your application menu.

> [!WARNING]
> **Ubuntu/Debian users:** If the app doesn't appear in your application menu, install the desktop portal:
> ```bash
> sudo apt install xdg-desktop-portal-gtk
> ```
> Then logout and login again.

**Uninstall:**
```bash
flatpak uninstall io.github.aleafarrel.RapidTexter
```

---

## 🎮 How to Use

### 1. Main Menu
An elegant start screen allows you to choose your mode:
- **Play Game**: Start a new game.
- **History**: View your typing speed progress charts.
- **Settings**: Adjust sound effects and other preferences.

### 2. Game Customization
Before starting, you can configure:
- **Language**: Indonesia (ID) or English (EN).
- **Time**: 15s, 30s, 60s, or Custom.
- **Mode**:
    - **Manual**: Free WPM target.
    - **Campaign**: Progressive levels (Easy, Medium, Hard, Programmer).

### 3. Gameplay
Type the text that appears on the screen.
- **Green**: Correct letter.
- **Red**: Incorrect letter.
- **Backspace**: Can be used to correct previous mistakes.

### 4. Results & Evaluation
At the end of the session, you will see a result card displaying:
- **Big WPM**: Main speed score.
- **Accuracy**: Typing precision percentage.
- **Chart**: Comparison with previous sessions (if available).

---

## 🛠️ Build from Source

For developers who want to contribute or modify the source code.

### Prerequisites
1.  **Qt 6.8** (Install via Qt Online Installer, select **Qt Quick**, **Qt Quick Controls 2**, **Qt Multimedia** components).
2.  **C++ Compiler** (MSVC 2019+ or latest GCC/Clang).
3.  **CMake** version 3.16 or higher.

### Build Steps

Clone this repository:
```bash
git clone https://github.com/aleafarrel-id/rapidtexter-gui.git
cd rapidtexter-gui
```

Build using CMake:

```bash
# 1. Configure (Ensure Qt 6.8 path is correct/detected)
cmake -S . -B build

# 2. Compile
cmake --build build --config Release
```

### Run Application
The build result will be in the `build/Release/` (Windows) or `build/` (Linux) folder.

---

## 📂 Project Structure

```text
rapid-texter-gui/
├── assets/                             # Word banks (en, id, prog), fonts, icons, sfx
├── include/                            # C++ header files
├── src/                                # C++ implementation files
├── qml/                                # Qt Quick/QML UI
│   ├── components/                     # Reusable UI components (Theme, NavBtn, etc.)
│   └── pages/                          # Screen pages (Menu, Game, Result, History)
├── resources/                          # Windows resource files (.rc, icons)
├── Main.qml                            # Main QML entry point
├── main.cpp                            # C++ application entry point
├── CMakeLists.txt                      # CMake build configuration
├── build_flatpak.sh                    # Flatpak build script (Linux)
├── build_rpm.sh                        # RPM build script (Fedora)
├── make_installer.nsi                  # NSIS installer script (Windows)
└── io.github.aleafarrel.RapidTexter.*  # Linux flatpak packaging files
```

## 📜 License

This project is licensed under the **MIT License**. Free to use, modify, and distribute.

---
<div align="center">
  Developed 2025 by Alea Farrel & Team.
</div>
