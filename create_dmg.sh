#!/usr/bin/env bash
# Packages ZeroEmpire.app into an easy-to-share ZeroEmpire.dmg installer

set -e

DMG_DIR="/Users/rmacstudio2/Documents/ZeroEmpire/build_dmg"
DMG_OUTPUT="/Users/rmacstudio2/Documents/ZeroEmpire/ZeroEmpire.dmg"
APP_PATH="/Users/rmacstudio2/Documents/ZeroEmpire/ZeroEmpire.app"

echo "📦 Creating ZeroEmpire.dmg installer..."
rm -rf "$DMG_DIR" "$DMG_OUTPUT"
mkdir -p "$DMG_DIR"

# Copy App to staging dir
cp -R "$APP_PATH" "$DMG_DIR/"

# Create symlink to /Applications for standard drag-and-drop installer UX
ln -s /Applications "$DMG_DIR/Applications"

# Create disk image
hdiutil create -volname "ZeroEmpire" -srcfolder "$DMG_DIR" -ov -format UDZO "$DMG_OUTPUT"

rm -rf "$DMG_DIR"

echo "✅ Successfully built: $DMG_OUTPUT"
ls -lh "$DMG_OUTPUT"
