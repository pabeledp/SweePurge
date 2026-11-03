import Cocoa

func createIcon(size: CGFloat) -> NSImage {
    let img = NSImage(size: NSSize(width: size, height: size))
    img.lockFocus()
    
    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    
    // Background Squircle (macOS standard rounded rect)
    let cornerRadius = size * 0.2237
    let squircleRect = rect.insetBy(dx: size * 0.05, dy: size * 0.05)
    let squirclePath = NSBezierPath(roundedRect: squircleRect, xRadius: cornerRadius, yRadius: cornerRadius)
    
    // Gradient Background: Deep Midnight Obsidian to Electric Indigo
    let gradient = NSGradient(colors: [
        NSColor(red: 0.06, green: 0.07, blue: 0.12, alpha: 1.0),
        NSColor(red: 0.11, green: 0.13, blue: 0.24, alpha: 1.0),
        NSColor(red: 0.15, green: 0.12, blue: 0.28, alpha: 1.0)
    ], atLocations: [0.0, 0.6, 1.0], colorSpace: .sRGB)
    
    gradient?.draw(in: squirclePath, angle: -45)
    
    // Subtle Inner Border / Glow
    NSColor(white: 1.0, alpha: 0.15).setStroke()
    squirclePath.lineWidth = size * 0.015
    squirclePath.stroke()
    
    // Glowing Ring (Zero)
    let ringRadius = size * 0.22
    let ringCenter = NSPoint(x: size * 0.5, y: size * 0.44)
    let ringRect = NSRect(x: ringCenter.x - ringRadius, y: ringCenter.y - ringRadius, width: ringRadius * 2, height: ringRadius * 2)
    let ringPath = NSBezierPath(ovalIn: ringRect)
    
    let ringGradient = NSGradient(starting: NSColor(red: 0.0, green: 0.85, blue: 1.0, alpha: 0.9),
                                  ending: NSColor(red: 0.4, green: 0.2, blue: 0.95, alpha: 0.9))
    
    // Stroke the ring
    let ringLineWidth = size * 0.06
    NSGraphicsContext.saveGraphicsState()
    ringPath.lineWidth = ringLineWidth
    ringGradient?.draw(in: ringPath.strokedPath(width: ringLineWidth), angle: 45)
    NSGraphicsContext.restoreGraphicsState()
    
    // Crown on Top of the Ring (Empire Symbol)
    let crownPath = NSBezierPath()
    let cx = size * 0.5
    let cy = size * 0.70
    let cw = size * 0.26
    let ch = size * 0.16
    
    crownPath.move(to: NSPoint(x: cx - cw/2, y: cy - ch/2))
    crownPath.line(to: NSPoint(x: cx - cw/2, y: cy + ch/2)) // Left peak
    crownPath.line(to: NSPoint(x: cx - cw/4, y: cy))        // Left valley
    crownPath.line(to: NSPoint(x: cx, y: cy + ch/2 + size*0.03)) // Center high peak
    crownPath.line(to: NSPoint(x: cx + cw/4, y: cy))        // Right valley
    crownPath.line(to: NSPoint(x: cx + cw/2, y: cy + ch/2)) // Right peak
    crownPath.line(to: NSPoint(x: cx + cw/2, y: cy - ch/2))
    crownPath.close()
    
    let goldGradient = NSGradient(starting: NSColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1.0),
                                  ending: NSColor(red: 0.95, green: 0.65, blue: 0.1, alpha: 1.0))
    goldGradient?.draw(in: crownPath, angle: -90)
    
    // Small jewel dots on crown peaks
    let dotRadius = size * 0.02
    for px in [cx - cw/2, cx, cx + cw/2] {
        let py = (px == cx) ? (cy + ch/2 + size*0.03) : (cy + ch/2)
        let dot = NSBezierPath(ovalIn: NSRect(x: px - dotRadius, y: py - dotRadius, width: dotRadius*2, height: dotRadius*2))
        NSColor.white.setFill()
        dot.fill()
    }
    
    // Lightning Spark inside the Zero (Fast purge symbol)
    let spark = NSBezierPath()
    let sx = cx
    let sy = ringCenter.y
    spark.move(to: NSPoint(x: sx + size*0.015, y: sy + size*0.10))
    spark.line(to: NSPoint(x: sx - size*0.05, y: sy - size*0.01))
    spark.line(to: NSPoint(x: sx, y: sy - size*0.01))
    spark.line(to: NSPoint(x: sx - size*0.015, y: sy - size*0.10))
    spark.line(to: NSPoint(x: sx + size*0.05, y: sy + size*0.01))
    spark.line(to: NSPoint(x: sx, y: sy + size*0.01))
    spark.close()
    
    NSColor(red: 0.0, green: 1.0, blue: 0.9, alpha: 1.0).setFill()
    spark.fill()
    
    img.unlockFocus()
    return img
}

extension NSBezierPath {
    func strokedPath(width: CGFloat) -> NSBezierPath {
        let path = NSBezierPath()
        path.append(self)
        path.lineWidth = width
        return path
    }
}

let icon = createIcon(size: 1024)
if let tiff = icon.tiffRepresentation,
   let bitmap = NSBitmapImageRep(data: tiff),
   let png = bitmap.representation(using: .png, properties: [:]) {
    let url = URL(fileURLWithPath: "/Users/rmacstudio2/Documents/ZeroEmpire/assets/icon_1024.png")
    try? png.write(to: url)
    print("Generated 1024x1024 icon at \(url.path)")
}
