package main

import (
	_ "embed"
	"os"
	"os/exec"
	"path/filepath"
	"syscall"
)

//go:embed sweepurge_gui.ps1
var embeddedScript []byte

//go:embed icon.ico
var embeddedIcon []byte

func main() {
	// 1. Ensure dedicated SweePurge AppData directory for persistent icon & assets
	localAppData := os.Getenv("LOCALAPPDATA")
	if localAppData == "" {
		localAppData = os.TempDir()
	}
	appDir := filepath.Join(localAppData, "SweePurge")
	_ = os.MkdirAll(appDir, 0755)

	iconPath := filepath.Join(appDir, "sweepurge_app.ico")
	if len(embeddedIcon) > 0 {
		_ = os.WriteFile(iconPath, embeddedIcon, 0644)
	}

	// 2. Create temporary script file
	tempFile, err := os.CreateTemp(appDir, "sweepurge_*.ps1")
	if err != nil {
		tempFile, err = os.CreateTemp(os.TempDir(), "sweepurge_*.ps1")
		if err != nil {
			return
		}
	}
	tempPath := tempFile.Name()
	defer os.Remove(tempPath)

	// Ensure UTF-8 BOM so PowerShell correctly parses all characters
	bom := []byte{0xEF, 0xBB, 0xBF}
	if len(embeddedScript) < 3 || embeddedScript[0] != 0xEF || embeddedScript[1] != 0xBB || embeddedScript[2] != 0xBF {
		_, _ = tempFile.Write(bom)
	}
	_, _ = tempFile.Write(embeddedScript)
	_ = tempFile.Close()

	// 3. Launch PowerShell executing the temporary script file
	args := []string{
		"-NoProfile",
		"-ExecutionPolicy", "Bypass",
		"-File", tempPath,
	}
	if len(os.Args) > 1 {
		args = append(args, os.Args[1:]...)
	}

	cmd := exec.Command("powershell.exe", args...)
	cmd.SysProcAttr = &syscall.SysProcAttr{
		HideWindow:    true,
		CreationFlags: 0x08000000, // CREATE_NO_WINDOW
	}
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	_ = cmd.Run()
}
