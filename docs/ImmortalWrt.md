```bash
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
  bzip2 ccache cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext git git-core gperf haveged \
  help2man intltool lib32gcc1 libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev \
  libmpfr-dev libncurses5-dev libncurses5-dev libreadline-dev libssl-dev libtool libz-dev lrzsz mkisofs msmtp \
  nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pip python3-ply python-docutils \
  qemu-utils re2c rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto \
  xxd zlib1g-dev
```

```bash
https://github.com/immortalwrt/immortalwrt/tree/openwrt-21.02
https://github.com/immortalwrt/luci-app-unblockneteasemusic
```
`git clone -b openwrt-21.02 --single-branch https://github.com/immortalwrt/immortalwrt`

`cd immortalwrt`

`./scripts/feeds update -a`

`./scripts/feeds install -a`

`make menuconfig`

`make`

```bash
git status
git pull
```

