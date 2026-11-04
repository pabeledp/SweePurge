#!/usr/bin/env bash
# Packages SweePurge.app into an easy-to-share SweePurge.dmg installer with custom icon

set -e

PROJECT_DIR="/Users/rmacstudio2/Documents/SweePurge"
DMG_DIR="$PROJECT_DIR/build_dmg"
DMG_OUTPUT="$PROJECT_DIR/SweePurge.dmg"
APP_PATH="$PROJECT_DIR/SweePurge.app"
ICON_PATH="$PROJECT_DIR/assets/icon_1024.png"
ICNS_PATH="$PROJECT_DIR/assets/AppIcon.icns"

echo "📦 Creating SweePurge.dmg installer..."
rm -rf "$DMG_DIR" "$DMG_OUTPUT"
mkdir -p "$DMG_DIR"

# Copy App to staging dir
cp -R "$APP_PATH" "$DMG_DIR/"

# Create symlink to /Applications for standard drag-and-drop installer UX
ln -s /Applications "$DMG_DIR/Applications"

# Set volume icon inside DMG if available
if [ -f "$ICNS_PATH" ]; then
    cp "$ICNS_PATH" "$DMG_DIR/.VolumeIcon.icns"
    if command -v SetFile >/dev/null 2>&1; then
        SetFile -a C "$DMG_DIR" 2>/dev/null || true
    fi
fi

# Create disk image
hdiutil create -volname "SweePurge" -srcfolder "$DMG_DIR" -ov -format UDZO "$DMG_OUTPUT"

rm -rf "$DMG_DIR"

# Automatically apply custom icon to the .dmg file itself
swift -e "
import Cocoa
let dmgPath = \"$DMG_OUTPUT\"
let iconPath = \"$ICON_PATH\"
if let img = NSImage(contentsOfFile: iconPath) {
    let success = NSWorkspace.shared.setIcon(img, forFile: dmgPath, options: [])
    print(\"Applied custom icon to .dmg:\", success)
}
"

touch "$DMG_OUTPUT"
qlmanage -r cache 2>/dev/null || true
qlmanage -r 2>/dev/null || true

echo "✅ Successfully built and branded: $DMG_OUTPUT"
ls -lh "$DMG_OUTPUT"
