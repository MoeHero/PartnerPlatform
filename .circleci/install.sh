#!/bin/bash

export PROJECT_PATH=$PWD

cd ~
if [ ! -d "$PWD/flutter" ]; then
  echo 下载FlutterSDK...
  wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.5.4-hotfix.2-stable.tar.xz
  echo 解压FlutterSDK...
  tar xf ~/flutter_linux_v1.5.4-hotfix.2-stable.tar.xz
fi

cd $PROJECT_PATH
echo 安装Flutter Packages...
~/flutter/bin/flutter packages get