<div align="center">

<img src="assets/icon_1024.png" width="120" height="120" alt="ZeroEmpire Logo" style="border-radius: 26px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);"/>

# 👑 ZeroEmpire
### 1-Click System Storage & Cache Purger for macOS

[![macOS](https://img.shields.io/badge/macOS-12.0%2B-000000?style=flat-square&logo=apple&logoColor=white)](https://apple.com)
[![Swift](https://img.shields.io/badge/Language-Swift%205-FA7343?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.flat-square)](LICENSE)
[![Release](https://img.shields.io/badge/Version-1.0.0-emerald?style=flat-square)](https://github.com/pabeledp/ZeroEmpire/releases)

<p align="center">
  <b>Tired of Mac's mysterious "System Data" eating all your disk space?</b><br/>
  ZeroEmpire instantly purges gigabytes of Adobe Media Caches, Browser temporary data, Time Machine local snapshots, and system clutter in 1-Click.
</p>

---

### ⬇️ Download ZeroEmpire for Mac

<a href="https://github.com/pabeledp/ZeroEmpire/raw/main/ZeroEmpire.dmg">
  <img src="https://custom-icon-badges.demolab.com/badge/DOWNLOAD-ZeroEmpire.dmg%20(Direct%20Install)-007AFF?style=for-the-badge&logo=download&logoColor=white" height="48" alt="Download ZeroEmpire"/>
</a>

<br/>

<sub>Version 1.0.0 • Native macOS Universal App • Size: ~1.8 MB</sub>

---

</div>

<br/>

## ⚡ The Problem
If you are a video editor, graphic designer, developer, or heavy web user on a Mac:
- **Adobe Creative Cloud** silently accumulates **20 GB – 100+ GB** in `Media Cache Files`, `Peak Files`, and scratch caches without auto-clearing.
- **macOS System Data** bloats unexpectedly due to hidden **Time Machine local snapshots** and diagnostic logs.
- **Browsers (Chrome, Brave, Arc, Safari)** store gigabytes of cached media and scripts.

**ZeroEmpire** solves this with a **single, beautiful confirmation modal**—no terminal commands, no scary code, and zero background battery drain.

---

## 🎯 What Gets Cleaned?

| Category | Cleaned Assets | Safety Guarantee |
| :--- | :--- | :---: |
| **🎨 Adobe Creative Cloud** | • Media Cache Files & Media Cache<br/>• Peak Files (.cfa / .pek)<br/>• CameraRaw Cache<br/>• Premiere & After Effects Auto-Saves<br/>• Photoshop AutoRecover | **100% Safe**<br/><sub>(Rebuilds on-demand, project files untouched)</sub> |
| **🌐 Web Browsers** | • Google Chrome Cache<br/>• Brave Browser Cache<br/>• Apple Safari Cache<br/>• Arc Browser Cache<br/>• Microsoft Edge & Firefox | **100% Safe**<br/><sub>(Bookmarks, history & passwords preserved)</sub> |
| **⚙️ macOS System Data** | • Time Machine Local Snapshots (`tmutil`)<br/>• Diagnostic Crash Reports & System Logs<br/>• QuickLook Thumbnails Database (`qlmanage`) | **100% Safe**<br/><sub>(Reclaims hidden 'System Data')</sub> |
| **🛠️ Dev Tools (Optional)** | • Xcode DerivedData<br/>• CocoaPods Cache<br/>• npm `_cacache` & pip Cache | **100% Safe**<br/><sub>(Safe dev artifact purge)</sub> |
| **🗑️ Trash** | • Empties User Trash (`~/.Trash`) | **Clean** |

---

## 🚀 How to Install & Use

### Method 1: Download & Install (Easiest)
1. Click the [**Download ZeroEmpire.dmg**](https://github.com/pabeledp/ZeroEmpire/raw/main/ZeroEmpire.dmg) button above.
2. Open the `.dmg` file and drag **ZeroEmpire** into your **Applications** folder.
3. Launch **ZeroEmpire** from Spotlight (`Cmd + Space`), Launchpad, or your Dock.
4. Click **"Clean Now (Purge Junk)"** on the native confirmation prompt.
5. Reclaim gigabytes within seconds and get an instant summary notification!

### Method 2: Preview Clutter Before Cleaning
Want to see exactly how much junk is stored on your Mac right now? Run the built-in scanner:
```bash
./scripts/check_clutter.sh
```

---

## 🛠️ Tech Stack & Architecture

- **Core Engine**: Pure native **Swift (AppKit)** compiled binary.
- **UI & Modal**: macOS Cocoa `NSAlert` modal and UserNotification framework.
- **Zero Dependencies**: Does **not** require Python, Node.js, Electron, or external package managers.
- **Lightweight**: Uses less than 2 MB total disk space.

---

## 🏗️ Building from Source

If you want to compile `ZeroEmpire.app` yourself:

```bash
# Clone the repository
git clone https://github.com/pabeledp/ZeroEmpire.git
cd ZeroEmpire

# Compile native binary and assemble app bundle
swiftc -O src/main.swift -o ZeroEmpire.app/Contents/MacOS/ZeroEmpire
cp src/Info.plist ZeroEmpire.app/Contents/Info.plist
cp assets/AppIcon.icns ZeroEmpire.app/Contents/Resources/AppIcon.icns
codesign --force --deep --sign - ZeroEmpire.app

# Optional: Generate DMG
./create_dmg.sh
```

---

## 🇧🇩 বাংলা নির্দেশিকা (Bangla Guide)

### কেন জিরো-এম্পায়ার (ZeroEmpire)?
Mac ব্যবহারকারীদের ডিস্ক স্টোরেজ ফুল হওয়ার অন্যতম বড় কারণ হলো **System Data** এবং **Adobe Cache**। আপনি প্রিমিয়ার প্রো বা আফটার ইফেক্টসে কাজ করলে কয়েক দিনেই ২০-৫০ জিবি মিডিয়া ক্যাশ জমে যায়। 

**ZeroEmpire** কোনো অতিরিক্ত ব্লোটওয়্যার ছাড়াই মাত্র **১ ক্লিকে** একটি নিরাপদ পপআপের মাধ্যমে অপ্রয়োজনীয় ক্যাশ ও লোকাল স্ন্যাপশট মুছে দেয়।

* **ডাউনলোড লিংক**: ওপরের [**Download ZeroEmpire.dmg**](https://github.com/pabeledp/ZeroEmpire/raw/main/ZeroEmpire.dmg) বাটনে ক্লিক করে ফাইলটি নামিয়ে আপনার অ্যাপ্লিকেশনে ড্র্যাগ করুন।
* **ব্যবহার**: অ্যাপটি ওপেন করে **"Clean Now"** চাপুন। কাজ শেষ হলে কত জিবি খালি হয়েছে তা নোটিফিকেশনে জানিয়ে দেওয়া হবে।

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).

<div align="center">
<sub>Crafted with precision for creators and power users on macOS.</sub>
</div>
