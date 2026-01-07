#!/bin/bash
set -e

# --- 1. Konfigurasi ---
APP_NAME="rapidtexter"
VERSION="1.0.0"
# Debian menggunakan istilah 'amd64' untuk 64-bit, bukan 'x86_64'
ARCH="amd64" 
BUILD_DIR="build-deb"
DEB_ROOT="deb-package-root"

# Cek apakah dpkg-deb terinstall
if ! command -v dpkg-deb &> /dev/null; then
    echo "Error: 'dpkg-deb' tidak ditemukan."
    echo "Jika Anda di Fedora, install dengan: sudo dnf install dpkg"
    echo "Jika di Ubuntu/Debian, ini sudah terinstall otomatis."
    exit 1
fi

# Pastikan di root project
if [ ! -f "CMakeLists.txt" ]; then
    echo "Error: Jalankan script ini dari root directory project."
    exit 1
fi

echo "--- 1. Membersihkan build lama ---"
rm -rf $BUILD_DIR $DEB_ROOT
mkdir -p $BUILD_DIR

# --- 2. Build Aplikasi ---
echo "--- 2. Membangun Aplikasi ---"
cd $BUILD_DIR

cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release

make -j$(nproc)
cd ..

# --- 3. Menyiapkan Struktur Folder DEB ---
echo "--- 3. Menyiapkan Struktur Folder ---"
# Struktur DEB membutuhkan folder 'DEBIAN' (huruf besar) untuk metadata
mkdir -p $DEB_ROOT/DEBIAN
mkdir -p $DEB_ROOT/usr/bin
mkdir -p $DEB_ROOT/usr/share/applications
mkdir -p $DEB_ROOT/usr/share/icons/hicolor/256x256/apps

# Copy Binary
if [ -f "$BUILD_DIR/RapidTexterGUI" ]; then
    cp "$BUILD_DIR/RapidTexterGUI" "$DEB_ROOT/usr/bin/$APP_NAME"
elif [ -f "$BUILD_DIR/rapidtexter-gui" ]; then
    cp "$BUILD_DIR/rapidtexter-gui" "$DEB_ROOT/usr/bin/$APP_NAME"
else
    echo "Error: Binary tidak ditemukan!"
    exit 1
fi
chmod +x "$DEB_ROOT/usr/bin/$APP_NAME"

# Copy Icon
cp resources/app_icon.png "$DEB_ROOT/usr/share/icons/hicolor/256x256/apps/rapidtexter.png"

# Buat Desktop File
cat > "$DEB_ROOT/usr/share/applications/$APP_NAME.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Rapid Texter
Comment=Typing practice application
Exec=$APP_NAME
Icon=rapidtexter
Categories=Game;Education;
Terminal=false
EOF

# --- 4. Membuat Control File (Metadata DEB) ---
echo "--- 4. Membuat Control File ---"
# Dependencies di sini menggunakan nama paket Debian/Ubuntu
cat > $DEB_ROOT/DEBIAN/control <<EOF
Package: $APP_NAME
Version: $VERSION
Section: education
Priority: optional
Architecture: $ARCH
Depends: libc6, libstdc++6, libqt6gui6, libqt6widgets6, libqt6qml6, qml6-module-qtquick, qml6-module-qtquick-controls, qml6-module-qtquick-layouts
Maintainer: Alea Farrel <your-email@example.com>
Description: Typing practice application
 RapidTexter is a typing practice application built with Qt/QML designed for speed and efficiency.
EOF

# --- 5. Build DEB ---
echo "--- 5. Membungkus DEB ---"
dpkg-deb --build $DEB_ROOT "${APP_NAME}_${VERSION}_${ARCH}.deb"

echo "-----------------------------------------------------"
echo "SUKSES! File DEB Anda siap:"
ls -lh "${APP_NAME}_${VERSION}_${ARCH}.deb"
echo "-----------------------------------------------------"