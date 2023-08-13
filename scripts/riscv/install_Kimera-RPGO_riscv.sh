#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading Kimera-RPGO source to ${KIMERA_RPGO_DIR}"

cd $PROJECT_DIR
if [ ! -d $KIMERA_RPGO_DIR ]
then
    # Install RobustPGO
    git clone https://github.com/MIT-SPARK/Kimera-RPGO.git
fi

echo -e "$SCRIPT_PROMPT Manually patching $KIMERA_RPGO_DIR/CMakeLists.txt"
cp ${PATCH_DIR}/Kimera-RPGO/CMakeLists.txt $KIMERA_RPGO_DIR/CMakeLists.txt
echo -e "$SCRIPT_PROMPT Manually patching $KIMERA_RPGO_DIR/cmake/KimeraRPGOConfig.cmake.in"
cp ${PATCH_DIR}/Kimera-RPGO/KimeraRPGOConfig.cmake.in $KIMERA_RPGO_DIR/cmake/KimeraRPGOConfig.cmake.in

cd $KIMERA_RPGO_DIR && mkdir -p build && cd build

cmake ${CMAKE_COMMON_FLAGS} \
      .. \
      --trace 2>&1 | tee cmake.out

make -j$(nproc) install 2>&1 | tee make.out
