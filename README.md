🌍 *Read this in other languages:* [🇺🇦 Українська](README_uk.md)

# 🌐 Lang_Sync (Windows)

A blazing fast extension for Chrome, Edge, and Brave that **remembers your keyboard layout (Ukrainian / English) for each individual tab** and automatically switches it when you navigate between them.

No more typing `ghbdtn` instead of `привіт` when switching from YouTube to your work email.

*From the author: I built this workaround purely for myself because Chromium browsers lack this feature natively, and I was tired of suffering. I'd be genuinely thrilled if a real developer gets inspired and builds a proper, stable alternative without my dirty hacks.*

## 🚀 How it works under the hood
Most similar tools run in the background 24/7. This project works differently:
* **1-millisecond speed:** It uses a native compiled `C#` micro-executable (~4 KB).
* **0% background CPU usage:** There is no persistent process in the Task Manager. It is triggered by the browser (via Native Messaging) only for a split second when you switch tabs, and then immediately "dies".
* **Long-term memory:** Uses `chrome.storage.local`, so the extension tries not to forget the language even if the browser puts the tab to sleep (Memory Saver).

---

## 🛠 How to install (Takes 1 minute)

### Step 1: Add to browser
1. Download the archive from the latest release in the **[Releases]** section (on the right) and extract it. *(IMPORTANT: Do not move the folder after installation!)*
2. Open your browser and go to: `chrome://extensions/`
3. Turn on **Developer mode** in the top right corner.
4. Click **Load unpacked** and select the extracted `MyLangExt` folder.
5. Copy the extension's **ID** (a long string of lowercase letters).

### Step 2: Connect to Windows
1. Open the extracted folder and run `install.bat`.
2. In the black console window, paste your copied ID and press Enter.
3. The script will instantly create a bridge between the browser and your system.

**🔥 FINAL STEP:** Completely close the browser and open it again.

---

## ⚠️ **Two languages only:** 

The script is hardcoded strictly for Ukrainian (0x0422) and English (0x0409) keyboard layouts. 

It ignores other languages.

---

## 🗑 How to uninstall
No special uninstallers needed:
1. Remove the extension from your browser settings (`chrome://extensions/`).
2. Simply delete the folder from your computer.
*(A tiny "dead" path will remain in the system registry, but it affects nothing and doesn't load the system).*
