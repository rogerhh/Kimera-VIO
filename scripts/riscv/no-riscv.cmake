####################################################################
#
# riscv.cmake
# Author: Roger Hsiao
# Brief: Specifies toolchain to use for cross compilation to RISCV 
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=/path/to/rv64imac.cmake ..
# 
####################################################################

# Set the common build flags
unset( CMAKE_C_FLAGS CACHE )
unset( CMAKE_CXX_FLAGS CACHE )

# Set the CMAKE C flags (which should also be used by the assembler!
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=native" )

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" FORCE )
set( CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" FORCE )
set( CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" FORCE )

set( CMAKE_EXE_LINKER_FLAGS   "${CMAKE_EXE_LINKER_FLAGS} -march=native" )
