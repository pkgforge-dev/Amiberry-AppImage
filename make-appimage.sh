#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/BlitterStudio/amiberry/refs/heads/master/packaging/linux/icons/256x256/amiberry.png
export DESKTOP=https://raw.githubusercontent.com/BlitterStudio/amiberry/refs/heads/master/packaging/linux/Amiberry.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
ln -s ./AppDir/bin/libcapsimage.so ./AppDir/bin/capsimg.so
quick-sharun ./AppDir/bin/*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
