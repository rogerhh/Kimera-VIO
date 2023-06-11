#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading gflags source to ${GFLAGS_DIR}"

cd $PROJECT_DIR
if [ ! -d $GFLAGS_DIR ]
then
    # Install gflags
    wget https://github.com/gflags/gflags/archive/refs/tags/v2.2.2.zip
    unzip v2.2.2.zip
    rm v2.2.2.zip
    ln -s gflags-2.2.2 gflags
fi

cd $GFLAGS_DIR && mkdir -p build && cd build
cmake ${CMAKE_COMMON_FLAGS} \
      -D GFLAGS_BUILD_SHARED_LIBS=OFF \
      -D GFLAGS_INSTALL_SHARED_LIBS=OFF \
      -D GFLAGS_BUILD_STATIC_LIBS=ON \
      -D GFLAGS_INSTALL_STATIC_LIBS=ON \
      -D INSTALL_SHARED_LIBS=OFF \
      -D INSTALL_STATIC_LIBS=ON \
      .. \
      2>&1 | tee cmake.out

make -j$(nproc) install 2>&1 | tee make.out
