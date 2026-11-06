#!/usr/bin/env bash
# Packages SweePurge.app into an easy-to-share SweePurge.dmg installer
# Generates Universal 2 binary supporting macOS 10.15+ (Intel & Apple Silicon M1-M5)

set -e

PROJECT_DIR="/Users/rmacstudio2/Documents/SweePurge"
DMG_DIR="$PROJECT_DIR/build_dmg"
DMG_OUTPUT="$PROJECT_DIR/SweePurge.dmg"
APP_PATH="$PROJECT_DIR/SweePurge.app"
ICON_PATH="$PROJECT_DIR/assets/icon_1024.png"
ICNS_PATH="$PROJECT_DIR/assets/AppIcon.icns"

echo "⚙️ Compiling Universal 2 Binary (macOS 10.15+ to Latest, Intel + Apple Silicon)..."
mkdir -p "$APP_PATH/Contents/MacOS" "$APP_PATH/Contents/Resources"

# 1. Compile for Apple Silicon (macOS 11.0+)
swiftc -O "$PROJECT_DIR/src/main.swift" -target arm64-apple-macos11.0 -o /tmp/SweePurge_arm64

# 2. Compile for Intel Macs (macOS 10.15+)
swiftc -O "$PROJECT_DIR/src/main.swift" -target x86_64-apple-macos10.15 -o /tmp/SweePurge_x86_64

# 3. Combine into Universal 2 binary
lipo -create /tmp/SweePurge_arm64 /tmp/SweePurge_x86_64 -output "$APP_PATH/Contents/MacOS/SweePurge"
rm -f /tmp/SweePurge_arm64 /tmp/SweePurge_x86_64

# Copy Info.plist and AppIcon
cp "$PROJECT_DIR/src/Info.plist" "$APP_PATH/Contents/Info.plist"
cp "$ICNS_PATH" "$APP_PATH/Contents/Resources/AppIcon.icns"

# Clean extended attributes & sign
xattr -cr "$APP_PATH"
codesign --force --deep --sign - "$APP_PATH"

# Bind custom icon to app bundle
swift -e "
import Cocoa
let appPath = \"$APP_PATH\"
let iconPath = \"$ICON_PATH\"
if let img = NSImage(contentsOfFile: iconPath) {
    _ = NSWorkspace.shared.setIcon(img, forFile: appPath, options: [])
}
"

echo "📦 Creating SweePurge.dmg installer..."
hdiutil detach /Volumes/SweePurge* 2>/dev/null || true
rm -rf "$DMG_DIR" "$DMG_OUTPUT"
mkdir -p "$DMG_DIR"

# Copy App to staging dir
cp -R "$APP_PATH" "$DMG_DIR/"

# Create symlink to /Applications for standard drag-and-drop installer UX
ln -s /Applications "$DMG_DIR/Applications"

# Set volume icon inside DMG
if [ -f "$ICNS_PATH" ]; then
    cp "$ICNS_PATH" "$DMG_DIR/.VolumeIcon.icns"
    if command -v SetFile >/dev/null 2>&1; then
        SetFile -a C "$DMG_DIR" 2>/dev/null || true
    fi
fi

# Create disk image
hdiutil create -volname "SweePurge" -srcfolder "$DMG_DIR" -ov -format UDZO "$DMG_OUTPUT"

rm -rf "$DMG_DIR"

# Apply custom icon to the .dmg file itself
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
touch "$APP_PATH"
qlmanage -r cache 2>/dev/null || true
qlmanage -r 2>/dev/null || true

echo "✅ Successfully built Universal SweePurge: $DMG_OUTPUT"
ls -lh "$DMG_OUTPUT"
lipo -info "$APP_PATH/Contents/MacOS/SweePurge"
