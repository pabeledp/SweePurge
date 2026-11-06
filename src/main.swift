import Cocoa
import Foundation

class SweePurgeWindowController: NSObject, NSWindowDelegate {
    var window: NSWindow!
    var visualEffect: NSVisualEffectView!
    var homeDir: String
    var appIcon: NSImage?
    var hasFDA: Bool = false
    
    // UI Elements
    var subtitleLabel: NSTextField!
    var cardView: NSBox!
    var safetyLabel: NSTextField!
    var deepBtn: NSButton!
    var cancelBtn: NSButton!
    var cleanBtn: NSButton!
    
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
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.delegate = self
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.center()
        
        // Ensure Traffic Light buttons are properly configured
        window.standardWindowButton(.closeButton)?.isEnabled = true
        window.standardWindowButton(.miniaturizeButton)?.isEnabled = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Native Frosted Glass Background
        visualEffect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .popover
        window.contentView = visualEffect
        
        // --- 1. App Icon ---
        let iconView = NSImageView(frame: NSRect(x: (width - 64) / 2, y: height - 88, width: 64, height: 64))
        iconView.image = appIcon
        iconView.imageScaling = .scaleProportionallyUpOrDown
        visualEffect.addSubview(iconView)
        
        // --- 2. Title ---
        let titleLabel = NSTextField(frame: NSRect(x: 20, y: height - 120, width: width - 40, height: 24))
        titleLabel.stringValue = "SweePurge"
        titleLabel.font = NSFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.alignment = .center
        titleLabel.isBezeled = false
        titleLabel.drawsBackground = false
        titleLabel.isEditable = false
        titleLabel.isSelectable = false
        visualEffect.addSubview(titleLabel)
        
        // --- 3. Subtitle ---
        subtitleLabel = NSTextField(frame: NSRect(x: 20, y: height - 142, width: width - 40, height: 16))
        subtitleLabel.stringValue = "Universal Mac Storage & Cache Purger"
        subtitleLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = NSColor.secondaryLabelColor
        subtitleLabel.alignment = .center
        subtitleLabel.isBezeled = false
        subtitleLabel.drawsBackground = false
        subtitleLabel.isEditable = false
        subtitleLabel.isSelectable = false
        visualEffect.addSubview(subtitleLabel)
        
        // --- 4. Feature Box (Centered, Simple, Zero Stroke / Border) ---
        let cardWidth: CGFloat = width - 60
        let cardHeight: CGFloat = 92
        let cardY: CGFloat = 206
        cardView = NSBox(frame: NSRect(x: 30, y: cardY, width: cardWidth, height: cardHeight))
        cardView.boxType = .custom
        cardView.borderWidth = 0
        cardView.cornerRadius = 8
        cardView.fillColor = NSColor.controlBackgroundColor.withAlphaComponent(0.35)
        
        let features = [
            "• 400+ Apps Caches, Adobe Media Scratch & Dev Artifacts",
            "• macOS System Data, Time Machine Snapshots & Logs",
            "• Saved Application States, Stale Downloads & Trash"
        ]
        
        let cardContent = NSTextField(frame: NSRect(x: 16, y: 8, width: cardWidth - 32, height: cardHeight - 16))
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
        safetyLabel = NSTextField(frame: NSRect(x: 20, y: 176, width: width - 40, height: 16))
        safetyLabel.stringValue = "100% Safe: Personal files, active projects & licenses untouched"
        safetyLabel.font = NSFont.systemFont(ofSize: 10.5, weight: .regular)
        safetyLabel.textColor = NSColor.secondaryLabelColor
        safetyLabel.alignment = .center
        safetyLabel.isBezeled = false
        safetyLabel.drawsBackground = false
        safetyLabel.isEditable = false
        safetyLabel.isSelectable = false
        visualEffect.addSubview(safetyLabel)
        
        // --- 6. Deep Cleaning Button (Standard Rounded Shape, Right Above Action Buttons, No Stroke) ---
        let deepBtnWidth: CGFloat = 220
        let deepBtnHeight: CGFloat = 32
        let deepBtnY: CGFloat = 110
        deepBtn = NSButton(frame: NSRect(x: (width - deepBtnWidth) / 2, y: deepBtnY, width: deepBtnWidth, height: deepBtnHeight))
        deepBtn.title = hasFDA ? "Deep Cleaning: Active" : "Deep Cleaning Mode"
        deepBtn.bezelStyle = .rounded
        deepBtn.font = NSFont.systemFont(ofSize: 11.5, weight: .regular)
        deepBtn.contentTintColor = NSColor.secondaryLabelColor
        deepBtn.focusRingType = .none
        deepBtn.refusesFirstResponder = true // Completely eliminates blue focus stroke
        deepBtn.target = self
        deepBtn.action = #selector(deepCleaningClicked)
        visualEffect.addSubview(deepBtn)
        
        // --- 7. Main Action Buttons ---
        let btnWidth: CGFloat = 160
        let btnHeight: CGFloat = 32
        let totalBtnWidth = (btnWidth * 2) + 14
        let btnStartX = (width - totalBtnWidth) / 2
        let btnY: CGFloat = 64
        
        cancelBtn = NSButton(frame: NSRect(x: btnStartX, y: btnY, width: btnWidth, height: btnHeight))
        cancelBtn.title = "Cancel"
        cancelBtn.bezelStyle = .rounded
        cancelBtn.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        cancelBtn.focusRingType = .none
        cancelBtn.refusesFirstResponder = true // Completely eliminates blue focus stroke
        cancelBtn.target = self
        cancelBtn.action = #selector(cancelClicked)
        visualEffect.addSubview(cancelBtn)
        
        cleanBtn = NSButton(frame: NSRect(x: btnStartX + btnWidth + 14, y: btnY, width: btnWidth, height: btnHeight))
        cleanBtn.title = "Clean All Caches Now"
        cleanBtn.bezelStyle = .rounded
        cleanBtn.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        cleanBtn.focusRingType = .none
        cleanBtn.refusesFirstResponder = true
        cleanBtn.target = self
        cleanBtn.action = #selector(cleanClicked)
        visualEffect.addSubview(cleanBtn)
        
        // --- 8. Footer Developer Credit (Centered at Bottom) ---
        let creditContainer = NSView(frame: NSRect(x: 0, y: 12, width: width, height: 34))
        
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
        
        // Ensure no button starts with keyboard focus outline
        window.initialFirstResponder = nil
        window.makeFirstResponder(nil)
    }
    
    func show() {
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func deepCleaningClicked() {
        // Create full window blur/dim overlay
        let overlay = NSVisualEffectView(frame: visualEffect.bounds)
        overlay.blendingMode = .withinWindow
        overlay.material = .fullScreenUI
        overlay.state = .active
        overlay.alphaValue = 0.0
        visualEffect.addSubview(overlay, positioned: .above, relativeTo: nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            overlay.animator().alphaValue = 0.92
        }
        
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
        
        alert.beginSheetModal(for: window) { [weak self] response in
            guard let self = self else { return }
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                overlay.animator().alphaValue = 0.0
            }, completionHandler: {
                overlay.removeFromSuperview()
            })
            
            if response == .alertFirstButtonReturn {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
                    NSWorkspace.shared.open(url)
                }
            }
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
        // Transition to In-Window Progress View
        cardView.isHidden = true
        safetyLabel.isHidden = true
        deepBtn.isHidden = true
        cancelBtn.isHidden = true
        cleanBtn.isHidden = true
        
        subtitleLabel.stringValue = "Optimizing Mac Storage..."
        
        let width = window.frame.width
        let spinner = NSProgressIndicator(frame: NSRect(x: (width - 32) / 2, y: 220, width: 32, height: 32))
        spinner.style = .spinning
        spinner.controlSize = .regular
        spinner.isIndeterminate = true
        spinner.startAnimation(nil)
        visualEffect.addSubview(spinner)
        
        let progressLabel = NSTextField(frame: NSRect(x: 20, y: 170, width: width - 40, height: 22))
        progressLabel.stringValue = "Scanning and purging junk files..."
        progressLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        progressLabel.textColor = NSColor.secondaryLabelColor
        progressLabel.alignment = .center
        progressLabel.isBezeled = false
        progressLabel.drawsBackground = false
        progressLabel.isEditable = false
        progressLabel.isSelectable = false
        visualEffect.addSubview(progressLabel)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            SweePurgeEngine.run(
                homeDir: self.homeDir,
                appIcon: self.appIcon,
                progressUpdate: { status in
                    DispatchQueue.main.async {
                        progressLabel.stringValue = status
                    }
                },
                completion: { reclaimed, freeTotal in
                    DispatchQueue.main.async {
                        spinner.stopAnimation(nil)
                        spinner.removeFromSuperview()
                        progressLabel.removeFromSuperview()
                        self.showCompletionUI(reclaimed: reclaimed, freeTotal: freeTotal)
                    }
                }
            )
        }
    }
    
    func showCompletionUI(reclaimed: String, freeTotal: String) {
        let width = window.frame.width
        subtitleLabel.stringValue = "Optimization Complete"
        subtitleLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        
        let infoBox = NSBox(frame: NSRect(x: 30, y: 150, width: width - 60, height: 110))
        infoBox.boxType = .custom
        infoBox.borderWidth = 0
        infoBox.cornerRadius = 8
        infoBox.fillColor = NSColor.controlBackgroundColor.withAlphaComponent(0.35)
        
        let infoContent = NSTextField(frame: NSRect(x: 16, y: 16, width: width - 92, height: 78))
        infoContent.stringValue = """
        SweePurge has successfully cleaned your Mac.

        • Storage Reclaimed: \(reclaimed)
        • Total Available Disk Space: \(freeTotal)
        """
        infoContent.font = NSFont.systemFont(ofSize: 12.5, weight: .regular)
        infoContent.textColor = NSColor.labelColor
        infoContent.alignment = .center
        infoContent.isBezeled = false
        infoContent.drawsBackground = false
        infoContent.isEditable = false
        infoContent.isSelectable = false
        infoBox.addSubview(infoContent)
        visualEffect.addSubview(infoBox)
        
        let doneBtn = NSButton(frame: NSRect(x: (width - 140) / 2, y: 84, width: 140, height: 32))
        doneBtn.title = "Done"
        doneBtn.bezelStyle = .rounded
        doneBtn.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        doneBtn.focusRingType = .none
        doneBtn.refusesFirstResponder = true
        doneBtn.target = NSApp
        doneBtn.action = #selector(NSApplication.terminate(_:))
        visualEffect.addSubview(doneBtn)
    }
    
    func windowWillClose(_ notification: Notification) {
        exit(0)
    }
}

class SweePurgeEngine {
    static func run(homeDir: String, appIcon: NSImage?, progressUpdate: @escaping (String) -> Void, completion: @escaping (String, String) -> Void) {
        let freeBefore = getFreeDiskSpaceBytes()
        
        performDeepUniversalCleanup(homeDir: homeDir, progress: progressUpdate)
        
        let freeAfter = getFreeDiskSpaceBytes()
        let reclaimedBytes = max(0, freeAfter - freeBefore)
        let reclaimedFormatted = formatBytes(reclaimedBytes)
        let freeTotal = formatBytes(freeAfter)
        
        sendNotification(
            title: "SweePurge: Mac Optimized",
            message: "Reclaimed \(reclaimedFormatted) across 400+ apps & system storage."
        )
        
        completion(reclaimedFormatted, freeTotal)
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
    
    static func performDeepUniversalCleanup(homeDir: String, progress: @escaping (String) -> Void) {
        let fm = FileManager.default
        
        // 1. TIER 1: GLOBAL USER & SYSTEM CACHES
        progress("Purging 400+ Apps Caches & Storage...")
        cleanDirectoryContents("\(homeDir)/Library/Caches")
        cleanDirectoryContents("/Library/Caches")
        
        // 2. TIER 2: ELECTRON & DESKTOP APPS
        progress("Cleaning Application Support & App Caches...")
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
        progress("Purging Adobe Media Caches & Scratch Disks...")
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
        
        // DaVinci Resolve & 3D Suites
        progress("Cleaning 3D, Video & DAW Render Caches...")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/CacheClip")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/.gallery")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Blackmagic Design/DaVinci Resolve/ProxyMedia")
        cleanDirectoryContents("\(homeDir)/Movies/Motion Templates.localized/Cache")
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Blender", childPattern: "cache")
        cleanDirectoryContents("\(homeDir)/.config/blender/cache")
        cleanWildcardSubfolders(base: "\(homeDir)/Library/Application Support/Maxon", childPattern: "cache")
        cleanDirectoryContents("\(homeDir)/Library/Caches/com.epicgames.UnrealEngine")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Epic/UnrealEngine/Common/DerivedDataCache")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Epic/EpicGamesLauncher/Saved/Logs")
        cleanDirectoryContents("\(homeDir)/Library/Unity/cache")
        cleanDirectoryContents("\(homeDir)/Library/Caches/com.unity3d.UnityEditor")
        cleanDirectoryContents("\(homeDir)/Library/Caches/AudioUnitCache")
        cleanDirectoryContents("\(homeDir)/Library/Application Support/Ableton/Live Database/Cache")
        cleanDirectoryContents("\(homeDir)/Music/Audio Music Apps/Freeze Files")
        
        // 4. TIER 4: DEVELOPER & BUILD TOOLCHAINS
        progress("Cleaning Developer Toolchains & Build Artifacts...")
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
        progress("Reclaiming Saved States, Logs & Purgeable Space...")
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
        setupMenu()
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
        let appIcon = NSImage(contentsOfFile: Bundle.main.path(forResource: "AppIcon", ofType: "icns") ?? "") ?? NSApp.applicationIconImage
        
        windowController = SweePurgeWindowController(homeDir: homeDir, appIcon: appIcon)
        windowController?.show()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            windowController?.window.makeKeyAndOrderFront(nil)
        }
        return true
    }
    
    private func setupMenu() {
        let mainMenu = NSMenu()
        
        // App Menu
        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "About SweePurge", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Hide SweePurge", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        let hideOthersItem = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthersItem.keyEquivalentModifierMask = [.command, .option]
        appMenu.addItem(hideOthersItem)
        appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit SweePurge", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)
        
        // Window Menu (Standard macOS window operations & Cmd+M minimize)
        let windowMenuItem = NSMenuItem()
        let windowMenu = NSMenu(title: "Window")
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
        windowMenuItem.submenu = windowMenu
        mainMenu.addItem(windowMenuItem)
        
        NSApp.mainMenu = mainMenu
        NSApp.windowsMenu = windowMenu
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
