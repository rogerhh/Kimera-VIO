#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/env.sh

echo -e "${SCRIPT_PROMPT} Downloading Boost source to: ${BOOST_DIR}"

cd $PROJECT_DIR
if [ ! -d $BOOST_DIR ]
then
    git clone --recursive https://github.com/boostorg/boost.git 
fi

cd $BOOST_DIR

./bootstrap.sh --prefix=$INSTALL_DIR --with-libraries="serialization,system,fileystem,thread,program_options,date_time,timer,chrono,regex"

# Change project-config.jam
echo -e "$SCRIPT_PROMPT Manually patching: $BOOST_DIR/project-config.jam"
cp $PATCH_DIR/boost/project-config.jam $BOOST_DIR/project-config.jam

echo -e "${SCRIPT_PROMPT} Installing Boost to: ${INSTALL_DIR}"
./b2 link=static toolset=gcc-riscv install
