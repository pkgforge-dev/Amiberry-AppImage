#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake      \
    enet \
    flac \
    hicolor-icon-theme \
    libpcap \
    libserialport \
    mpg123 \
    nlohmann-json \
    portmidi \
    sdl3_image \
    sdl3_ttf   \
    tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package amiberry

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
echo "Building stable version of Amiberry..."
echo "---------------------------------------------------------------"
REPO="https://github.com/BlitterStudio/amiberry"
VERSION="$(curl -s https://api.github.com/repos/BlitterStudio/amiberry/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
git clone --recursive --depth 1 "$REPO" ./amiberry
echo "$VERSION" > ~/version

if [ "$ARCH" = "aarch64" ]; then
else
fi

mkdir -p ./AppDir/bin/data
cd ./amiberry
cmake -S ./ -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v build/amiberry roms whdboot ../AppDir/bin
mv -v data/abr floppy_soundsdata ../AppDir/bin/data
