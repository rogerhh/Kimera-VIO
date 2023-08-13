#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading DBoW2 source to ${DBOW2_DIR}"

cd $PROJECT_DIR
if [ ! -d $DBOW2_DIR ]
then
    # Install DBoW2
    git clone https://github.com/dorian3d/DBoW2.git
fi

echo -e "$SCRIPT_PROMPT Manually patching $DBOW2_DIR/CMakeLists.txt"
cp ${PATCH_DIR}/DBoW2/CMakeLists.txt $DBOW2_DIR/CMakeLists.txt
echo -e "$SCRIPT_PROMPT Manually patching $DBOW2_DIR/src/DBoW2.cmake.in"
cp ${PATCH_DIR}/DBoW2/DBoW2.cmake.in $DBOW2_DIR/src/DBoW2.cmake.in

cd $DBOW2_DIR && mkdir -p build && cd build
   
cmake ${CMAKE_COMMON_FLAGS} \
      -D OpenCV_DIR=$INSTALL_DIR/share/OpenCV \
      .. \
      --trace 2>&1 | tee cmake.out

make -j$(nproc) install 2>&1 | tee make.out
