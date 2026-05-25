# ====================================================================
# README.md — Newifi3-D2 OpenWrt + Captive Portal Hotspot
# ====================================================================

## 🔷 What This Is

A modified version of Jeffery186/newifi3-d2-openwrt with **NoDogSplash captive portal** pre-installed.
Guest WiFi users connect → see a branded landing page → wait 10s → click "Go Online" → get internet access.

## 🔷 Target Device

- **Router:** Newifi 3 D2 (JDC NR5001Q / JDC newifi D2)
- **SoC:** MediaTek MT7621 (MIPS 24KEc, 880MHz dual-core)
- **RAM:** 128MB DDR3
- **Flash:** 32MB SPI NAND
- **WiFi:** MT7603E (2.4GHz) + MT7612EN (5GHz)
- **OpenWrt:** 21.02 / Linux 5.4.x
- **Base:** coolsnowwolf/lede

## 🔷 Package Selection: Why NoDogSplash

| Package | RAM Usage | Complexity | Verdict |
|---------|-----------|------------|---------|
| **NoDogSplash** | ~3MB | Single binary, one config | ✅ SELECTED |
| openNDS | ~8MB | Complex, needs FAS | ❌ Overkill |
| Coova-Chilli | ~15MB+ | MySQL dependency, heavy | ❌ Too heavy for 128MB |
| Custom iptables | Variable | No HTTP redirect, fragile | ❌ Reinventing wheel |

**NoDogSplash wins** on Newifi3-D2's 128MB RAM because:
- Single binary, no database
- Built-in splash page templating (Lua)
- MAC-based auth (no user accounts)
- UCI config + LuCI integration
- Well maintained in OpenWrt feeds

## 🔷 Auth Flow (How It Works)

```
Guest connects to WiFi SSID "RateONE-Guest"
         ↓
   DHCP: 192.168.10.x/24
         ↓
   Opens any website (http://anything.com)
         ↓
   iptables REDIRECT (port 80 → 2050)
         ↓
   NoDogSplash serves splash.html
         ↓
   [10 second countdown on page]
         ↓
   User clicks "Go Online"
   → POST /nodogsplash_auth?tok={token}&redir={url}
         ↓
   NoDogSplash marks MAC as "allowed"
   → iptables: allow that MAC full internet
         ↓
   Session timer starts (default: 60 min)
   After timeout → back to splash page
```

## 🔷 Private WiFi Separation

NoDogSplash only binds to `wlan1` (guest SSID).
Private WiFi on `wlan0` is completely untouched — normal access, no portal.

Config in `/etc/config/nodogsplash`:
```
option gatewayinterface 'wlan1'
```

## 🔷 File Structure

```
newifi3-d2-openwrt/
├── .config                          ← base .config (from Jeffery186 repo)
├── build.sh                        ← original build script
│
├── files/                          ← CUSTOM FILES ADDED HERE
│   ├── etc/
│   │   ├── config/
│   │   │   └── nodogsplash          ← UCI config (portal settings)
│   │   ├── nodogsplash/
│   │   │   └── splash.html          ← Landing page (Lua template)
│   │   ├── init.d/
│   │   │   └── nodog-enable         ← Boot script (creates guest AP)
│   │   └── uci-defaults/
│   │       └── 99-nodogsplash       ← First-boot defaults
│   └── usr/
│       └── lib/
│           └── lua/
│               └── luci/
│                   └── model/
│                       └── cbi/
│                           └── nodogsplash.lua  ← LuCI config page
│
├── build-hotspot.sh                 ← BUILD SCRIPT (use this!)
└── README.md
```

## 🔷 Configurable Options (via LuCI → Services → NoDogSplash)

| Setting | Default | Description |
|---------|---------|-------------|
| Enable Portal | 1 | Turn portal on/off |
| Gateway Interface | wlan1 | Guest WiFi interface |
| Ad Headline | "Welcome to RateONE Guest WiFi" | Top text on banner |
| Ad Subtext | "Enjoy 1 hour free WiFi" | Sub text |
| Ad Image URL | (empty) | Full URL to banner image |
| Advertised By | RateONE | Brand name shown |
| WhatsApp Number | 60123456789 | Opens wa.me link |
| WhatsApp Label | "Chat with Us on WhatsApp" | Button text |
| Countdown Seconds | 10 | Wait time before button enables |
| Session Duration | 60 min | How long before re-auth required |
| Max Clients | 50 | Max concurrent guests |
| Idle Timeout | 30 min | Kick idle clients |

## 🔷 Build Steps

### Option A: GitHub Actions (Recommended — no local machine needed)

1. **Fork** `https://github.com/Jeffery186/newifi3-d2-openwrt` to your GitHub account

2. **Create a new branch:**
   ```bash
   git checkout -b hotspot-v1
   ```

3. **Copy all files from `newifi3-hotspot/files/`** into the repo root:
   ```bash
   cp -r newifi3-hotspot/files/* ./
   ```

4. **Copy `build-hotspot.sh`** to repo root:
   ```bash
   cp newifi3-hotspot/build-hotspot.sh ./
   ```

5. **Create a new GitHub Actions workflow** `.github/workflows/build-hotspot.yml`:
   ```yaml
   name: Build-Hotspot-Firmware

   on:
     workflow_dispatch:
     schedule:
       - cron: '0 2 * * 3,6'   # Wed & Sat 02:00 UTC

   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4

         - name: Build
           run: |
             chmod +x build-hotspot.sh
             ./build-hotspot.sh

         - name: Upload firmware
           uses: actions/upload-artifact@v4
           with:
             name: newifi3-d2-hotspot-firmware
             path: |
               openwrt-*-sysupgrade.bin
               build.log
   ```

6. **Push to GitHub** → Actions tab → Run workflow

7. **Download** `.bin` from Artifacts

### Option B: Local Build (WSL2 / Ubuntu 20.04+)

```bash
# ~60GB disk free required
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y git ccache build-essential

# Clone your fork
git clone --depth=1 https://github.com/YOUR_GITHUB/newifi3-d2-openwrt.git
cd newifi3-d2-openwrt

# Copy files
cp -r /path/to/newifi3-hotspot/files/* ./
chmod +x build-hotspot.sh

# Run build (~2-4 hours first time, uses ccache)
./build-hotspot.sh

# Output: openwrt-*-sysupgrade.bin
```

## 🔷 Flash Instructions

### ⚠️ BEFORE FLASHING — MANDATORY BACKUP

1. **SSH to current router at 192.168.10.1:**
   ```bash
   ssh root@192.168.10.1
   # password: password
   ```

2. **Backup config files:**
   ```bash
   mkdir /tmp/backup
   cat /etc/config/wireless > /tmp/backup/wireless.bak
   cat /etc/config/network  > /tmp/backup/network.bak
   cat /etc/config/dhcp     > /tmp/backup/dhcp.bak
   cat /etc/config/firewall > /tmp/backup/firewall.bak
   ```

3. **Download backups via SCP:**
   ```bash
   # On your Mac/PC:
   scp -r root@192.168.10.1:/tmp/backup ./
   ```

4. **Backup current firmware (for rollback):**
   - LuCI → System → Backup/Flash Firmware → Backup Download

### Flashing via Breed Bootloader

1. **Enter Breed:** Power off → Hold RESET 5 seconds → Power on → Release after 2s
2. **Web panel:** `http://192.168.1.1`
3. **Firmware:** Upload `openwrt-*-sysupgrade.bin`
4. **⚠️ DO NOT check "Flash image, keep settings"** (clean flash recommended)
5. **Wait 3 minutes** — do NOT power off
6. **Access:** `http://192.168.10.1` (LuCI)

### Flashing via LuCI

1. LuCI → System → Flash Firmware
2. Upload `.bin` file
3. Uncheck "Keep settings"
4. Click "Flash image"
5. Wait 3 minutes

## 🔷 Rollback

1. Enter Breed bootloader (`http://192.168.1.1`)
2. Upload the original Jeffery186 `.bin` from GitHub Releases
3. Or restore from your backup `.bin` file

## 🔷 First Boot Setup

After first boot (3 min), SSH and verify:

```bash
# Check NoDogSplash is running
ps | grep nodogsplash

# Check guest WiFi is up
iw dev

# Check UCI config
uci show nodogsplash

# View live clients
cat /tmp/ndsctl.json 2>/dev/null || echo "No clients yet"
```

### Configure via LuCI

1. **Enable captive portal:** LuCI → Services → NoDogSplash → General → Enabled → Save & Apply
2. **Set ad image URL:** Services → NoDogSplash → Landing Page → Ad Image URL
3. **Set WhatsApp number:** Services → NoDogSplash → Landing Page → WhatsApp Number
4. **Adjust countdown:** Landing Page → Countdown Seconds
5. **Restart after config changes:**
   ```bash
   /etc/init.d/nodogsplash restart
   ```

## 🔷 Troubleshooting

### Portal not redirecting
```bash
# Check iptables redirect rules
iptables -t nat -L -n | grep 2050

# Check nodogsplash is listening
netstat -tlnp | grep 2050

# Restart
/etc/init.d/nodogsplash restart
```

### Guest WiFi not showing
```bash
# Check wireless config
uci show wireless

# Bring up guest interface manually
ip link set wlan1 up
ip addr add 192.168.10.1/24 dev wlan1

# Re-enable
/etc/init.d/nodog-enable start
```

### Button not enabling after countdown
Check browser console for JavaScript errors. Ensure `{{token}}` and `{{redirect}}` variables are being passed by NoDogSplash (v4.x+ required for Lua templates).

### Session expires too fast
```bash
uci set nodogsplash.general.sessiontimeout='7200'  # 2 hours
uci commit nodogsplash
/etc/init.d/nodogsplash restart
```

## 🔷 Updating / Rebuilding in Future

1. Pull latest from upstream:
   ```bash
   git remote add upstream https://github.com/Jeffery186/newifi3-d2-openwrt.git
   git fetch upstream
   git merge upstream/master
   # Resolve conflicts if any
   ```
2. Copy your `files/` directory again (don't overwrite)
3. Run `./build-hotspot.sh`

## 🔷 Output Firmware

- **Filename:** `openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin`
- **Size:** ~25-32 MB
- **Flash via:** Breed web panel (recommended) or LuCI sysupgrade
- **Default IP:** `192.168.10.1`
- **Default password:** `password`
- **SSH:** `root@192.168.10.1`

## 🔷 What's Included in This Build

| Package | Purpose |
|---------|---------|
| nodogsplash | Captive portal gateway |
| luci-app-nodogsplash | LuCI admin page |
| lighttpd | HTTP server for splash pages |
| libjson-c | JSON parsing for NDS |
| kmod-mt7603e | 2.4GHz WiFi driver |
| kmod-mt76x2e | 5GHz WiFi driver |
| luci-app-mtwifi | Multi-SSID (guest AP) |

## 🔷 License

Based on Jeffery186/newifi3-d2-openwrt which uses coolsnowwolf/lede (OpenWrt). All custom files released under MIT License.

---

**Built by LogiSoftAi for Vincent Ang — RateONE Smart WiFi** 🤖