#!/usr/bin/env bash
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
  bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
  git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
  libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
  mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pyelftools \
  libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip \
  vim wget xmlto xxd zlib1g-dev

export OP_BUILD_PATH=$PWD
git clone https://github.com/coolsnowwolf/lede.git

cd "${OP_BUILD_PATH}"/lede || exit
./scripts/feeds update -a && ./scripts/feeds install -a
rm -rf ./tmp && rm -rf .config
mv "${OP_BUILD_PATH}"/.config "${OP_BUILD_PATH}"/lede/.config
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
make defconfig
make download -j8
make V=s -j$(nproc)
echo "FILE_DATE=$(date +%Y%m%d%H%M)" >>"$GITHUB_ENV"
