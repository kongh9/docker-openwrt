# 使用帮助

本项目用于在树莓派上运行一个基于docker的openwrt容器，使得带无线功能的树莓派变为一个便携式的无线路由器。  
如果树莓派上没有无线功能，那就只能成为有线路由器了。（可用做旁路由，此时需要在主路由上把树莓派openwrt容器的ip地址固定下来并将网关地址指向此openwrt容器的ip地址）  
本项目中包含了一个树莓派zero w的openwrt的docker image.因为树莓派zero w没有有线网卡接口，所以需要自己购买一个带有线网口的扩展板  

## 1. 在microSD卡中刷入树莓派操作系统固件。***刷固件时注意不要打开Wifi***   
## 2. 将microSD插入树莓派，插入网线，加电启动，更新系统。 
```Bash
sudo apt update
sudo apt upgrade
```
## 3. 安装squashfs支持工具，在自己创建docker image时候要用到。  
```Bash
sudo apt install squashfs-tools
```
## 4. 安装docker  
```Bash
curl -sSL https://get.docker.com | sh
```

## 5. 下载本项目文件
```Bash
git clone https://github.com/kongh9/docker-openwrt.git
cd docker-openwrt
```

## 6. 导入image  
### 如果是树莓派zero w可以用这里提供的image。  
```Bash
./import.sh image/image.raspi.zerow.tar openwrt:raspi-zerow
```
### 或者从openwrt官网下载一个固件文件并导入docker中。***（注意：只支持squashfs格式的固件文件）***  
```Bash
./import_firmware.sh https://downloads.openwrt.org/releases/22.03.5/targets/bcm27xx/bcm2708/openwrt-22.03.5-bcm27xx-bcm2708-rpi-squashfs-factory.img.gz openwrt:raspi-zerow
```
## 7. 第一次运行openwrt容器。  
```Bash
./start.sh -c openwrt:raspi-zerow openwrt
```
## 8. 查找一个名为OpenWrt的AP并连接，密码为12345678，访问[http://192.168.2.1](http://192.168.2.1)进入路由器管理界面，默认root密码为12345678    

## 9. 停止openwrt容器  
```Bash
./stop.sh openwrt
```

## 10. 其他操作  
### 启动openwrt容器  
```Bash
./start.sh openwrt
```
### 重启openwrt容器  
```Bash
./restart.sh openwrt
```
### 删除openwrt容器  
```Bash
./remove.sh openwrt
```
