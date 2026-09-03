#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake              \
    enet               \
    hicolor-icon-theme \
    libmpeg2           \
    libserialport      \
    nlohmann-json      \
    portmidi           \
    sdl3_image         \
    sdl3_ttf           \
    tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building stable version of Amiberry..."
echo "---------------------------------------------------------------"
REPO="https://github.com/BlitterStudio/amiberry"
VERSION="$(curl -s https://api.github.com/repos/BlitterStudio/amiberry/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
git clone --recursive --depth 1 "$REPO" ./amiberry
VERSIONNV="${VERSION#v}"
echo "$VERSIONNV" > ~/version

mkdir -p ./AppDir/bin/data
# Always fetch the qemu-uae release matching the architecture
if [ "$ARCH" = "aarch64" ]; then
    QEMU_URL="https://github.com/BlitterStudio/amiberry-qemu-uae/releases/download/v11.0.1-amiberry.7/qemu-uae-linux-aarch64.tar.xz"
else
    QEMU_URL="https://github.com/BlitterStudio/amiberry-qemu-uae/releases/download/v11.0.1-amiberry.7/qemu-uae-linux-x86_64.tar.xz"
fi
curl -L -o qemu-uae.tar.xz "$QEMU_URL"
tar -xJf qemu-uae.tar.xz -C ./AppDir/bin
rm -f qemu-uae.tar.xz

cd ./amiberry
git checkout "$VERSION"
cmake -S ./ -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v build/amiberry roms whdboot build/external/capsimage/libcapsimage.so build/external/floppybridge/libfloppybridge.so  ../AppDir/bin
mv -v data/abr data/floppy_sounds ../AppDir/bin/data
