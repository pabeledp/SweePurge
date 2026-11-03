import Cocoa
import Foundation

class ZeroEmpireApp: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
        runWorkflow()
    }
    
    func runWorkflow() {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
        
        // Load App Icon
        let appIcon = NSImage(contentsOfFile: Bundle.main.path(forResource: "AppIcon", ofType: "icns") ?? "") ?? NSApp.applicationIconImage
        
        // 1. Show Confirmation Dialog
        let alert = NSAlert()
        alert.messageText = "ZeroEmpire: 1-Click System Storage Cleaner"
        alert.informativeText = """
        Do you want to clean unnecessary files and reclaim disk storage?

        ZeroEmpire will safely purge:
        • Adobe Media Cache, Peak Files, Scratch Disks & Auto-Saves
        • Browser Caches (Chrome, Safari, Brave, Arc, Edge, Firefox)
        • System Logs, Diagnostic Crash Reports & QuickLook Caches
        • Time Machine Local Snapshots (Major System Data bloat)
        • Trash & Temporary Files

        Personal documents, browser history, bookmarks, and active projects will remain 100% safe.
        """
        alert.alertStyle = .informational
        if let icon = appIcon {
            alert.icon = icon
        }
        
        alert.addButton(withTitle: "Clean Now (Purge Junk)")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response != .alertFirstButtonReturn {
            exit(0)
        }
        
        // 2. Measure Free Space Before
        let freeBefore = getFreeDiskSpaceBytes()
        
        // 3. Perform Deep Cleanup
        performDeepCleanup(homeDir: homeDir)
        
        // 4. Measure Free Space After
        let freeAfter = getFreeDiskSpaceBytes()
        
        let reclaimedBytes = max(0, freeAfter - freeBefore)
        let reclaimedFormatted = formatBytes(reclaimedBytes)
        
        // 5. Native Notification
        sendNotification(
            title: "ZeroEmpire: Cleanup Completed",
            message: "Successfully reclaimed \(reclaimedFormatted) of disk space!"
        )
        
        // 6. Success Modal
        let successAlert = NSAlert()
        successAlert.messageText = "🎉 Optimization Complete!"
        successAlert.informativeText = """
        ZeroEmpire has successfully cleaned your Mac.

        • Storage Reclaimed: \(reclaimedFormatted)
        • Total Free Disk Space: \(formatBytes(freeAfter))

        Adobe scratch & media caches, browser temporary files, system logs, and local snapshots have been purged.
        """
        successAlert.alertStyle = .informational
        if let icon = appIcon {
            successAlert.icon = icon
        }
        successAlert.addButton(withTitle: "Awesome")
        successAlert.runModal()
        
        exit(0)
    }
    
    func getFreeDiskSpaceBytes() -> Int64 {
        do {
            let values = try URL(fileURLWithPath: "/").resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeAvailableCapacityKey])
            if let available = values.volumeAvailableCapacityForImportantUsage {
                return available
            }
            if let available = values.volumeAvailableCapacity {
                return Int64(available)
            }
        } catch {}
        
        let attrs = try? FileManager.default.attributesOfFileSystem(forPath: "/")
        return attrs?[.systemFreeSize] as? Int64 ?? 0
    }
    
    func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    func performDeepCleanup(homeDir: String) {
        // 1. Adobe Creative Cloud Suite
        let adobePaths = [
            "\(homeDir)/Library/Application Support/Adobe/Common/Media Cache Files",
            "\(homeDir)/Library/Application Support/Adobe/Common/Media Cache",
            "\(homeDir)/Library/Application Support/Adobe/Common/Peak Files",
            "\(homeDir)/Library/Caches/Adobe/CameraRaw/Cache",
            "\(homeDir)/Library/Application Support/Adobe/CameraRaw/Cache",
            "\(homeDir)/Library/Logs/Adobe",
            "\(homeDir)/Library/Application Support/Adobe/CRLogs"
        ]
        
        for path in adobePaths {
            cleanDirectoryContents(path)
        }
        
        // Adobe Auto-Saves & AutoRecover
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Adobe", childPattern: "AutoRecover")
        cleanWildcardSubfolders(base: "\(homeDir)/Documents/Adobe/Premiere Pro", childPattern: "Adobe Premiere Pro Auto-Save")
        cleanWildcardSubfolders(base: "\(homeDir)/Documents/Adobe/After Effects", childPattern: "Adobe After Effects Auto-Save")
        
        // 2. Web Browsers Caches
        let browserCaches = [
            "\(homeDir)/Library/Caches/Google/Chrome",
            "\(homeDir)/Library/Caches/BraveSoftware/Brave-Browser",
            "\(homeDir)/Library/Caches/com.apple.Safari",
            "\(homeDir)/Library/Caches/Microsoft Edge",
            "\(homeDir)/Library/Caches/company.thebrowser.Browser", // Arc
            "\(homeDir)/Library/Caches/Firefox"
        ]
        
        for path in browserCaches {
            cleanDirectoryContents(path)
        }
        
        // 3. User General Caches & Logs
        cleanDirectoryContents("\(homeDir)/Library/Caches")
        cleanDirectoryContents("\(homeDir)/Library/Logs")
        cleanDirectoryContents("\(homeDir)/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("/Library/Logs/DiagnosticReports")
        
        // 4. Developer / Package Manager Caches
        let devCaches = [
            "\(homeDir)/Library/Developer/Xcode/DerivedData",
            "\(homeDir)/Library/Caches/CocoaPods",
            "\(homeDir)/.npm/_cacache",
            "\(homeDir)/.cache/pip",
            "\(homeDir)/Library/Caches/Yarn"
        ]
        for path in devCaches {
            cleanDirectoryContents(path)
        }
        
        // 5. Empty Trash
        cleanDirectoryContents("\(homeDir)/.Trash")
        
        // 6. Time Machine Local Snapshots (Reclaims huge 'System Data')
        purgeTimeMachineLocalSnapshots()
        
        // 7. Reset QuickLook Thumbnail cache
        runProcess(path: "/usr/bin/qlmanage", args: ["-r", "cache"])
        runProcess(path: "/usr/bin/qlmanage", args: ["-r"])
    }
    
    func cleanDirectoryContents(_ path: String) {
        let fm = FileManager.default
        var isDir: ObjCBool = false
        guard fm.fileExists(atPath: path, isDirectory: &isDir), isDir.boolValue else { return }
        
        guard let items = try? fm.contentsOfDirectory(atPath: path) else { return }
        for item in items {
            let itemPath = (path as NSString).appendingPathComponent(item)
            try? fm.removeItem(atPath: itemPath)
        }
    }
    
    func cleanWildcardSubfolders(base: String, childPattern: String) {
        let fm = FileManager.default
        guard let subdirs = try? fm.contentsOfDirectory(atPath: base) else { return }
        
        for subdir in subdirs {
            let subPath = (base as NSString).appendingPathComponent(subdir)
            var isDir: ObjCBool = false
            if fm.fileExists(atPath: subPath, isDirectory: &isDir), isDir.boolValue {
                let target = (subPath as NSString).appendingPathComponent(childPattern)
                if fm.fileExists(atPath: target) {
                    cleanDirectoryContents(target)
                }
            }
        }
    }
    
    func purgeTimeMachineLocalSnapshots() {
        let pipe = Pipe()
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/tmutil")
        process.arguments = ["listlocalsnapshots", "/"]
        process.standardOutput = pipe
        process.standardError = Pipe()
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                let lines = output.components(separatedBy: .newlines)
                for line in lines {
                    let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.contains("com.apple.TimeMachine.") {
                        let parts = trimmed.components(separatedBy: ".")
                        if parts.count >= 4 {
                            let datePart = parts[3]
                            runProcess(path: "/usr/bin/tmutil", args: ["deletelocalsnapshots", datePart])
                        }
                    }
                }
            }
        } catch {}
    }
    
    @discardableResult
    func runProcess(path: String, args: [String]) -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = args
        process.standardOutput = Pipe()
        process.standardError = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus
        } catch {
            return -1
        }
    }
    
    func sendNotification(title: String, message: String) {
        let escapedTitle = title.replacingOccurrences(of: "\"", with: "\\\"")
        let escapedMsg = message.replacingOccurrences(of: "\"", with: "\\\"")
        let script = "display notification \"\(escapedMsg)\" with title \"\(escapedTitle)\""
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
        }
    }
}

// Entry Point
let app = NSApplication.shared
let delegate = ZeroEmpireApp()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
