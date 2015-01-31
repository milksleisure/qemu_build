#!/bin/bash
DIR=$(dirname $0)
PWD=$(pwd)
PREFIX=$HOME/tools
TARGET=aarch64-softmmu,arm-softmmu,aarch64-linux-user,arm-linux-user

function init_qemu {
    cd qemu
    git submodule init qemu
    git submodule update qemu
    cd qemu
    git submodule init
    git submodule update dtc
    git submodule update pixman
    cd ..
}

function build_qemu {
    if [ ! -f $DIR/qemu/configure ]; then
        init_qemu
    fi
    rm -rf build/
    mkdir -p build/
    cd build
    ../qemu/configure \
        --prefix=$PREFIX \
        --target-list=$TARGET
    make -j64
}

function install_qemu {
    cd build
    make install
}

function main {
    cd $DIR
    echo "Prefix is set as ${PREFIX}"
    if [ "$1" == "build" ]; then
        build_qemu
    elif [ "$1" == "install" ]; then
        install_qemu
    else
        echo "$0 [ build | install ]"
    fi
    cd $PWD
}

main $*
