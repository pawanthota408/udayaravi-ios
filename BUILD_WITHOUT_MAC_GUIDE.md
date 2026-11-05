# How to Build & Install UdayaRavi iOS App Without a Mac or Xcode

You **do not need a Mac or Xcode** on your computer. You can compile the `.ipa` using free cloud build runners and install it on any iPhone directly from Windows.

---

## Step 1: Build the `.ipa` in the Cloud for Free (GitHub Actions)

We have already configured a GitHub Actions cloud builder at [`.github/workflows/build-ipa.yml`](file:///c:/Users/balaj_xnvbs24/OneDrive/Desktop/udayaravi-admin%20(2)/udayaravi-admin/.github/workflows/build-ipa.yml). GitHub provides free virtual macOS machines with Xcode pre-installed.

### How to trigger the cloud build:

1. Create a repository on [GitHub.com](https://github.com) (can be private or public).
2. Push your project to GitHub from Windows Terminal:
   ```bash
   git init
   git add .
   git commit -m "Complete UdayaRavi iOS and Web suite"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
   git push -u origin main
   ```
3. Open your repository on **github.com**:
   - Click the **Actions** tab at the top.
   - Click **Build iOS Debug IPA** on the left menu.
   - Click **Run workflow** ➔ **Run workflow**.
4. GitHub's cloud Mac will compile the Swift code in ~3 minutes.
5. Under **Artifacts** at the bottom of the completed run, click **`UdayaraviCreations-Debug-IPA`** to download your `UdayaraviCreations.ipa` file directly to your Windows PC!

---

## Step 2: Install the `.ipa` on Your iPhone from Windows

Once you download the `.ipa` file to your Windows PC, use any of the free methods below:

### Method A: Sideloadly (Recommended — Easiest for Windows)
1. Download and install **Sideloadly** on Windows: [https://sideloadly.io](https://sideloadly.io)
2. Connect your iPhone to your Windows PC with a USB cable (tap **Trust This Computer** on your iPhone).
3. Open Sideloadly on Windows:
   - Drag and drop **`UdayaraviCreations.ipa`** into the Sideloadly window.
   - Enter your personal Apple ID email (free personal account, no paid developer account required).
   - Click **Start**.
4. Sideloadly signs and installs the app onto your iPhone in ~60 seconds!
5. On your iPhone:
   - Go to **Settings ➔ General ➔ VPN & Device Management**.
   - Tap your Apple ID and tap **Trust "Your Name"**.
   - Open **UdayaRavi Creations** on your home screen!

---

### Method B: InstallOnAir / Diawi (Wireless Over-The-Air Install)
1. Go to [https://www.installonair.com](https://www.installonair.com) or [https://www.diawi.com](https://www.diawi.com).
2. Drag and drop `UdayaraviCreations.ipa`.
3. It generates an install link and QR code.
4. Scan the QR code with your iPhone camera to install wirelessly without cables.

---

## Alternative: Online Browser-Based Testing (No iPhone needed either)
If you do not have an iPhone and want to test the app interactively in your browser:
* Upload the `.ipa` or `.app` to [Appetize.io](https://appetize.io) to run an interactive iPhone simulator right inside Google Chrome or Edge.

