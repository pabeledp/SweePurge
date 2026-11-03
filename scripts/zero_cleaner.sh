#!/usr/bin/env bash
# ==============================================================================
# ZeroEmpire: 1-Click System Storage & Cache Purger (CLI Engine)
# Safely frees up gigabytes of Mac storage consumed by Adobe, Browsers & System
# ==============================================================================

set -e

echo "👑 ZeroEmpire: Starting storage optimization..."

# Measure initial free disk space in Gigabytes
FREE_BEFORE=$(df -g / | awk 'NR==2 {print $4}')

# 1. Adobe Creative Cloud
echo "🧹 Purging Adobe Media Caches & Auto-Saves..."
rm -rf "$HOME/Library/Application Support/Adobe/Common/Media Cache Files/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Adobe/Common/Media Cache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Adobe/Common/Peak Files/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Adobe/CameraRaw/Cache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Adobe/CameraRaw/Cache/"* 2>/dev/null || true
rm -rf "$HOME/Library/Logs/Adobe/"* 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Adobe/CRLogs/"* 2>/dev/null || true

# Adobe AutoRecover & Auto-Save subfolders
find "$HOME/Library/Application Support/Adobe" -type d -name "AutoRecover" -exec rm -rf {}/* \; 2>/dev/null || true
find "$HOME/Documents/Adobe/Premiere Pro" -type d -name "Adobe Premiere Pro Auto-Save" -exec rm -rf {}/* \; 2>/dev/null || true
find "$HOME/Documents/Adobe/After Effects" -type d -name "Adobe After Effects Auto-Save" -exec rm -rf {}/* \; 2>/dev/null || true

# 2. Web Browsers
echo "🧹 Purging Web Browser caches..."
rm -rf "$HOME/Library/Caches/Google/Chrome/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/BraveSoftware/Brave-Browser/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/com.apple.Safari/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/company.thebrowser.Browser/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Microsoft Edge/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Firefox/"* 2>/dev/null || true

# 3. macOS System & Logs
echo "🧹 Purging User Caches & System Logs..."
rm -rf "$HOME/Library/Caches/"* 2>/dev/null || true
rm -rf "$HOME/Library/Logs/"* 2>/dev/null || true
rm -rf "$HOME/Library/Logs/DiagnosticReports/"* 2>/dev/null || true

# 4. Developer / Package Manager Caches
echo "🧹 Purging Developer caches..."
rm -rf "$HOME/Library/Developer/Xcode/DerivedData/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/CocoaPods/"* 2>/dev/null || true
rm -rf "$HOME/.npm/_cacache/"* 2>/dev/null || true
rm -rf "$HOME/.cache/pip/"* 2>/dev/null || true
rm -rf "$HOME/Library/Caches/Yarn/"* 2>/dev/null || true

# 5. Empty User Trash
echo "🧹 Emptying Trash..."
rm -rf "$HOME/.Trash/"* 2>/dev/null || true

# 6. Time Machine Local Snapshots
echo "🧹 Pruning Time Machine local snapshots..."
if command -v tmutil >/dev/null 2>&1; then
    tmutil listlocalsnapshots / 2>/dev/null | grep 'com.apple.TimeMachine' | while read -r snap; do
        snap_date=$(echo "$snap" | cut -d'.' -f4)
        if [ -n "$snap_date" ]; then
            tmutil deletelocalsnapshots "$snap_date" 2>/dev/null || true
        fi
    done
fi

# 7. QuickLook Thumbnails
echo "🧹 Refreshing QuickLook cache..."
qlmanage -r cache >/dev/null 2>&1 || true
qlmanage -r >/dev/null 2>&1 || true

# Measure free disk space after
FREE_AFTER=$(df -g / | awk 'NR==2 {print $4}')
RECLAIMED=$((FREE_AFTER - FREE_BEFORE))

if [ "$RECLAIMED" -lt 0 ]; then
    RECLAIMED=0
fi

echo "=========================================="
echo "🎉 Cleanup Completed Successfully!"
echo "Reclaimed: ~${RECLAIMED} GB"
echo "Free Disk Space: ${FREE_AFTER} GB"
echo "=========================================="
