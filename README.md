# newifi3-d2-openwrt

> 适用于新三路由器的openwrt固件

 - Release和Actions现在都默认使用immortalwrt分支源码：https://github.com/immortalwrt/immortalwrt
 - openwrt版本：21.02
 - 2021.10.xx最新编译
 - Screenshot文件夹为最新编译的预览截图
 - 内核：5.4.x
 - 默认管理地址为`192.168.10.1`，密码`password`；

## master分支：

master分支为默认分支，常规使用下载该分支编译的固件即可

## immortalwrt

### 源码

via：`https://github.com/immortalwrt/immortalwrt`

默认管理地址为`192.168.10.1`，密码`password`；

### 下载

下载Release版或Actions都可以

#### Release

`https://github.com/ibook86/newifi3-d2-openwrt/releases`

#### Actions

到`Actions`构建页面 `https://github.com/ibook86/newifi3-d2-openwrt/actions/workflows/build-openwrt-immortalwrt-b1.yml` 下载，刷入时使用含有`immortalwrt`字段的bin固件；

Actions下载页面附带有一同编译的软件包

**Actions编译的固件周一、三、五、六、日的凌晨2点自动开始编译，推荐下载使用**

下载 `immortalwrt-ramips-mt7621-d-team_newifi-d2.manifest` 文件可查看固件内核版本和固件所包含的软件包信息，使用文本编辑器如 `Sublime Text` 等都可以打开查看

## Dev分支：

Dev分支的固件为校园网专用版本，只保留**核心功能**，体积更小，可以安装Python环境无限制使用校园网；

Dev分支的固件默认管理地址为`192.168.3.1`，密码`password`；

且openwrt软件源已默认配置为腾讯云源( `https://mirrors.cloud.tencent.com/` )：

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

您也可以临时使用腾讯云源镜像来升级 pip：

```
pip install -i https://mirrors.cloud.tencent.com/pypi/simple --upgrade pip
```

## ~~使用方法：~~

 - ~~下载名字为 `openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin` 这样的固件，下载地址： `https://github.com/ibook86/newifi3-d2-openwrt/releases` ，然后在Breed下刷入，譬如 `https://github.com/ibook86/newifi3-d2-openwrt/releases/download/2021.07.20-1005/openwrt-ramips-mt7621-d-team_newifi-d2-squashfs-sysupgrade.bin`~~

 - ~~默认后台管理地址：192.168.1.1；密码：password~~

## 说明：

immortalwrt分支源码编译的固件默认用的是SSR PLUS

## 功能截图预览：

![](/Screenshot/2021-04-09_144119.png)
![](/Screenshot/2021-04-09_144159.png)
![](/Screenshot/2021-04-09_144229.png)
![](/Screenshot/2021-04-09_144249.png)
![](/Screenshot/2021-04-09_144318.png)
![](/Screenshot/2021-04-09_144347.png)

 **致谢：**

https://github.com/coolsnowwolf/lede

https://github.com/immortalwrt/immortalwrt

## 克隆本项目

由于历史原因，克隆时请加上 `--depth=1` 参数

如：

```shell
git clone --depth=1 https://github.com/ibook86/newifi3-d2-openwrt.git
```

or:

```shell
git clone --depth=1 git@github.com:ibook86/newifi3-d2-openwrt.git
```

## 更新日志：

#### 2021.10.19

- openwrt源码改用immortalwrt

#### 2021年7月17日

- 添加nfs内核