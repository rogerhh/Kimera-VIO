#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

cd $PROJECT_DIR

echo -e "${SCRIPT_PROMPT} Downloading gtsam source to: ${GTSAM_DIR}"

if [ ! -d $GTSAM_DIR ]
then
    # Install gtsam4.1.1 
    cd $PROJECT_DIR
    git clone https://github.com/borglab/gtsam.git gtsam4.1
    ln -s gtsam4.1 gtsam 
    cd ${PROJECT_DIR}/gtsam && git fetch origin tags/4.1.1 && git reset --hard FETCH_HEAD
fi

cd $GTSAM_DIR && mkdir -p build && cd build

echo -e "$SCRIPT_PROMPT Manually patching $GTSAM_DIR/CMakeLists.txt"
cp $PATCH_DIR/gtsam/CMakeLists.txt $GTSAM_DIR/CMakeLists.txt

cmake ${CMAKE_COMMON_FLAGS} \
      -D GTSAM_BUILD_TESTS=OFF \
      -D GTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
      -D GTSAM_BUILD_UNSTABLE=ON \
      -D GTSAM_TANGENT_PREINTEGRATION=OFF \
      -D GTSAM_BUILD_WITH_MARCH_NATIVE=OFF \
      -D GTSAM_WITH_EIGEN_UNSUPPORTED=ON \
      .. \
      2>&1 | tee cmake.out

make -j$(nproc) install 2>&1 | tee make.out
