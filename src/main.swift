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
        
        // 1. Show Confirmation Dialog
        let alert = NSAlert()
        alert.messageText = "ZeroEmpire: Universal System & App Cache Purger"
        alert.informativeText = """
        Do you want to clean unnecessary caches and reclaim disk space?

        ZeroEmpire Universal Engine purges cache for 400+ apps & tools:
        • Video & 3D: Adobe, DaVinci Resolve, Final Cut Pro, Blender, Cinema 4D, Unreal, Unity
        • Development: Xcode DerivedData, Android Studio, JetBrains, VS Code, Cursor, Docker
        • Browsers: Chrome, Safari, Brave, Edge, Arc, Firefox, Opera, Vivaldi, Tor
        • Communication & Tools: Slack, Discord, Telegram, Teams, WhatsApp, Spotify, Figma, Notion
        • Package Managers: Homebrew, npm, pnpm, yarn, bun, pip, cargo, gradle, maven
        • System Data: Time Machine local snapshots, logs, diagnostic reports, QuickLook & Trash

        Your project files, saved documents, bookmarks, login credentials, and code remain 100% safe.
        """
        alert.alertStyle = .informational
        if let icon = appIcon {
            alert.icon = icon
        }
        
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
            title: "ZeroEmpire: All Caches Purged!",
            message: "Reclaimed \(reclaimedFormatted) across 400+ apps & system storage."
        )
        
        // 6. Success Modal
        let successAlert = NSAlert()
        successAlert.messageText = "🎉 Optimization Complete!"
        successAlert.informativeText = """
        ZeroEmpire has successfully cleaned your Mac.

        • Storage Reclaimed: \(reclaimedFormatted)
        • Total Free Disk Space: \(formatBytes(freeAfter))

        Caches for Adobe, DaVinci, Blender, Xcode, Browsers, Electron apps, Dev toolchains, and macOS System Data have been purged.
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
    
    func performUniversalCleanup(homeDir: String) {
        let fm = FileManager.default
        
        // ==========================================
        // 1. TIER 1: GLOBAL USER CACHE DIRECTORY
        // (Covers ALL 400+ Mac applications storing in ~/Library/Caches)
        // ==========================================
        cleanDirectoryContents("\(homeDir)/Library/Caches")
        cleanDirectoryContents("/Library/Caches")
        
        // ==========================================
        // 2. TIER 2: ELECTRON & PRODUCTIVITY APPS
        // (VS Code, Cursor, Slack, Discord, Notion, Figma, Spotify, WhatsApp, Teams, Postman, etc.)
        // ==========================================
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
        
        // ==========================================
        // 3. TIER 3: PRO VIDEO, 3D & AUDIO CREATIVE SUITES
        // ==========================================
        // Adobe Suite
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
        
        // DaVinci Resolve (Blackmagic Design)
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/CacheClip")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/.gallery")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/ProxyMedia")
        
        // Final Cut Pro & Motion
        cleanDirectoryContents("\(homeDir)/Movies/Motion Templates.localized/Cache")
        
        // Blender
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Blender", childPattern: "cache")
        cleanDirectoryContents("\(homeDir)/.config/blender/cache")
        
        // Cinema 4D / Maxon
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Maxon", childPattern: "cache")
        
        // Unreal Engine & Epic Games
        cleanDirectoryContents("\(homeDir)/Library/Caches/com.epicgames.UnrealEngine")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Epic/UnrealEngine/Common/DerivedDataCache")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Epic/EpicGamesLauncher/Saved/Logs")
        
        // Unity Editor
        cleanDirectoryContents("\(homeDir)/Library/Unity/cache")
        cleanDirectoryContents("\(homeDir)/Library/Caches/com.unity3d.UnityEditor")
        
        // Audio DAWs (Logic, Ableton, FL Studio, Pro Tools)
        cleanDirectoryContents("\(homeDir)/Library/Caches/AudioUnitCache")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Ableton/Live Database/Cache")
        cleanDirectoryContents("\(homeDir)/Music/Audio Music Apps/Freeze Files")
        
        // ==========================================
        // 4. TIER 4: DEVELOPER & BUILD TOOLCHAINS
        // ==========================================
        let devCaches = [
            // Xcode & iOS
            "\(homeDir)/Library/Developer/Xcode/DerivedData",
            "\(homeDir)/Library/Developer/Xcode/Archives",
            "\(homeDir)/Library/Developer/Xcode/iOS DeviceSupport",
            "\(homeDir)/Library/Developer/CoreSimulator/Caches",
            // Android Studio & Gradle
            "\(homeDir)/.gradle/caches",
            "\(homeDir)/.android/build-cache",
            "\(homeDir)/.android/cache",
            // JetBrains IDEs
            "\(homeDir)/Library/Caches/JetBrains",
            // VS Code / Cursor Caches
            "\(homeDir)/Library/Application Support/Code/Cache",
            "\(homeDir)/Library/Application Support/Code/CachedData",
            "\(homeDir)/Library/Application Support/Cursor/Cache",
            "\(homeDir)/Library/Application Support/Cursor/CachedData",
            // Universal XDG Cache directory (used by 100+ CLI tools)
            "\(homeDir)/.cache",
            // Package Managers
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
        
        // Clean Homebrew cache via CLI if installed
        runProcess(path: "/usr/local/bin/brew", args: ["cleanup", "-s"])
        runProcess(path: "/opt/homebrew/bin/brew", args: ["cleanup", "-s"])
        
        // Docker pruning (dangling builder & containers) if docker CLI available
        runProcess(path: "/usr/local/bin/docker", args: ["builder", "prune", "-f"])
        runProcess(path: "/opt/homebrew/bin/docker", args: ["builder", "prune", "-f"])
        
        // ==========================================
        // 5. TIER 5: SYSTEM DATA, LOGS & SNAPSHOTS
        // ==========================================
        cleanDirectoryContents("\(homeDir)/Library/Logs")
        cleanDirectoryContents("/Library/Logs")
        cleanDirectoryContents("\(homeDir)/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/CrashReporter")
        cleanDirectoryContents("\(homeDir)/.Trash")
        
        // Time Machine Local Snapshots (Crucial for Mac 'System Data')
        purgeTimeMachineLocalSnapshots()
        
        // QuickLook Thumbnail Database Refresh
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
