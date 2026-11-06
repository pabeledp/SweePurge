#!/usr/bin/env bash
# SweePurge Windows Edition Builder
# Compiles portable PE32+ x86_64 GUI standalone executable for Windows 10/11

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WINDOWS_DIR="$PROJECT_DIR/windows"
OUTPUT_EXE="$PROJECT_DIR/SweePurge.exe"
ZIP_OUTPUT="$PROJECT_DIR/SweePurge-Windows.zip"

echo "⚙️ Building Windows Resources (Icons & Manifest)..."
cd "$WINDOWS_DIR/src"
if command -v go-winres >/dev/null 2>&1; then
    go-winres make
elif [ -f "$(go env GOPATH)/bin/go-winres" ]; then
    $(go env GOPATH)/bin/go-winres make
else
    echo "Notice: using pre-generated syso resources."
fi

echo "🔨 Compiling Standalone Windows GUI Executable (PE32+ x86-64)..."
GOOS=windows GOARCH=amd64 go build -ldflags="-H windowsgui -s -w" -o "$OUTPUT_EXE"

echo "📦 Packaging SweePurge-Windows.zip..."
cd "$PROJECT_DIR"
rm -f "$ZIP_OUTPUT"
if command -v zip >/dev/null 2>&1; then
    zip -j "$ZIP_OUTPUT" "$OUTPUT_EXE"
fi

echo "✅ Windows Build Complete!"
ls -lh "$OUTPUT_EXE" "$ZIP_OUTPUT" 2>/dev/null || ls -lh "$OUTPUT_EXE"
file "$OUTPUT_EXE" 2>/dev/null || true
