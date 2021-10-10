# newifi3-d2-openwrt

> 适用于新三路由器的openwrt固件

 - coolsnowwolf分支源码：https://github.com/coolsnowwolf/lede
 - 2021.10.xx最新编译
 - Screenshot文件夹为最新编译的预览截图

## master分支：

master分支为默认分支，常规使用下载该分支编译的固件即可

## immortalwrt

### 源码

via：`https://github.com/immortalwrt/immortalwrt`

默认管理地址为`192.168.10.1`，密码`password`；

到`Actions`构建页面`https://github.com/ibook86/newifi3-d2-openwrt/actions/workflows/build-openwrt-immortalwrt-b1.yml`下载，刷入时使用含有`immortalwrt`字段的bin固件。

**该固件每天凌晨三点自动开始编译，推荐下载使用**

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

 - 下载名字为`openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin`这样的固件，下载地址：https://github.com/ibook86/newifi3-d2-openwrt/releases，然后在Breed下刷入，譬如https://github.com/ibook86/newifi3-d2-openwrt/releases/download/2021.07.20-1005/openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin

 - 默认后台管理地址：192.168.1.1；密码：password

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

- 添加nfs内核

## 注意：

- Actions编译的固件可以自行到Actions页面的Artifacts处下载，Actions编译的为Beta版，并不能保证其稳定性(追新折腾党请无视此条，也可以Fork后自行编译)


- 追求稳定的请到Releases处下载(本人日用的就是最新的Releases版)
