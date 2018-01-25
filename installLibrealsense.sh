#!/bin/bash
# Install the Intel Realsense library librealsense on a Jetson TX2 Development Kit
# Copyright (c) 2016-17 Jetsonhacks 
# MIT License
INSTALL_DIR=$PWD
sudo apt-get update
sudo apt-get install libusb-1.0-0-dev pkg-config -y
sudo apt-get install libglfw3-dev -y
sudo apt-get install qtcreator -y
sudo apt-get install cmake-curses-gui -y
sudo apt-get install -y qdbus qmlscene qt5-default qt5-qmake qtbase5-dev-tools qtchooser qtdeclarative5-dev xbitmaps xterm libqt5svg5-dev qttools5-dev qtscript5-dev qtdeclarative5-folderlistmodel-plugin qtdeclarative5-controls-plugin
sudo apt-get install -y libgtk-3-dev libudev-dev

# Install librealsense into home directory
cd $HOME
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
# Checkout version 1.12.1 of librealsense, last tested version
git checkout development # Patch the uvcvideo internal module fix
patch -p1 -i $INSTALL_DIR/patches/uvc-v4l2.patch
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
# Now compile librealsense and install
mkdir build && cd build
# Build examples, including graphical ones
cmake ../ -DBUILD_EXAMPLES=true
# The library will be installed in /usr/local/lib, header files in /usr/local/include
# The demos, tutorials and tests will located in /usr/local/bin.
make && sudo make install



