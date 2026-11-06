package main

import (
	_ "embed"
	"os"
	"os/exec"
	"syscall"
)

//go:embed sweepurge_gui.ps1
var embeddedScript string

func main() {
	cmd := exec.Command("powershell.exe",
		"-NoProfile",
		"-NonInteractive",
		"-WindowStyle", "Hidden",
		"-ExecutionPolicy", "Bypass",
		"-Command", embeddedScript,
	)
	cmd.SysProcAttr = &syscall.SysProcAttr{
		HideWindow:    true,
		CreationFlags: 0x08000000, // CREATE_NO_WINDOW
	}
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	_ = cmd.Run()
}
