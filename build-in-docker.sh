#!/bin/bash
cd "$BUILD_PATH/immortalwrt" && git pull && \
./scripts/feeds update -a && ./scripts/feeds install -a && \
rm -rf ./tmp && rm -rf .config

wget -O .config https://raw.githubusercontent.com/ibook86/newifi3-d2-openwrt/master/.config_immortalwrt && \
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

make defconfig && make -j8 download && make -j$(nproc)