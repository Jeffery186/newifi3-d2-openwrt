#!/usr/bin/env bash
# ====================================================================
# Build script: Newifi3-D2 OpenWrt + NoDogSplash Captive Portal
# Fork: Jeffery186/newifi3-d2-openwrt (coolsnowwolf/lede)
# Target: ramips/mt7621/d-team_newifi-d2
# Output: openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin
# ====================================================================
# USAGE:
#   chmod +x build-hotspot.sh && ./build-hotspot.sh
#
# Requires: Ubuntu 20.04+ with ~60GB free disk space
# Build time: ~2-4 hours (first run), ~20 min (subsequent, ccache)
# ====================================================================

set -e
export TZ="Asia/Shanghai"

# === CONFIGURATION ===
OP_BUILD_PATH="$PWD"
FIRMWARE_PREFIX="openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin"
PATCH_TAG="v2-hotspot-$(date +%Y%m%d%H%M)"
LEDEDIR="${OP_BUILD_PATH}/lede"

echo "=============================================="
echo " Newifi3-D2 Hotspot Firmware Builder"
echo " Patch tag: ${PATCH_TAG}"
echo "=============================================="

# === STEP 1: System deps ===
echo ""
echo "[STEP 1/7] Installing build dependencies..."
sudo apt-get update -qq
sudo apt-get full-upgrade -y -qq
sudo apt-get install -y -qq \
  ack antlr3 asciidoc autoconf automake autopoint binutils bison \
  build-essential bzip2 ccache cmake cpio curl device-tree-compiler \
  fastjar flex gawk gettext gcc-multilib g++-multilib git gperf \
  haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev \
  libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev \
  libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
  mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf \
  python2.7 python3 python3-pyelftools libpython3-dev qemu-utils \
  rsync scons squashfs-tools subversion swig texinfo uglifyjs \
  upx-ucl unzip vim wget xmlto xxd zlib1g-dev \
  libcppunit-dev libxml-parser-perl

# === STEP 2: Clone lede source ===
echo ""
echo "[STEP 2/7] Cloning coolsnowwolf/lede source..."
if [ -d "${LEDEDIR}" ]; then
  echo "    lede/ already exists — skipping clone (using existing)"
else
  git clone --depth=1 https://github.com/coolsnowwolf/lede.git "${LEDEDIR}"
fi

cd "${LEDEDIR}"

# === STEP 3: Apply feeds + .config ===
echo ""
echo "[STEP 3/7] Updating feeds and applying config..."
./scripts/feeds update -a
./scripts/feeds install -a

rm -rf ./tmp .config

# Copy base .config (from the newifi3-d2-openwrt repo)
if [ -f "${OP_BUILD_PATH}/.config" ]; then
  cp "${OP_BUILD_PATH}/.config" .config
  echo "    Base .config copied from parent repo."
elif [ -f "${OP_BUILD_PATH}/../.config" ]; then
  cp "${OP_BUILD_PATH}/../.config" .config
  echo "    Base .config copied from parent."
else
  echo "    .config not found — using make defconfig + manual patch"
  make defconfig
fi

# === STEP 4: Patch .config with NoDogSplash packages ===
echo ""
echo "[STEP 4/7] Patching .config for NoDogSplash..."

patch_config() {
  local key="$1"
  local val="$2"
  if grep -q "^${key}=" .config; then
    sed -i "s|^# ${key} is not set|${key}=y|" .config 2>/dev/null || true
    sed -i "s|^${key}=n|${key}=y|" .config 2>/dev/null || true
    sed -i "s|^${key}=m|${key}=y|" .config 2>/dev/null || true
  elif ! grep -q "^${key}=y" .config; then
    echo "${key}=y" >> .config
  fi
}

# NoDogSplash core
patch_config "CONFIG_PACKAGE_nodogsplash" "y"
patch_config "CONFIG_DEFAULT_nodogsplash" "y"

# Luci app for nodogsplash (if available in feeds)
# Note: luci-app-nodogsplash is in the lede feeds, will auto-install via feeds

# JSON parser needed by nodogsplash
patch_config "CONFIG_PACKAGE_libjson-c" "y"

# Ensure lighttpd for serving splash pages
patch_config "CONFIG_PACKAGE_lighttpd" "y"
patch_config "CONFIG_DEFAULT_lighttpd" "y"

echo "    NoDogSplash packages added to .config."

# === STEP 5: Copy custom files ===
echo ""
echo "[STEP 5/7] Copying custom hotspot files..."

COPY_DIR="${OP_BUILD_PATH}/files"
if [ -d "${COPY_DIR}" ]; then
  # Copy splash page
  mkdir -p "${LEDEDIR}/etc/nodogsplash"
  cp "${COPY_DIR}/etc/nodogsplash/splash.html" "${LEDEDIR}/etc/nodogsplash/splash.html"

  # Copy UCI config
  cp "${COPY_DIR}/etc/config/nodogsplash" "${LEDEDIR}/etc/config/nodogsplash"

  # Copy init script
  mkdir -p "${LEDEDIR}/etc/init.d"
  cp "${COPY_DIR}/etc/init.d/nodog-enable" "${LEDEDIR}/etc/init.d/nodog-enable"
  chmod +x "${LEDEDIR}/etc/init.d/nodog-enable"

  # Copy uci-defaults
  mkdir -p "${LEDEDIR}/etc/uci-defaults"
  cp "${COPY_DIR}/etc/uci-defaults/99-nodogsplash" "${LEDEDIR}/etc/uci-defaults/99-nodogsplash"

  # Copy LuCI app (custom portal config page)
  if [ -d "${COPY_DIR}/etc/luci-custom" ]; then
    cp -r "${COPY_DIR}/etc/luci-custom"/* "${LEDEDIR}/"
  fi

  echo "    Custom files copied."
else
  echo "    [!] Warning: files/ directory not found at ${COPY_DIR}"
fi

# === STEP 6: Build ===
echo ""
echo "[STEP 6/7] Running make download (fetching all sources)..."
make download -j$(nproc)

echo ""
echo "[STEP 7/7] Building firmware (this takes 2-4 hours first run)..."
echo "    Log saved to: build.log"
make V=s -j$(nproc) 2>&1 | tee "${OP_BUILD_PATH}/build.log"

# === STEP 7: Output ===
echo ""
echo "=============================================="
echo " Build complete!"
echo "=============================================="

OUTPUT_DIR="${LEDEDIR}/bin/targets/ramips/mt7621"
if [ -f "${OUTPUT_DIR}/${FIRMWARE_PREFIX}" ]; then
  cp "${OUTPUT_DIR}/${FIRMWARE_PREFIX}" "${OP_BUILD_PATH}/"
  echo ""
  echo " Firmware: ${OP_BUILD_PATH}/${FIRMWARE_PREFIX}"
  echo " Size: $(du -h "${OP_BUILD_PATH}/${FIRMWARE_PREFIX}" | cut -f1)"
  echo ""
  echo " MD5: $(md5sum "${OP_BUILD_PATH}/${FIRMWARE_PREFIX}" | cut -d' ' -f1)"
else
  echo " [!] Sysupgrade bin not found!"
  echo "    Looking for alternatives..."
  find "${OUTPUT_DIR}" -name "*.bin" -exec ls -lh {} \;
fi

echo ""
echo "[✓] Done. Flash via Breed or LuCI web UI."
echo ""
echo " NEXT STEPS:"
echo "  1. Backup current config: LuCI → System → Backup/Flash"
echo "  2. Flash: openwrt-*-sysupgrade.bin via Breed web panel"
echo "  3. First boot: wait 3 min for uci-defaults to run"
echo "  4. Access LuCI: http://192.168.10.1  (user: root, pass: password)"
echo "  5. Configure portal: LuCI → Services → NoDogSplash"
echo "  6. Connect to WiFi SSID 'RateONE-Guest' to test portal"