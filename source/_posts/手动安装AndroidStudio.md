---
title: 手动安装AndroidStudio
abbrlink: 61926
date: 2019-02-18 14:32:52
tags: android-studio
---

因为不知名的原因会导致我们在安装`Android Studio`的时候，下载文件特别慢，我们可以在它下载过程中，获取到它的下载链接，然后用迅雷下载速度会快很多，所以这里写了手动安装`Android Studio`的过程,部分过程可能会有差异，需要灵活运用，时时关注`Android Studio`在下载过程中的日志进行调整。

<!-- more -->

### 手动安装 Android Studio

手动通过迅雷下载如下安装包：

https://dl.google.com/android/repository/platform-tools_r28.0.0-windows.zip

https://dl.google.com/android/repository/platform-28_r04.zip

https://dl.google.com/android/repository/build-tools_r28.0.1-windows.zip

https://dl.google.com/android/repository/google_m2repository_gms_v11_3_rc05_wear_2_0_5.zip

https://dl.google.com/android/repository/emulator-windows-4848055.zip

https://dl.google.com/android/repository/3534162-studio.sdk-patcher.zip.bak

https://dl.google.com/android/repository/sdk-tools-windows-4333796.zip

https://dl.google.com/android/repository/android_m2repository_r47.zip

https://dl.google.com/android/repository/sources-28_r01.zip

https://dl.google.com/android/repository/extras/intel/haxm-windows_v7_3_2.zip

https://dl.google.com/android/repository/sys-img/google_apis/x86-28_r08.zip

下载完成后逐个解压缩放入 SDK 目录，如下：

1、创建 `SDK` 目录，并 copy 上述文件到 `SDK` 目录

2、`platform-tools_r28.0.0-windows.zip` 直接接受压缩到本地目录：`SDK\platform-tools`

3、`platform-28_r04.zip` 解压缩后得到 `android-9` 文件夹，把 `android-9` 修改为 `android-28`，放到本地目录：`SDK\platforms\android-28`

4、`build-tools_r28.0.1-windows.zip` 解压缩后得到 `android-9` 文件夹，把 `android-9` 修改为 `28.0.1`，放到本地目录：`SDK\build-tools\28.0.1`

5、`google_m2repository_gms_v11_3_rc05_wear_2_0_5.zip` 解压缩后得到 `m2repository` 文件夹，放到本地目录：`SDK\extras\google\m2repository`

6、`emulator-windows-4848055.zip` 解压缩后得到 `emulator` 文件夹，放到本地目录：`SDK\emulator`

7、`3534162-studio.sdk-patcher.zip.bak` 修改名称为 `3534162-studio.sdk-patcher.zip`，解压缩后得到 `sdk-patcher`，修改名称为 `patcher` 放到本地目录：`SDK\patcher\v4`

8、`sdk-tools-windows-4333796.zip` 解压缩后得到 `tools` 文件夹，放到本地目录：`SDK\tools`

9、`android_m2repository_r47.zip` 解压缩后得到 `m2repository`，放到本地目录：`SDK\extras\android\m2repository`

10、 `sources-28_r01.zip` 解压缩后得到 `src` 文件夹重命名为 `android-28`，放到本地目录 `SDK\sources\android-28`

11、`haxm-windows_v7_3_2.zip` 解压到本地目录 `SDK\extras\intel\Hardware_Accelerated_Execution_Manager`,没有的目录新建目录

12、`google_apis/x86-28_r08.zip` 解压放到本地目录 `SDK\system-images\android-28\google_apis\x86`

上述完成后重新启动 `Android Studio`，创建项目时选择 `sdk` 指定到本地 `SDK` 目录。`Android Studio` 检查 `SDK` 目录的文件并显示成功。
