#!/usr/bin/env bash
# ZeroEmpire: Storage Clutter Scanner
# Shows exact size of cleanable caches and temporary files

echo "🔍 Scanning Mac for cleanable clutter..."
echo "=========================================="

calc_size() {
    local target="$1"
    if [ -d "$target" ] || [ -f "$target" ]; then
        du -sh "$target" 2>/dev/null | awk '{print $1}'
    else
        echo "0B"
    fi
}

echo "📂 [Adobe Creative Cloud]"
echo "  • Media Cache Files : $(calc_size "$HOME/Library/Application Support/Adobe/Common/Media Cache Files")"
echo "  • Media Cache       : $(calc_size "$HOME/Library/Application Support/Adobe/Common/Media Cache")"
echo "  • Peak Files        : $(calc_size "$HOME/Library/Application Support/Adobe/Common/Peak Files")"
echo "  • CameraRaw Cache   : $(calc_size "$HOME/Library/Caches/Adobe/CameraRaw/Cache")"

echo ""
echo "🌐 [Web Browsers]"
echo "  • Google Chrome     : $(calc_size "$HOME/Library/Caches/Google/Chrome")"
echo "  • Brave Browser     : $(calc_size "$HOME/Library/Caches/BraveSoftware/Brave-Browser")"
echo "  • Safari Cache      : $(calc_size "$HOME/Library/Caches/com.apple.Safari")"
echo "  • Arc Browser       : $(calc_size "$HOME/Library/Caches/company.thebrowser.Browser")"
echo "  • Microsoft Edge    : $(calc_size "$HOME/Library/Caches/Microsoft Edge")"

echo ""
echo "⚙️  [macOS System & Logs]"
echo "  • User Caches       : $(calc_size "$HOME/Library/Caches")"
echo "  • User Logs         : $(calc_size "$HOME/Library/Logs")"
echo "  • Trash             : $(calc_size "$HOME/.Trash")"

echo ""
echo "🛠️  [Developer / Tooling Caches]"
echo "  • Xcode DerivedData : $(calc_size "$HOME/Library/Developer/Xcode/DerivedData")"
echo "  • CocoaPods Cache   : $(calc_size "$HOME/Library/Caches/CocoaPods")"
echo "  • npm Cache         : $(calc_size "$HOME/.npm/_cacache")"
echo "  • pip Cache         : $(calc_size "$HOME/.cache/pip")"

echo "=========================================="
echo "⚡ Launch ZeroEmpire.app to purge all this clutter with 1 click!"
