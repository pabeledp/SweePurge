#!/usr/bin/env bash
# ==============================================================================
# SweePurge: Universal System Storage & App Cache Purger (CLI Engine)
# Supports 400+ applications: Creative Suites, 3D, Video, Browsers, IDEs & Dev tools
# ==============================================================================

set -e

echo "🧹 SweePurge: Starting Universal Storage Optimization..."

FREE_BEFORE=$(df -g / | awk 'NR==2 {print $4}')

# 1. GLOBAL USER & SYSTEM CACHES (Covers ALL 400+ apps in ~/Library/Caches)
echo "🧹 Purging Global App Caches (~/Library/Caches)..."
rm -rf "$HOME/Library/Caches/"* 2>/dev/null || true

# 2. ELECTRON & PRODUCTIVITY APPS (VS Code, Cursor, Slack, Discord, Notion, Figma, Spotify, etc.)
echo "🧹 Purging Electron & Desktop Application internal caches..."
find "$HOME/Library/Application Support" -maxdepth 3 \( \
    -name "Cache" -o \
    -name "Code Cache" -o \
    -name "GPUCache" -o \
    -name "DawnCache" -o \
    -name "ShaderCache" -o \
    -name "CachedData" -o \
    -name "blob_storage" \
\) -type d -exec rm -rf {}/* \; 2>/dev/null || true

# 3. PRO VIDEO, 3D & AUDIO CREATIVE SUITES
echo "🧹 Purging Creative Suites (Adobe, DaVinci, Blender, Unreal, Unity)..."
# Adobe
rm -rf "$HOME/Library/Application Support/Adobe/Common/Media Cache Files/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Adobe/Common/Media Cache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Adobe/Common/Peak Files/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Adobe/CameraRaw/Cache/"* 2>/dev/null || true
find "$HOME/Library/Application Support/Adobe" -type d -name "AutoRecover" -exec rm -rf {}/* \; 2>/dev/null || true
find "$HOME/Documents/Adobe/Premiere Pro" -type d -name "Adobe Premiere Pro Auto-Save" -exec rm -rf {}/* \; 2>/dev/null || true
find "$HOME/Documents/Adobe/After Effects" -type d -name "Adobe After Effects Auto-Save" -exec rm -rf {}/* \; 2>/dev/null || true

# DaVinci Resolve
rm -rf "$HOME/Library/Application Support/Blackmagic Design/DaVinci Resolve/CacheClip/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Blackmagic Design/DaVinci Resolve/.gallery/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Blackmagic Design/DaVinci Resolve/ProxyMedia/"* 2>/dev/null || true

# Blender & 3D Tools
find "$HOME/Library/Application Support/Blender" -type d -name "cache" -exec rm -rf {}/* \; 2>/dev/null || true
rm -rf "$HOME/.config/blender/cache/"* 2>/dev/null || true
find "$HOME/Library/Application Support/Maxon" -type d -name "cache" -exec rm -rf {}/* \; 2>/dev/null || true

# Unreal Engine & Unity
rm -rf "$HOME/Library/Caches/com.epicgames.UnrealEngine/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Epic/UnrealEngine/Common/DerivedDataCache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Unity/cache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/com.unity3d.UnityEditor/"* 2>/dev/null || true

# Audio & DAWs
rm -rf "$HOME/Library/Caches/AudioUnitCache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Ableton/Live Database/Cache/"* 2>/dev/null || true
rm -rf "$HOME/Music/Audio Music Apps/Freeze Files/"* 2>/dev/null || true

# 4. DEVELOPER & BUILD TOOLCHAINS
echo "🧹 Purging Developer, IDE & Package Manager caches..."
# Xcode
rm -rf "$HOME/Library/Developer/Xcode/DerivedData/"* 2>/dev/null || true
rm -rf "$HOME/Library/Developer/Xcode/Archives/"* 2>/dev/null || true
rm -rf "$HOME/Library/Developer/Xcode/iOS DeviceSupport/"* 2>/dev/null || true
rm -rf "$HOME/Library/Developer/CoreSimulator/Caches/"* 2>/dev/null || true

# Android Studio & Gradle
rm -rf "$HOME/.gradle/caches/"* 2>/dev/null || true
rm -rf "$HOME/.android/build-cache/"* 2>/dev/null || true

# JetBrains & VS Code
rm -rf "$HOME/Library/Caches/JetBrains/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Code/CachedData/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Cursor/CachedData/"* 2>/dev/null || true

# Universal CLI & Package Managers
rm -rf "$HOME/.cache/"* 2>/dev/null || true
rm -rf "$HOME/.npm/_cacache/"* 2>/dev/null || true
rm -rf "$HOME/.pnpm-store/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Yarn/"* 2>/dev/null || true
rm -rf "$HOME/.bun/install/cache/"* 2>/dev/null || true
rm -rf "$HOME/.composer/cache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Homebrew/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/CocoaPods/"* 2>/dev/null || true
rm -rf "$HOME/.cargo/registry/cache/"* 2>/dev/null || true

# Homebrew cleanup
if command -v brew >/dev/null 2>&1; then
    brew cleanup -s >/dev/null 2>&1 || true
fi

# 5. SYSTEM DATA, LOGS & SNAPSHOTS
echo "🧹 Purging System Logs, QuickLook, Trash & Local Snapshots..."
rm -rf "$HOME/Library/Logs/"* 2>/dev/null || true
rm -rf "$HOME/Library/Logs/DiagnosticReports/"* 2>/dev/null || true
rm -rf "$HOME/.Trash/"* 2>/dev/null || true

if command -v tmutil >/dev/null 2>&1; then
    tmutil listlocalsnapshots / 2>/dev/null | grep 'com.apple.TimeMachine' | while read -r snap; do
        snap_date=$(echo "$snap" | cut -d'.' -f4)
        if [ -n "$snap_date" ]; then
            tmutil deletelocalsnapshots "$snap_date" 2>/dev/null || true
        fi
    done
fi

qlmanage -r cache >/dev/null 2>&1 || true
qlmanage -r >/dev/null 2>&1 || true

FREE_AFTER=$(df -g / | awk 'NR==2 {print $4}')
RECLAIMED=$((FREE_AFTER - FREE_BEFORE))
if [ "$RECLAIMED" -lt 0 ]; then RECLAIMED=0; fi

echo "=========================================="
echo "🎉 Universal Cleanup Complete!"
echo "Reclaimed: ~${RECLAIMED} GB"
echo "Free Disk Space: ${FREE_AFTER} GB"
echo "=========================================="
