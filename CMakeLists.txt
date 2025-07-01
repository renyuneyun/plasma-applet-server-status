cmake_minimum_required(VERSION 3.16)

project(plasma-serverstatus)

find_package(ECM 5.240.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(KF6Plasma REQUIRED)

plasma_install_package(package org.kde.plasma.serverstatus)
