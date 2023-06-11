#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading glog source to ${GLOG_DIR}"

cd $PROJECT_DIR
if [ ! -d $GLOG_DIR ]
then
    # Install glog
    wget https://github.com/google/glog/archive/refs/tags/v0.3.5.zip
    unzip v0.3.5.zip
    rm v0.3.5.zip
    ln -s glog-0.3.5 $GLOG_DIR
fi

echo -e "$SCRIPT_PROMPT Manually patching $GLOG_DIR/CMakeLists.txt"
cp ${PATCH_DIR}/glog/CMakeLists.txt $GLOG_DIR/CMakeLists.txt

cd $GLOG_DIR && mkdir -p build && cd build
cmake ${CMAKE_COMMON_FLAGS} \
      -D INSTALL_SHARED_LIBS=OFF \
      -D CMAKE_CXX_STANDARD=11 \
      -D GFLAGS_DIR=$INSTALL_DIR \
      .. \
      --trace 2>&1 | tee cmake.out

make -j$(nproc) install 2>&1 | tee make.out


