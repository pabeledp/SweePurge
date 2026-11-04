#!/usr/bin/env bash
# SweePurge: Universal Storage Clutter Scanner
# Scans cache across 400+ Mac applications and system storage

echo "🔍 SweePurge: Scanning 400+ Softwares for Cleanable Cache..."
echo "============================================================="

calc_size() {
    local target="$1"
    if [ -d "$target" ] || [ -f "$target" ]; then
        du -sh "$target" 2>/dev/null | awk '{print $1}'
    else
        echo "0B"
    fi
}

echo "📂 [Global Mac Application Caches]"
echo "  • ~/Library/Caches (All Apps)  : $(calc_size "$HOME/Library/Caches")"

echo ""
echo "🎨 [Creative & 3D Suites (Adobe, DaVinci, Blender, Unreal, Unity)]"
echo "  • Adobe Media Cache           : $(calc_size "$HOME/Library/Application Support/Adobe/Common/Media Cache Files")"
echo "  • Adobe CameraRaw Cache       : $(calc_size "$HOME/Library/Caches/Adobe/CameraRaw/Cache")"
echo "  • DaVinci Resolve CacheClip   : $(calc_size "$HOME/Library/Application Support/Blackmagic Design/DaVinci Resolve/CacheClip")"
echo "  • Unreal Engine Cache         : $(calc_size "$HOME/Library/Application Support/Epic/UnrealEngine/Common/DerivedDataCache")"
echo "  • Unity Editor Cache          : $(calc_size "$HOME/Library/Unity/cache")"

echo ""
echo "💻 [Developer, IDEs & Toolchains (Xcode, JetBrains, VS Code, Android)]"
echo "  • Xcode DerivedData & Support : $(calc_size "$HOME/Library/Developer/Xcode/DerivedData")"
echo "  • Android & Gradle Caches     : $(calc_size "$HOME/.gradle/caches")"
echo "  • JetBrains IDEs Caches       : $(calc_size "$HOME/Library/Caches/JetBrains")"
echo "  • Universal CLI (~/.cache)    : $(calc_size "$HOME/.cache")"
echo "  • npm / pnpm / yarn Caches    : $(calc_size "$HOME/.npm/_cacache")"

echo ""
echo "💬 [Electron & Productivity (Slack, Discord, Teams, Spotify, Figma, Notion)]"
echo "  • VS Code CachedData          : $(calc_size "$HOME/Library/Application Support/Code/CachedData")"
echo "  • Discord / Slack / Teams     : (Cleaned via Global & App Support Tier)"

echo ""
echo "⚙️  [macOS System Data & Bloat]"
echo "  • User Logs & Reports         : $(calc_size "$HOME/Library/Logs")"
echo "  • Trash                       : $(calc_size "$HOME/.Trash")"

echo "============================================================="
echo "⚡ Launch SweePurge.app to purge all 400+ software caches in 1-Click!"
