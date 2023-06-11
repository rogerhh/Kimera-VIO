#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

cd $PROJECT_DIR

echo -e "${SCRIPT_PROMPT} Downloading euroc to ${EUROC_DIR}"

if [ ! -d $EUROC_DIR ]
then
    # Download and extract EuRoC dataset.
    wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_01_easy/V1_01_easy.zip
    mkdir -p $EUROC_DIR && unzip V1_01_easy.zip -d $EUROC_DIR

    # Yamelize euroc dataset
    $PROJECT_DIR/Kimera-VIO/scripts/euroc/yamelize.bash -p $EUROC_DIR
fi

echo -e "$SCRIPT_PROMPT Manually patching $KIMERA_VIO_DIR/CMakeLists.txt"
cp ${PATCH_DIR}/Kimera-VIO/CMakeLists.txt $KIMERA_VIO_DIR/CMakeLists.txt

cd $KIMERA_VIO_DIR && mkdir -p build && cd build
cmake ${CMAKE_COMMON_FLAGS} \
      -D KIMERA_BUILD_TESTS=OFF \
      .. \
      --trace 2>&1 | tee cmake.out

make -j$(nproc) --trace 2>&1 | tee make.out
