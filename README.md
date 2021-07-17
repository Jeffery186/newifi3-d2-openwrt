# newifi3-d2-openwrt

> 适用于新三路由器openwrt固件

 - coolsnowwolf分支：https://github.com/coolsnowwolf/lede
 - 2021.04.09最新编译
 - Screenshot文件夹为最新编译的预览截图

## master分支：

master分支为默认分支，常规使用下载改分支的固件即可。

## Dev分支：

Dev分支的固件为校园网专用版本，只保留**核心功能**，体积更小，可以安装Python环境无限制使用校园网；

Dev分支的固件默认管理地址为`192.168.3.1`，密码`password`；

且openwrt软件源已默认配置为腾讯云源(`https://mirrors.cloud.tencent.com/`)：

```bash
opkg update
opkg install python3
opkg install python3-pip
opkg install screen
```

### 设为默认:

升级 pip 到最新的版本 (>=10.0.0) 后进行配置：

```
pip install pip -U
pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple
```

您也可以临时使用本镜像来升级 pip：

```
pip install -i https://mirrors.cloud.tencent.com/pypi/simple --upgrade pip
```

## 使用方法：

 - 下载名字为`openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin`这样的固件，在Breed下刷入，譬如https://raw.githubusercontent.com/zyhibook/newifi3-d2-openwrt/master/openwrt-ramips-mt7621-d-team_newifi-d2-coolsnowwolf-0122-SSRPLUS/openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin

 - 默认管理地址：192.168.1.1；密码：password

## 说明：

coolsnowwolf分支的固件默认用的是SSR PLUS

## 功能截图预览：

![](/Screenshot/2021-04-09_144119.png)
![](/Screenshot/2021-04-09_144159.png)
![](/Screenshot/2021-04-09_144229.png)
![](/Screenshot/2021-04-09_144249.png)
![](/Screenshot/2021-04-09_144318.png)
![](/Screenshot/2021-04-09_144347.png)

 **致谢：**

https://github.com/coolsnowwolf/lede

## 更新日志：

#### 2021年7月17日

- 添加nfs内核(到Actions里面下载)