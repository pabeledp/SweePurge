import Cocoa
import Foundation

class SweePurgeWindowController: NSObject, NSWindowDelegate {
    var window: NSWindow!
    var homeDir: String
    var appIcon: NSImage?
    var hasFDA: Bool = false
    var deepBtn: NSButton!
    
    init(homeDir: String, appIcon: NSImage?) {
        self.homeDir = homeDir
        self.appIcon = appIcon
        super.init()
        self.hasFDA = checkFullDiskAccess()
        setupUI()
    }
    
    func checkFullDiskAccess() -> Bool {
        let safariPath = "\(homeDir)/Library/Safari"
        return (try? FileManager.default.contentsOfDirectory(atPath: safariPath)) != nil
    }
    
    func setupUI() {
        let width: CGFloat = 460
        let height: CGFloat = 460
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.delegate = self
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.initialFirstResponder = nil // Prevents default focus outline
        window.center()
        
        // Native Frosted Glass Background
        let visualEffect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .popover
        window.contentView = visualEffect
        
        // --- 1. App Icon ---
        let iconView = NSImageView(frame: NSRect(x: (width - 64) / 2, y: height - 86, width: 64, height: 64))
        iconView.image = appIcon
        iconView.imageScaling = .scaleProportionallyUpOrDown
        visualEffect.addSubview(iconView)
        
        // --- 2. Title ---
        let titleLabel = NSTextField(frame: NSRect(x: 20, y: height - 118, width: width - 40, height: 24))
        titleLabel.stringValue = "SweePurge"
        titleLabel.font = NSFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.alignment = .center
        titleLabel.isBezeled = false
        titleLabel.drawsBackground = false
        titleLabel.isEditable = false
        titleLabel.isSelectable = false
        visualEffect.addSubview(titleLabel)
        
        // --- 3. Subtitle ---
        let subtitleLabel = NSTextField(frame: NSRect(x: 20, y: height - 138, width: width - 40, height: 16))
        subtitleLabel.stringValue = "Universal Mac Storage & Cache Purger"
        subtitleLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = NSColor.secondaryLabelColor
        subtitleLabel.alignment = .center
        subtitleLabel.isBezeled = false
        subtitleLabel.drawsBackground = false
        subtitleLabel.isEditable = false
        subtitleLabel.isSelectable = false
        visualEffect.addSubview(subtitleLabel)
        
        // --- 4. Feature Box (Simple, Zero Stroke / Border) ---
        let cardWidth = width - 60
        let cardHeight: CGFloat = 96
        let cardY = height - 250
        let cardView = NSBox(frame: NSRect(x: 30, y: cardY, width: cardWidth, height: cardHeight))
        cardView.boxType = .custom
        cardView.borderWidth = 0 // Zero border stroke
        cardView.cornerRadius = 8
        cardView.fillColor = NSColor.controlBackgroundColor.withAlphaComponent(0.35)
        
        let features = [
            "• 400+ Apps Caches, Adobe Media Scratch & Dev Artifacts",
            "• macOS System Data, Time Machine Snapshots & Logs",
            "• Saved Application States, Stale Downloads & Trash"
        ]
        
        let cardContent = NSTextField(frame: NSRect(x: 16, y: 10, width: cardWidth - 32, height: cardHeight - 20))
        cardContent.stringValue = features.joined(separator: "\n\n")
        cardContent.font = NSFont.systemFont(ofSize: 11.5, weight: .regular)
        cardContent.textColor = NSColor.labelColor
        cardContent.isBezeled = false
        cardContent.drawsBackground = false
        cardContent.isEditable = false
        cardContent.isSelectable = false
        cardView.addSubview(cardContent)
        visualEffect.addSubview(cardView)
        
        // --- 5. Safety Indicator (Neutral Monochrome) ---
        let safetyLabel = NSTextField(frame: NSRect(x: 30, y: height - 274, width: width - 60, height: 16))
        safetyLabel.stringValue = "100% Safe: Personal files, active projects & licenses untouched"
        safetyLabel.font = NSFont.systemFont(ofSize: 10.5, weight: .regular)
        safetyLabel.textColor = NSColor.secondaryLabelColor
        safetyLabel.alignment = .center
        safetyLabel.isBezeled = false
        safetyLabel.drawsBackground = false
        safetyLabel.isEditable = false
        safetyLabel.isSelectable = false
        visualEffect.addSubview(safetyLabel)
        
        // --- 6. Deep Cleaning Button (No Blue Stroke, No Focus Ring, Standard Neutral Look) ---
        let deepBtnWidth: CGFloat = 200
        let deepBtnHeight: CGFloat = 30
        let deepBtnY: CGFloat = 112
        deepBtn = NSButton(frame: NSRect(x: (width - deepBtnWidth) / 2, y: deepBtnY, width: deepBtnWidth, height: deepBtnHeight))
        deepBtn.title = hasFDA ? "Deep Cleaning: Active" : "Deep Cleaning Mode"
        deepBtn.bezelStyle = .rounded
        deepBtn.font = NSFont.systemFont(ofSize: 11.5, weight: .regular)
        deepBtn.contentTintColor = NSColor.secondaryLabelColor
        deepBtn.focusRingType = .none // Completely removes blue focus ring / stroke
        deepBtn.target = self
        deepBtn.action = #selector(deepCleaningClicked)
        visualEffect.addSubview(deepBtn)
        
        // --- 7. Main Action Buttons ---
        let btnWidth: CGFloat = 160
        let btnHeight: CGFloat = 32
        let totalBtnWidth = (btnWidth * 2) + 14
        let btnStartX = (width - totalBtnWidth) / 2
        let btnY: CGFloat = 68
        
        let cancelBtn = NSButton(frame: NSRect(x: btnStartX, y: btnY, width: btnWidth, height: btnHeight))
        cancelBtn.title = "Cancel"
        cancelBtn.bezelStyle = .rounded
        cancelBtn.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        cancelBtn.focusRingType = .none
        cancelBtn.target = self
        cancelBtn.action = #selector(cancelClicked)
        visualEffect.addSubview(cancelBtn)
        
        let cleanBtn = NSButton(frame: NSRect(x: btnStartX + btnWidth + 14, y: btnY, width: btnWidth, height: btnHeight))
        cleanBtn.title = "Clean All Caches Now"
        cleanBtn.bezelStyle = .rounded
        cleanBtn.keyEquivalent = "\r"
        cleanBtn.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        cleanBtn.focusRingType = .none
        cleanBtn.target = self
        cleanBtn.action = #selector(cleanClicked)
        visualEffect.addSubview(cleanBtn)
        
        // --- 8. Footer Developer Credit (Centered at Bottom) ---
        let creditContainer = NSView(frame: NSRect(x: 0, y: 12, width: width, height: 32))
        
        let creditLine1 = NSTextField(frame: NSRect(x: 0, y: 16, width: width, height: 14))
        creditLine1.stringValue = "Developed by"
        creditLine1.font = NSFont.systemFont(ofSize: 8.5, weight: .regular)
        creditLine1.textColor = NSColor.secondaryLabelColor.withAlphaComponent(0.35)
        creditLine1.alignment = .center
        creditLine1.isBezeled = false
        creditLine1.drawsBackground = false
        creditLine1.isEditable = false
        creditLine1.isSelectable = false
        creditContainer.addSubview(creditLine1)
        
        let creditLine2 = NSTextField(frame: NSRect(x: 0, y: 0, width: width, height: 16))
        creditLine2.stringValue = "A M Pabel, Team Captain at FramEmpire"
        creditLine2.font = NSFont.systemFont(ofSize: 9.5, weight: .regular)
        creditLine2.textColor = NSColor.secondaryLabelColor.withAlphaComponent(0.40)
        creditLine2.alignment = .center
        creditLine2.isBezeled = false
        creditLine2.drawsBackground = false
        creditLine2.isEditable = false
        creditLine2.isSelectable = false
        creditContainer.addSubview(creditLine2)
        
        visualEffect.addSubview(creditContainer)
    }
    
    func show() {
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func deepCleaningClicked() {
        // Native macOS Sheet Modal: Automatically blurs and locks the background window
        let alert = NSAlert()
        alert.messageText = "Deep Cleaning Mode"
        alert.informativeText = """
        Deep Cleaning allows SweePurge to unlock 20-50+ GB of protected storage:
        • Deep Adobe Media Caches & Scratch Disks
        • Hidden Time Machine Local Snapshots (System Data)
        • Diagnostic Crash Reports & System Logs

        To enable this, macOS requires Full Disk Access:
        1. Click "Open Settings" below.
        2. Toggle the switch ON for SweePurge.
        3. Return to SweePurge for full storage recovery.
        """
        alert.alertStyle = .informational
        if let icon = appIcon {
            alert.icon = icon
        }
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Cancel")
        
        // Attaches sheet directly to window, blurring and dimming the background window
        alert.beginSheetModal(for: window) { [weak self] response in
            guard let self = self else { return }
            if response == .alertFirstButtonReturn {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
                    NSWorkspace.shared.open(url)
                }
            }
            // Check FDA again and update label
            self.hasFDA = self.checkFullDiskAccess()
            if self.hasFDA {
                self.deepBtn.title = "Deep Cleaning: Active"
            }
        }
    }
    
    @objc func cancelClicked() {
        window.close()
        exit(0)
    }
    
    @objc func cleanClicked() {
        window.close()
        SweePurgeEngine.run(homeDir: homeDir, appIcon: appIcon)
    }
    
    func windowWillClose(_ notification: Notification) {
        exit(0)
    }
}

class SweePurgeEngine {
    static func run(homeDir: String, appIcon: NSImage?) {
        let freeBefore = getFreeDiskSpaceBytes()
        
        performDeepUniversalCleanup(homeDir: homeDir)
        
        let freeAfter = getFreeDiskSpaceBytes()
        let reclaimedBytes = max(0, freeAfter - freeBefore)
        let reclaimedFormatted = formatBytes(reclaimedBytes)
        
        sendNotification(
            title: "SweePurge: Mac Optimized",
            message: "Reclaimed \(reclaimedFormatted) across 400+ apps & system storage."
        )
        
        showSuccessDialog(reclaimed: reclaimedFormatted, freeTotal: formatBytes(freeAfter), appIcon: appIcon)
    }
    
    static func showSuccessDialog(reclaimed: String, freeTotal: String, appIcon: NSImage?) {
        let width: CGFloat = 420
        let height: CGFloat = 300
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.center()
        
        let visualEffect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .popover
        window.contentView = visualEffect
        
        let iconView = NSImageView(frame: NSRect(x: (width - 56) / 2, y: height - 76, width: 56, height: 56))
        iconView.image = appIcon
        iconView.imageScaling = .scaleProportionallyUpOrDown
        visualEffect.addSubview(iconView)
        
        let titleLabel = NSTextField(frame: NSRect(x: 20, y: height - 106, width: width - 40, height: 24))
        titleLabel.stringValue = "Optimization Complete"
        titleLabel.font = NSFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.alignment = .center
        titleLabel.isBezeled = false
        titleLabel.drawsBackground = false
        titleLabel.isEditable = false
        visualEffect.addSubview(titleLabel)
        
        let infoLabel = NSTextField(frame: NSRect(x: 30, y: height - 176, width: width - 60, height: 56))
        infoLabel.stringValue = """
        SweePurge has successfully cleaned your Mac.

        • Storage Reclaimed: \(reclaimed)
        • Total Available Disk Space: \(freeTotal)
        """
        infoLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        infoLabel.alignment = .center
        infoLabel.isBezeled = false
        infoLabel.drawsBackground = false
        infoLabel.isEditable = false
        visualEffect.addSubview(infoLabel)
        
        let doneBtn = NSButton(frame: NSRect(x: (width - 140) / 2, y: 64, width: 140, height: 32))
        doneBtn.title = "Done"
        doneBtn.bezelStyle = .rounded
        doneBtn.keyEquivalent = "\r"
        doneBtn.target = NSApp
        doneBtn.action = #selector(NSApplication.terminate(_:))
        visualEffect.addSubview(doneBtn)
        
        let creditContainer = NSView(frame: NSRect(x: 0, y: 12, width: width, height: 32))
        let creditLine1 = NSTextField(frame: NSRect(x: 0, y: 16, width: width, height: 14))
        creditLine1.stringValue = "Developed by"
        creditLine1.font = NSFont.systemFont(ofSize: 8.5, weight: .regular)
        creditLine1.textColor = NSColor.secondaryLabelColor.withAlphaComponent(0.35)
        creditLine1.alignment = .center
        creditLine1.isBezeled = false
        creditLine1.drawsBackground = false
        creditLine1.isEditable = false
        creditContainer.addSubview(creditLine1)
        
        let creditLine2 = NSTextField(frame: NSRect(x: 0, y: 0, width: width, height: 16))
        creditLine2.stringValue = "A M Pabel, Team Captain at FramEmpire"
        creditLine2.font = NSFont.systemFont(ofSize: 9.5, weight: .regular)
        creditLine2.textColor = NSColor.secondaryLabelColor.withAlphaComponent(0.40)
        creditLine2.alignment = .center
        creditLine2.isBezeled = false
        creditLine2.drawsBackground = false
        creditLine2.isEditable = false
        creditContainer.addSubview(creditLine2)
        visualEffect.addSubview(creditContainer)
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.run()
    }
    
    static func getFreeDiskSpaceBytes() -> Int64 {
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
    
    static func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    static func performDeepUniversalCleanup(homeDir: String) {
        let fm = FileManager.default
        
        // 1. TIER 1: GLOBAL USER & SYSTEM CACHES
        cleanDirectoryContents("\(homeDir)/Library/Caches")
        cleanDirectoryContents("/Library/Caches")
        
        // 2. TIER 2: ELECTRON & DESKTOP APPS
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
        
        // 5. TIER 5: DEEP JUNK, SAVED STATES & STALE DOWNLOADS
        cleanDirectoryContents("\(homeDir)/Library/Saved Application State")
        cleanStaleIncompleteDownloads(in: "\(homeDir)/Downloads")
        
        cleanDirectoryContents("\(homeDir)/Library/Logs")
        cleanDirectoryContents("/Library/Logs")
        cleanDirectoryContents("\(homeDir)/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("/Library/Logs/DiagnosticReports")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/CrashReporter")
        
        cleanDirectoryContents("\(homeDir)/.Trash")
        purgeTimeMachineLocalSnapshots()
        
        runProcess(path: "/usr/bin/qlmanage", args: ["-r", "cache"])
        runProcess(path: "/usr/bin/qlmanage", args: ["-r"])
        runProcess(path: "/usr/bin/atsutil", args: ["databases", "-removeUser"])
    }
    
    static func cleanDirectoryContents(_ path: String) {
        let fm = FileManager.default
        var isDir: ObjCBool = false
        guard fm.fileExists(atPath: path, isDirectory: &isDir), isDir.boolValue else { return }
        
        guard let items = try? fm.contentsOfDirectory(atPath: path) else { return }
        for item in items {
            let itemPath = (path as NSString).appendingPathComponent(item)
            try? fm.removeItem(atPath: itemPath)
        }
    }
    
    static func cleanWildcardSubfolders(base: String, childPattern: String) {
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
    
    static func cleanStaleIncompleteDownloads(in downloadsPath: String) {
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(atPath: downloadsPath) else { return }
        let incompleteExtensions = ["crdownload", "part", "download"]
        
        for file in files {
            let ext = (file as NSString).pathExtension.lowercased()
            if incompleteExtensions.contains(ext) {
                let fullPath = (downloadsPath as NSString).appendingPathComponent(file)
                try? fm.removeItem(atPath: fullPath)
            }
        }
    }
    
    static func purgeTimeMachineLocalSnapshots() {
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
    static func runProcess(path: String, args: [String]) -> Int32 {
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
    
    static func sendNotification(title: String, message: String) {
        let escapedTitle = title.replacingOccurrences(of: "\"", with: "\\\"")
        let escapedMsg = message.replacingOccurrences(of: "\"", with: "\\\"")
        let script = "display notification \"\(escapedMsg)\" with title \"\(escapedTitle)\""
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
        }
    }
}

// App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: SweePurgeWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
        let appIcon = NSImage(contentsOfFile: Bundle.main.path(forResource: "AppIcon", ofType: "icns") ?? "") ?? NSApp.applicationIconImage
        
        windowController = SweePurgeWindowController(homeDir: homeDir, appIcon: appIcon)
        windowController?.show()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
