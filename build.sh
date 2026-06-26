#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "==> AstroBox-NG Arch Linux build"
echo "    Project root: $PROJECT_ROOT"

# Sync sub-repos
echo "==> Syncing sub-repos..."
cd "$PROJECT_ROOT"
python3 abtools.py sync

# Create temp build directory
BUILD_DIR="$SCRIPT_DIR/build"
mkdir -p "$BUILD_DIR/src"

# Create source symlink in src directory
if [ ! -L "$BUILD_DIR/src/AstroBox-NG" ]; then
    ln -sf "$PROJECT_ROOT" "$BUILD_DIR/src/AstroBox-NG"
fi

# Copy PKGBUILD.local to build directory
cp "$SCRIPT_DIR/PKGBUILD.local" "$BUILD_DIR/PKGBUILD"

# Build with makepkg
cd "$BUILD_DIR"
PKGDEST="$SCRIPT_DIR" makepkg -d "$@"

echo "==> Build complete! Package saved to: $SCRIPT_DIR"
