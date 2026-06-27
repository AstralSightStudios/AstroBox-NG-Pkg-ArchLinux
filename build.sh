#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "==> AstroBox-NG Arch Linux build"
echo "    Project root: $PROJECT_ROOT"

# 检查参数
MODE="${1:-full}"

case "$MODE" in
    "full")
        echo "==> 完整编译模式"
        # Sync sub-repos (skip if already synced)
        echo "==> Checking sub-repos..."
        cd "$PROJECT_ROOT"
        if [ ! -d "src-tauri/modules/app" ] || [ ! -d "web" ]; then
            echo "==> Syncing sub-repos..."
            python3 abtools.py sync
        else
            echo "==> Sub-repos already exist, skipping sync..."
        fi
        
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
        PKGDEST="$SCRIPT_DIR" makepkg -d "${@:2}"
        ;;
        
    "prebuilt")
        echo "==> 预编译模式"
        
        # 检查预编译目录
        PREBUILT_DIR="$PROJECT_ROOT/src-tauri/target/release"
        if [ ! -f "$PREBUILT_DIR/AstroBox-ng" ]; then
            echo "错误：找不到预编译的二进制文件"
            echo "请先运行完整编译：./build.sh full"
            exit 1
        fi
        
        # Create temp build directory
        BUILD_DIR="$SCRIPT_DIR/build-prebuilt"
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR/src"
        
        # Create source symlink
        ln -sf "$PROJECT_ROOT" "$BUILD_DIR/src/AstroBox-NG"
        
        # Copy PKGBUILD.prebuilt to build directory
        cp "$SCRIPT_DIR/PKGBUILD.prebuilt" "$BUILD_DIR/PKGBUILD"
        
        # Build with makepkg
        cd "$BUILD_DIR"
        PREBUILT_DIR="$PREBUILT_DIR" PKGDEST="$SCRIPT_DIR" makepkg -d -f "${@:2}"
        ;;
        
    *)
        echo "用法：$0 {full|prebuilt} [makepkg选项]"
        echo ""
        echo "  full      完整编译并打包（默认）"
        echo "  prebuilt  使用已编译的二进制文件打包（快速测试）"
        exit 1
        ;;
esac

echo "==> Build complete! Package saved to: $SCRIPT_DIR"
