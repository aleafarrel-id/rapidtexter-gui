#!/bin/bash
set -e

# --- Konfigurasi ---
APP_ID="io.github.aleafarrel.RapidTexter"
FLATPAK_DIR="flatpak-build"
REPO_DIR="flatpak-repo"
BUNDLE_NAME="rapidtexter.flatpak"

echo "========================================"
echo " RapidTexter Flatpak Builder"
echo "========================================"

# --- 1. Cek Dependencies ---
echo ""
echo "--- 1. Mengecek dependencies ---"

if ! command -v flatpak &> /dev/null; then
    echo "Error: 'flatpak' tidak ditemukan."
    echo "Silakan install dengan:"
    echo "  Fedora:  sudo dnf install flatpak"
    echo "  Ubuntu:  sudo apt install flatpak"
    echo "  Arch:    sudo pacman -S flatpak"
    exit 1
fi

if ! command -v flatpak-builder &> /dev/null; then
    echo "Error: 'flatpak-builder' tidak ditemukan."
    echo "Silakan install dengan:"
    echo "  Fedora:  sudo dnf install flatpak-builder"
    echo "  Ubuntu:  sudo apt install flatpak-builder"
    echo "  Arch:    sudo pacman -S flatpak-builder"
    exit 1
fi

# Pastikan di root project
if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: Jalankan script ini dari root directory project."
    exit 1
fi

# --- 2. Setup Flatpak Runtime & SDK ---
echo ""
echo "--- 2. Menginstall runtime dan SDK (jika belum ada) ---"

# Add Flathub repository if not exists
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install KDE Platform and SDK (Qt6)
echo "Menginstall org.kde.Platform dan org.kde.Sdk 6.8..."
flatpak install --user -y flathub org.kde.Platform//6.8 org.kde.Sdk//6.8 || true

# --- 3. Membersihkan build lama ---
echo ""
echo "--- 3. Membersihkan build lama ---"
rm -rf "$FLATPAK_DIR" "$REPO_DIR" "$BUNDLE_NAME"

# --- 4. Build Flatpak ---
echo ""
echo "--- 4. Membangun Flatpak ---"
flatpak-builder \
    --user \
    --force-clean \
    --install-deps-from=flathub \
    --repo="$REPO_DIR" \
    "$FLATPAK_DIR" \
    "$APP_ID.yml"

# --- 5. Buat Bundle ---
echo ""
echo "--- 5. Membuat bundle .flatpak ---"
flatpak build-bundle "$REPO_DIR" "$BUNDLE_NAME" "$APP_ID"

echo ""
echo "========================================"
echo " SUKSES!"
echo "========================================"
echo ""
echo "File Flatpak: $BUNDLE_NAME"
echo ""
echo "Untuk menginstall:"
echo "  flatpak install --user $BUNDLE_NAME"
echo ""
echo "Untuk menjalankan:"
echo "  flatpak run $APP_ID"
echo ""
echo "Untuk menghapus:"
echo "  flatpak uninstall $APP_ID"
echo ""
