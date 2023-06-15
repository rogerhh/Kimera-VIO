#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading Boost source to: ${BOOST_DIR}"

cd $PROJECT_DIR
if [ ! -d $BOOST_DIR ]
then
    git clone --recursive https://github.com/boostorg/boost.git 
fi

cd $BOOST_DIR

rm -f $BOOST_DIR/project-config.jam*

./bootstrap.sh --prefix=$INSTALL_DIR --with-libraries="serialization,system,filesystem,thread,program_options,date_time,timer,chrono,regex"

if [ $NO_RISCV -eq 0 ]
then
    # Change project-config.jam
    echo -e "$SCRIPT_PROMPT Manually patching: $BOOST_DIR/project-config.jam"
    sed -i -e "s/using gcc ;/using gcc : riscv : riscv64-unknown-linux-gnu-g++ ;/" $BOOST_DIR/project-config.jam

    echo -e "${SCRIPT_PROMPT} Installing Boost to: ${INSTALL_DIR}"
    ./b2 link=static toolset=gcc-riscv install
else
    echo -e "${SCRIPT_PROMPT} Installing Boost to: ${INSTALL_DIR}"
    ./b2 link=static toolset=gcc install
fi

