#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/color.sh

export SCRIPT_PROMPT="${GREEN}${BOLD}[Kimera-VIO RISC-V Install]${NC}${UNBOLD}"
export PROJECT_DIR="$(readlink -f ${SCRIPT_DIR}/../../..)"
export INSTALL_DIR="${PROJECT_DIR}/local"
export PATCH_DIR="${SCRIPT_DIR}/patch_files"
export CMAKE_TOOLCHAIN_FILE="${SCRIPT_DIR}/riscv.cmake"
export CMAKE_COMMON_FLAGS="-DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DBUILD_SHARED_LIBS=OFF"
export CHIPYARD_HOME="$(realpath "${PROJECT_DIR}")"

export BOOST_DIR=${PROJECT_DIR}/boost
export OPENCV_DIR=${PROJECT_DIR}/opencv
export OPENCV_CONTRIB_DIR=${PROJECT_DIR}/opencv_contrib
export OPENGV_DIR=${PROJECT_DIR}/opengv
export GTSAM_DIR=${PROJECT_DIR}/gtsam
export DBOW2_DIR=${PROJECT_DIR}/DBoW2
export GLOG_DIR=${PROJECT_DIR}/glog
export GFLAGS_DIR=${PROJECT_DIR}/gflags
export KIMERA_RPGO_DIR=${PROJECT_DIR}/Kimera-RPGO
export KIMERA_VIO_DIR=${PROJECT_DIR}/Kimera-VIO
export EUROC_DIR=${PROJECT_DIR}/euroc
