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

FROM_OPTIONS="boost gtsam opencv opengv dbow2 rpgo gflags glog kimera"
COMPILE_INDEX=0

FROM="${FROM:=boost}"

for option in $FROM_OPTIONS
do 
    echo "$FROM $option"
    if [[ $FROM == $option ]]
    then
        break
    fi
    ((COMPILE_INDEX=COMPILE_INDEX+1))
done

if [ $COMPILE_INDEX -le 0 ] 
then
    source ${SCRIPT_DIR}/install_boost_riscv.sh
fi

if [ $COMPILE_INDEX -le 1 ] 
then
source ${SCRIPT_DIR}/install_igo-gtsam_riscv.sh
fi

if [ $COMPILE_INDEX -le 2 ] 
then
source ${SCRIPT_DIR}/install_opencv_riscv.sh
fi

if [ $COMPILE_INDEX -le 3 ] 
then
source ${SCRIPT_DIR}/install_opengv_riscv.sh
fi

if [ $COMPILE_INDEX -le 4 ] 
then
source ${SCRIPT_DIR}/install_DBoW2_riscv.sh
fi

if [ $COMPILE_INDEX -le 5 ] 
then
source ${SCRIPT_DIR}/install_Kimera-RPGO_riscv.sh
fi

if [ $COMPILE_INDEX -le 6 ] 
then
source ${SCRIPT_DIR}/install_gflags_riscv.sh
fi

if [ $COMPILE_INDEX -le 7 ] 
then
source ${SCRIPT_DIR}/install_glog_riscv.sh
fi

if [ $COMPILE_INDEX -le 8 ] 
then
source ${SCRIPT_DIR}/install_Kimera-VIO_riscv.sh
fi
