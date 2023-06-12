#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source $SCRIPT_DIR/color.sh
source $SCRIPT_DIR/env.sh

cd $PROJECT_DIR

echo -e "${SCRIPT_PROMPT} Downloading OpenCV source to ${OPENCV_DIR}"
if [ ! -d $OPENCV_DIR ]
then
    git clone https://github.com/opencv/opencv.git opencv3.3.1
    ln -s opencv3.3.1 opencv
    cd opencv && git checkout tags/3.3.1
fi

cd $PROJECT_DIR
if [ ! -d $PROJECT_DIR/opencv_contrib ]
then
    git clone https://github.com/opencv/opencv_contrib.git opencv_contrib3.3.1
    ln -s opencv_contrib3.3.1 opencv_contrib
    cd opencv_contrib && git checkout tags/3.3.1
fi

echo -e "$SCRIPT_PROMPT Manually patching $OPENCV_DIR/modules/core/src/persistence.cpp"
cp ${PATCH_DIR}/opencv/persistence.cpp $OPENCV_DIR/modules/core/src/persistence.cpp
echo -e "$SCRIPT_PROMPT Manually patching $OPENCV_DIR/cmake/OpenCVFindLibsPerf.cmake"
cp ${PATCH_DIR}/opencv/OpenCVFindLibsPerf.cmake $OPENCV_DIR/cmake/OpenCVFindLibsPerf.cmake
echo -e "$SCRIPT_PROMPT Manually patching $OPENCV_CONTRIB_DIR/modules/stereo/src/descriptor.cpp"
cp ${PATCH_DIR}/opencv/descriptor.cpp $OPENCV_CONTRIB_DIR/modules/stereo/src/descriptor.cpp

cd $OPENCV_DIR && mkdir -p build && cd build 
    
cmake ${CMAKE_COMMON_FLAGS} \
      -D CMAKE_BUILD_TYPE=Release \
      -D WITH_JPEG=OFF \
      -D WITH_PNG=OFF \
      -D WITH_WEBP=OFF \
      -D WITH_TIFF=OFF \
      -D WITH_JASPER=OFF \
      -D WITH_OPENEXR=OFF \
      -D WITH_GTK=OFF \
      -D BUILD_ZLIB=ON \
      -D BUILD_opencv_python=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=OFF \
      -D ENABLE_CXX11=ON \
      -D OPENCV_EXTRA_MODULES_PATH=${PROJECT_DIR}/opencv_contrib/modules \
      -D BUILD_opencv_freetype=OFF \
      -D BUILD_opencv_java=OFF \
      -D BUILD_opencv_sfm=OFF \
      .. \
      --trace 2>&1 | tee cmake.out

make -j$(nproc) install 2>&1 | tee make.out
