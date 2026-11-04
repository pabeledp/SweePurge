<div align="center">

<img src="assets/icon_1024.png" width="120" height="120" alt="ZeroEmpire Logo" style="border-radius: 26px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);"/>

# 👑 ZeroEmpire
### 1-Click Universal System Storage & App Cache Purger for macOS

[![macOS](https://img.shields.io/badge/macOS-12.0%2B-000000?style=flat-square&logo=apple&logoColor=white)](https://apple.com)
[![Swift](https://img.shields.io/badge/Language-Swift%205-FA7343?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.flat-square)](LICENSE)
[![Release](https://img.shields.io/badge/Version-2.0.0-emerald?style=flat-square)](https://github.com/pabeledp/ZeroEmpire/releases)

<p align="center">
  <b>Tired of Mac's mysterious "System Data" and giant software caches eating all your disk space?</b><br/>
  ZeroEmpire instantly purges gigabytes of caches across <b>400+ professional creative suites, browsers, IDEs, and system bloat</b> in 1-Click.
</p>

---

### ⬇️ Download ZeroEmpire for Mac

<a href="https://github.com/pabeledp/ZeroEmpire/raw/main/ZeroEmpire.dmg">
  <img src="https://custom-icon-badges.demolab.com/badge/DOWNLOAD-ZeroEmpire.dmg%20(Direct%20Install)-007AFF?style=for-the-badge&logo=download&logoColor=white" height="48" alt="Download ZeroEmpire"/>
</a>

<br/>

<sub>Universal Binary • macOS Monterey, Ventura, Sonoma, Sequoia • Size: ~1.8 MB</sub>

---

</div>

<br/>

## ⚡ The Problem
Professional software tools silently hoard gigabytes of cache and scratch files without clearing them:
* **Video & 3D**: Adobe Premiere, After Effects, DaVinci Resolve, Blender, Unreal Engine, and Cinema 4D generate **50 GB – 200+ GB** of render scratch, peak files, and shader caches.
* **IDEs & Dev**: Xcode (`DerivedData`), Android Studio, JetBrains, Docker, and package managers accumulate tens of gigabytes of stale build artifacts.
* **Browsers & Desktop Apps**: Chrome, Safari, Slack, Discord, Teams, Spotify, and Figma continuously hoard media and web cache.
* **macOS System Data**: Time Machine local snapshots and system diagnostic reports secretly lock up disk space.

**ZeroEmpire** safely purges these with a **single, elegant confirmation popup**—zero terminal windows, zero bloat, and zero battery impact.

---

## 🎯 Supported Softwares & Tools (400+ Covered)

ZeroEmpire features a multi-tiered intelligent cleaning architecture that purges caches across:

### 1. 🎬 Video, Motion & VFX
* **Adobe Creative Cloud**: Premiere Pro, After Effects, Media Encoder, Audition, Character Animator, Animate
* **DaVinci Resolve**: CacheClip, Gallery Stills, Optimized & Proxy Media
* **Apple Pro Apps**: Final Cut Pro, Motion, Compressor
* **CapCut, Avid Media Composer, Vegas Pro, CyberLink PowerDirector**

### 2. 🧊 3D, Game Engines & CAD
* **3D Suites**: Blender, Cinema 4D (Maxon), Maya, 3ds Max, Houdini, ZBrush, Modo, Rhino 3D, SketchUp
* **Game Engines**: Unreal Engine (DerivedDataCache, Shader Cache), Unity Editor (`Unity/cache`), Godot Engine
* **Renderers**: Octane Render, Redshift, V-Ray, Arnold Renderer, Corona Renderer, KeyShot
* **Texturing & VFX**: Substance 3D Painter/Designer, Quixel Mixer, Quixel Bridge, Marvelous Designer, Clo3D

### 3. 🎨 Graphic Design & Digital Art
* Photoshop (AutoRecover, Scratch), Illustrator, InDesign, Lightroom, Capture One, Affinity Suite (Designer, Photo, Publisher), CorelDRAW, Clip Studio Paint, Krita, Procreate, Figma, Sketch

### 4. 💻 Development, IDEs & Mobile Toolchains
* **IDEs**: Xcode (`DerivedData`, Archives, iOS DeviceSupport), Android Studio, JetBrains (IntelliJ, WebStorm, PyCharm, CLion, Rider, GoLand), Visual Studio Code, Cursor, Eclipse, Sublime Text
* **Virtualization & Containers**: Docker (Builder cache, dangling images), Podman, VirtualBox, VMware Fusion, Parallels
* **CLI & Package Managers**: Homebrew (`brew cleanup`), npm (`_cacache`), pnpm, Yarn, Bun, Pip, Poetry, Conda, Composer, Cargo, Gradle, Maven

### 5. 🌐 Web Browsers (Desktop & Developer)
* Google Chrome, Apple Safari, Brave, Arc Browser, Microsoft Edge, Mozilla Firefox, Opera, Vivaldi, Tor Browser, DuckDuckGo, Chrome Canary, Firefox Dev Edition

### 6. 💬 Productivity & Communication
* Slack, Discord, Telegram, Microsoft Teams, WhatsApp Desktop, Zoom, Spotify, Notion, Obsidian, Postman, Insomnia, GitHub Desktop, GitKraken, TablePlus, DBeaver

### 7. ⚙️ macOS System Data & OS Bloat
* **Time Machine Local Snapshots** (the #1 secret cause of massive "System Data")
* QuickLook thumbnail databases (`qlmanage -r cache`)
* Diagnostic crash logs & reports (`/Library/Logs/DiagnosticReports`)
* User Trash (`~/.Trash`)

---

## 🛡️ 100% Safety Guarantee
* **Zero Project Loss**: Your project files (`.prproj`, `.aep`, `.blend`, `.psd`, `.xcodeproj`), code repositories, and documents are **never touched**.
* **Zero Login Loss**: Your saved passwords, browser bookmarks, and login sessions remain completely intact.
* **On-Demand Cache**: Purged files are purely temporary render caches, preview proxies, and stale logs that re-generate cleanly when needed.

---

## 🚀 How to Use

### 1. Download & Run
1. Download [**ZeroEmpire.dmg**](https://github.com/pabeledp/ZeroEmpire/raw/main/ZeroEmpire.dmg).
2. Drag **ZeroEmpire** into your **Applications** folder.
3. Open **ZeroEmpire** from Spotlight or Applications.
4. Click **"Clean All Caches Now"** on the popup.
5. Reclaim gigabytes within seconds and get a detailed completion alert!

### 2. Preview Clutter (Optional CLI Scanner)
```bash
./scripts/check_clutter.sh
```

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
