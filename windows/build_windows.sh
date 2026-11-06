#!/usr/bin/env bash
# SweePurge Windows Edition Builder
# Compiles portable PE32+ x86_64 GUI standalone executable for Windows 10/11

set -e

PROJECT_DIR="/Users/rmacstudio2/Documents/SweePurge"
WINDOWS_DIR="$PROJECT_DIR/windows"
OUTPUT_EXE="$PROJECT_DIR/SweePurge.exe"
ZIP_OUTPUT="$PROJECT_DIR/SweePurge-Windows.zip"

echo "⚙️ Building Windows Resources (Icons & Manifest)..."
cd "$WINDOWS_DIR/src"
$(go env GOPATH)/bin/go-winres make

echo "🔨 Compiling Standalone Windows GUI Executable (PE32+ x86-64)..."
GOOS=windows GOARCH=amd64 go build -ldflags="-H windowsgui -s -w" -o "$OUTPUT_EXE"

echo "📦 Packaging SweePurge-Windows.zip..."
cd "$PROJECT_DIR"
rm -f "$ZIP_OUTPUT"
zip -j "$ZIP_OUTPUT" "$OUTPUT_EXE"

echo "✅ Windows Build Complete!"
ls -lh "$OUTPUT_EXE" "$ZIP_OUTPUT"
file "$OUTPUT_EXE"
