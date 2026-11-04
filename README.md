<div align="center">

<img src="assets/icon_1024.png" width="120" height="120" alt="SweePurge Logo" style="border-radius: 26px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);"/>

# SweePurge
### 1-Click Universal System Storage & App Cache Purger for macOS

[![macOS](https://img.shields.io/badge/macOS-12.0%2B-000000?style=flat-square&logo=apple&logoColor=white)](https://apple.com)
[![Swift](https://img.shields.io/badge/Language-Swift%205-FA7343?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.flat-square)](LICENSE)
[![Release](https://img.shields.io/badge/Version-2.0.0-emerald?style=flat-square)](https://github.com/pabeledp/SweePurge/releases)

<p align="center">
  <b>Tired of Mac's mysterious "System Data" and giant software caches eating all your disk space?</b><br/>
  SweePurge instantly purges gigabytes of caches across <b>400+ professional creative suites, browsers, IDEs, and system bloat</b> in 1-Click.
</p>

---

### <img src="assets/icons/download.svg" width="20" height="20" align="center" /> Download SweePurge for Mac

<a href="https://github.com/pabeledp/SweePurge/raw/main/SweePurge.dmg">
  <img src="https://custom-icon-badges.demolab.com/badge/DOWNLOAD-SweePurge.dmg%20(Direct%20Install)-007AFF?style=for-the-badge&logo=download&logoColor=white" height="48" alt="Download SweePurge"/>
</a>

<br/>

<sub>Universal Binary • macOS Monterey, Ventura, Sonoma, Sequoia • Size: ~1.1 MB</sub>

---

</div>

<br/>

## <img src="assets/icons/zap.svg" width="20" height="20" align="center" /> The Problem
Professional software tools silently hoard gigabytes of cache and scratch files without clearing them:
* **Video & 3D**: Adobe Premiere, After Effects, DaVinci Resolve, Blender, Unreal Engine, and Cinema 4D generate **50 GB – 200+ GB** of render scratch, peak files, and shader caches.
* **IDEs & Dev**: Xcode (`DerivedData`), Android Studio, JetBrains, Docker, and package managers accumulate tens of gigabytes of stale build artifacts.
* **Browsers & Desktop Apps**: Chrome, Safari, Slack, Discord, Teams, Spotify, and Figma continuously hoard media and web cache.
* **macOS System Data**: Time Machine local snapshots and system diagnostic reports secretly lock up disk space.

**SweePurge** safely purges these with a **single, elegant confirmation popup**—zero terminal windows, zero bloat, and zero battery impact.

---

## <img src="assets/icons/layers.svg" width="20" height="20" align="center" /> Supported Softwares & Tools (400+ Covered)

SweePurge features a multi-tiered intelligent cleaning architecture that purges caches across:

### <img src="assets/icons/video.svg" width="18" height="18" align="center" /> 1. Video, Motion & VFX
* **Adobe Creative Cloud**: Premiere Pro, After Effects, Media Encoder, Audition, Character Animator, Animate
* **DaVinci Resolve**: CacheClip, Gallery Stills, Optimized & Proxy Media
* **Apple Pro Apps**: Final Cut Pro, Motion, Compressor
* **CapCut, Avid Media Composer, Vegas Pro, CyberLink PowerDirector**

### <img src="assets/icons/box.svg" width="18" height="18" align="center" /> 2. 3D, Game Engines & CAD
* **3D Suites**: Blender, Cinema 4D (Maxon), Maya, 3ds Max, Houdini, ZBrush, Modo, Rhino 3D, SketchUp
* **Game Engines**: Unreal Engine (DerivedDataCache, Shader Cache), Unity Editor (`Unity/cache`), Godot Engine
* **Renderers**: Octane Render, Redshift, V-Ray, Arnold Renderer, Corona Renderer, KeyShot
* **Texturing & VFX**: Substance 3D Painter/Designer, Quixel Mixer, Quixel Bridge, Marvelous Designer, Clo3D

### <img src="assets/icons/palette.svg" width="18" height="18" align="center" /> 3. Graphic Design & Digital Art
* Photoshop (AutoRecover, Scratch), Illustrator, InDesign, Lightroom, Capture One, Affinity Suite (Designer, Photo, Publisher), CorelDRAW, Clip Studio Paint, Krita, Procreate, Figma, Sketch

### <img src="assets/icons/code.svg" width="18" height="18" align="center" /> 4. Development, IDEs & Mobile Toolchains
* **IDEs**: Xcode (`DerivedData`, Archives, iOS DeviceSupport), Android Studio, JetBrains (IntelliJ, WebStorm, PyCharm, CLion, Rider, GoLand), Visual Studio Code, Cursor, Eclipse, Sublime Text
* **Virtualization & Containers**: Docker (Builder cache, dangling images), Podman, VirtualBox, VMware Fusion, Parallels
* **CLI & Package Managers**: Homebrew (`brew cleanup`), npm (`_cacache`), pnpm, Yarn, Bun, Pip, Poetry, Conda, Composer, Cargo, Gradle, Maven

### <img src="assets/icons/globe.svg" width="18" height="18" align="center" /> 5. Web Browsers (Desktop & Developer)
* Google Chrome, Apple Safari, Brave, Arc Browser, Microsoft Edge, Mozilla Firefox, Opera, Vivaldi, Tor Browser, DuckDuckGo, Chrome Canary, Firefox Dev Edition

### <img src="assets/icons/message.svg" width="18" height="18" align="center" /> 6. Productivity & Communication
* Slack, Discord, Telegram, Microsoft Teams, WhatsApp Desktop, Zoom, Spotify, Notion, Obsidian, Postman, Insomnia, GitHub Desktop, GitKraken, TablePlus, DBeaver

### <img src="assets/icons/cpu.svg" width="18" height="18" align="center" /> 7. macOS System Data & OS Bloat
* **Time Machine Local Snapshots** (the major cause of unexpected "System Data" spikes)
* QuickLook thumbnail databases (`qlmanage -r cache`)
* Diagnostic crash logs & reports (`/Library/Logs/DiagnosticReports`)
* User Trash (`~/.Trash`)

---

## <img src="assets/icons/shield.svg" width="20" height="20" align="center" /> 100% Safety Guarantee
* <img src="assets/icons/check.svg" width="14" height="14" align="center" /> **Zero Project Loss**: Your project files (`.prproj`, `.aep`, `.blend`, `.psd`, `.xcodeproj`), code repositories, and documents are **never touched**.
* <img src="assets/icons/check.svg" width="14" height="14" align="center" /> **Zero Login Loss**: Your saved passwords, browser bookmarks, and login sessions remain completely intact.
* <img src="assets/icons/check.svg" width="14" height="14" align="center" /> **On-Demand Cache**: Purged files are purely temporary render caches, preview proxies, and stale logs that re-generate cleanly when needed.

---

## <img src="assets/icons/play.svg" width="20" height="20" align="center" /> How to Use

### 1. Download & Run
1. Download [**SweePurge.dmg**](https://github.com/pabeledp/SweePurge/raw/main/SweePurge.dmg).
2. Drag **SweePurge** into your **Applications** folder.
3. Open **SweePurge** from Spotlight or Applications.
4. Click **"Clean All Caches Now"** on the popup.
5. Reclaim gigabytes within seconds and get a detailed completion alert.

### 2. Preview Clutter (Optional CLI Scanner)
```bash
./scripts/check_clutter.sh
```

---

## <img src="assets/icons/file-text.svg" width="20" height="20" align="center" /> License
This project is open-source under the [MIT License](LICENSE).

<br/>

<div align="center">
  <p style="opacity: 0.35; font-size: 10px; color: #888888; line-height: 1.5; margin-top: 30px;">
    Developed by<br/>
    A M Pabel, Team Captain at FramEmpire
  </p>
</div>
