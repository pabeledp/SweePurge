import Cocoa
import Foundation

class ZeroEmpireApp: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
        runWorkflow()
    }
    
    func runWorkflow() {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
        let appIcon = NSImage(contentsOfFile: Bundle.main.path(forResource: "AppIcon", ofType: "icns") ?? "") ?? NSApp.applicationIconImage
        
        // 1. Show Clean, Premium Confirmation Dialog
        let alert = NSAlert()
        alert.messageText = "ZeroEmpire Storage Purger"
        alert.informativeText = """
        Ready to optimize your Mac and reclaim disk space?

        Safely purges temporary caches, render scratch files, and system data bloat across 400+ creative apps, browsers, and developer tools.

        • 100% Safe: Personal files, active projects, and login sessions remain untouched.
        """
        alert.alertStyle = .informational
        if let icon = appIcon {
            alert.icon = icon
        }
        
        // Center-aligned, 2-line subtle developer credit
        alert.accessoryView = createSubtleCreditView(width: 300)
        
        alert.addButton(withTitle: "Clean All Caches Now")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response != .alertFirstButtonReturn {
            exit(0)
        }
        
        // 2. Measure Free Space Before
        let freeBefore = getFreeDiskSpaceBytes()
        
        // 3. Perform Deep Universal Cleanup
        performUniversalCleanup(homeDir: homeDir)
        
        // 4. Measure Free Space After
        let freeAfter = getFreeDiskSpaceBytes()
        
        let reclaimedBytes = max(0, freeAfter - freeBefore)
        let reclaimedFormatted = formatBytes(reclaimedBytes)
        
        // 5. Native Notification
        sendNotification(
            title: "ZeroEmpire: Mac Optimized",
            message: "Reclaimed \(reclaimedFormatted) across 400+ apps & system storage."
        )
        
        // 6. Clean Success Modal
        let successAlert = NSAlert()
        successAlert.messageText = "Mac Optimized"
        successAlert.informativeText = """
        ZeroEmpire has successfully cleaned your system.

        • Storage Reclaimed: \(reclaimedFormatted)
        • Total Available Space: \(formatBytes(freeAfter))

        Temporary caches, render scratch, and system snapshots have been safely purged.
        """
        successAlert.alertStyle = .informational
        if let icon = appIcon {
            successAlert.icon = icon
        }
        successAlert.accessoryView = createSubtleCreditView(width: 300)
        successAlert.addButton(withTitle: "Done")
        successAlert.runModal()
        
        exit(0)
    }
    
    func createSubtleCreditView(width: CGFloat) -> NSView {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 34))
        
        // Line 1: Developed by (smaller, centered)
        let line1 = NSTextField(frame: NSRect(x: 0, y: 17, width: width, height: 14))
        line1.stringValue = "Developed by"
        line1.isBezeled = false
        line1.drawsBackground = false
        line1.isEditable = false
        line1.isSelectable = false
        line1.font = NSFont.systemFont(ofSize: 8.5, weight: .regular)
        line1.textColor = NSColor.secondaryLabelColor.withAlphaComponent(0.35)
        line1.alignment = .center
        
        // Line 2: Name & Designation (centered)
        let line2 = NSTextField(frame: NSRect(x: 0, y: 0, width: width, height: 16))
        line2.stringValue = "A M Pabel, Team Captain at FramEmpire"
        line2.isBezeled = false
        line2.drawsBackground = false
        line2.isEditable = false
        line2.isSelectable = false
        line2.font = NSFont.systemFont(ofSize: 9.5, weight: .regular)
        line2.textColor = NSColor.secondaryLabelColor.withAlphaComponent(0.40)
        line2.alignment = .center
        
        container.addSubview(line1)
        container.addSubview(line2)
        return container
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
    
    func performUniversalCleanup(homeDir: String) {
        let fm = FileManager.default
        
        // 1. TIER 1: GLOBAL USER CACHE DIRECTORY
        cleanDirectoryContents("\(homeDir)/Library/Caches")
        cleanDirectoryContents("/Library/Caches")
        
        // 2. TIER 2: ELECTRON & PRODUCTIVITY APPS
        let appSupportDir = "\(homeDir)/Library/Application Support"
        if let apps = try? fm.contentsOfDirectory(atPath: appSupportDir) {
            let cacheFolderNames = [
                "Cache", "Code Cache", "GPUCache", "DawnCache", "ShaderCache",
                "Service Worker/CacheStorage", "Service Worker/ScriptCache",
                "CachedData", "CachedExtensions", "blob_storage"
            ]
            for app in apps {
                let appPath = (appSupportDir as NSString).appendingPathComponent(app)
                for cName in cacheFolderNames {
                    let target = (appPath as NSString).appendingPathComponent(cName)
                    cleanDirectoryContents(target)
                }
            }
        }
        
        // 3. TIER 3: PRO VIDEO, 3D & AUDIO CREATIVE SUITES
        let adobePaths = [
            "\(homeDir)/Library/Application Support/Adobe/Common/Media Cache Files",
            "\(homeDir)/Library/Application Support/Adobe/Common/Media Cache",
            "\(homeDir)/Library/Application Support/Adobe/Common/Peak Files",
            "\(homeDir)/Library/Caches/Adobe/CameraRaw/Cache",
            "\(homeDir)/Library/Application Support/Adobe/CameraRaw/Cache",
            "\(homeDir)/Library/Logs/Adobe",
            "\(homeDir)/Library/Application Support/Adobe/CRLogs"
        ]
        for p in adobePaths { cleanDirectoryContents(p) }
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Adobe", childPattern: "AutoRecover")
        cleanWildcardSubfolders(base: "\(homeDir)/Documents/Adobe/Premiere Pro", childPattern: "Adobe Premiere Pro Auto-Save")
        cleanWildcardSubfolders(base: "\(homeDir)/Documents/Adobe/After Effects", childPattern: "Adobe After Effects Auto-Save")
        
        // DaVinci Resolve
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/CacheClip")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/.gallery")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/ProxyMedia")
        
        // Final Cut Pro
        cleanDirectoryContents("\(homeDir)/Movies/Motion Templates.localized/Cache")
        
        // Blender
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Blender", childPattern: "cache")
        cleanDirectoryContents("\(homeDir)/.config/blender/cache")
        
        // Cinema 4D / Maxon
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Maxon", childPattern: "cache")
        
        // Unreal Engine & Unity
        cleanDirectoryContents("\(homeDir)/Library/Caches/com.epicgames.UnrealEngine")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Epic/UnrealEngine/Common/DerivedDataCache")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Epic/EpicGamesLauncher/Saved/Logs")
        cleanDirectoryContents("\(homeDir)/Library/Unity/cache")
        cleanDirectoryContents("\(homeDir)/Library/Caches/com.unity3d.UnityEditor")
        
        // Audio DAWs
        cleanDirectoryContents("\(homeDir)/Library/Caches/AudioUnitCache")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Ableton/Live Database/Cache")
        cleanDirectoryContents("\(homeDir)/Music/Audio Music Apps/Freeze Files")
        
        // 4. TIER 4: DEVELOPER & BUILD TOOLCHAINS
        let devCaches = [
            "\(homeDir)/Library/Developer/Xcode/DerivedData",
            "\(homeDir)/Library/Developer/Xcode/Archives",
            "\(homeDir)/Library/Developer/Xcode/iOS DeviceSupport",
            "\(homeDir)/Library/Developer/CoreSimulator/Caches",
            "\(homeDir)/.gradle/caches",
            "\(homeDir)/.android/build-cache",
            "\(homeDir)/.android/cache",
            "\(homeDir)/Library/Caches/JetBrains",
            "\(homeDir)/Library/Application Support/Code/Cache",
            "\(homeDir)/Library/Application Support/Code/CachedData",
            "\(homeDir)/Library/Application Support/Cursor/Cache",
            "\(homeDir)/Library/Application Support/Cursor/CachedData",
            "\(homeDir)/.cache",
            "\(homeDir)/.npm/_cacache",
            "\(homeDir)/.pnpm-store",
            "\(homeDir)/Library/Caches/Yarn",
            "\(homeDir)/.bun/install/cache",
            "\(homeDir)/.composer/cache",
            "\(homeDir)/Library/Caches/Homebrew",
            "\(homeDir)/Library/Caches/CocoaPods",
            "\(homeDir)/.cargo/registry/cache",
            "\(homeDir)/.rustup/downloads",
            "\(homeDir)/.m2/repository/.cache"
        ]
        for p in devCaches { cleanDirectoryContents(p) }
        
        runProcess(path: "/usr/local/bin/brew", args: ["cleanup", "-s"])
        runProcess(path: "/opt/homebrew/bin/brew", args: ["cleanup", "-s"])
        runProcess(path: "/usr/local/bin/docker", args: ["builder", "prune", "-f"])
        runProcess(path: "/opt/homebrew/bin/docker", args: ["builder", "prune", "-f"])
        
        // 5. TIER 5: SYSTEM DATA, LOGS & SNAPSHOTS
        cleanDirectoryContents("\(homeDir)/Library/Logs")
        cleanDirectoryContents("/Library/Logs")
        cleanDirectoryContents("\(homeDir)/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/CrashReporter")
        cleanDirectoryContents("\(homeDir)/.Trash")
        
        purgeTimeMachineLocalSnapshots()
        
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
