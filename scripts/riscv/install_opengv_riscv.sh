#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading OpenGV source to ${OPENGV_DIR}"

cd $PROJECT_DIR
if [ ! -d $OPENGV_DIR ]
then
    # Install Open_GV
    git clone https://github.com/laurentkneip/opengv
fi

echo -e "$SCRIPT_PROMPT Manually patching $OPENGV_DIR/CMakeLists.txt"
cp ${PATCH_DIR}/opengv/CMakeLists.txt $OPENGV_DIR/CMakeLists.txt

cd $OPENGV_DIR && mkdir -p build && cd build 
cmake ${CMAKE_COMMON_FLAGS} \
      -D EIGEN_INCLUDE_DIRS=$GTSAM_DIR/gtsam/3rdparty/Eigen \
      -D EIGEN_INCLUDE_DIR=$GTSAM_DIR/gtsam/3rdparty/Eigen \
      .. \
      --trace 2>&1 | tee cmake.out

make -j$(nrpoc) install 2>&1 | tee make.out
