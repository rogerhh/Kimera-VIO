#!/bin/bash

# Fails the execution whenever there is an error
set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

if [ $NO_RISCV -eq 0 ]
then
    echo -e "${SCRIPT_PROMPT} Compling to RISC-V"
else
    echo -e "${SCRIPT_PROMPT} NOT compling to RISC-V"
fi

echo -e "${SCRIPT_PROMPT} Set CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}"
echo -e "${SCRIPT_PROMPT} Installing all dependencies to: ${INSTALL_DIR}"
mkdir -p $INSTALL_DIR
echo -e "${SCRIPT_PROMPT} Using Chipyard directory: ${CHIPYARD_HOME}"

source ${SCRIPT_DIR}/install_boost_riscv.sh
source ${SCRIPT_DIR}/install_gtsam_riscv.sh
source ${SCRIPT_DIR}/install_opencv_riscv.sh
source ${SCRIPT_DIR}/install_opengv_riscv.sh
source ${SCRIPT_DIR}/install_DBoW2_riscv.sh
source ${SCRIPT_DIR}/install_Kimera-RPGO_riscv.sh
source ${SCRIPT_DIR}/install_gflags_riscv.sh
source ${SCRIPT_DIR}/install_glog_riscv.sh
source ${SCRIPT_DIR}/install_Kimera-VIO_riscv.sh
