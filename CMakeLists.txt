# ----------------------
# Usage
# 1. cd to current dir(where CmakeLists.txt exists);
# 2. create directory build;
# 3. cd to build;
# 4. run command: $cmake ..
# 5. run command: $make
# enjoy!

# ----------------------
# Using cmake-gui
# 1. open cmake-gui window;
# 2. click "Browse Source" and select current dir(where CmakeLists.txt exists);
# 3. click "Browse Build" and select anywhere you want to put the build files;
# 4. click "Configure" and select the compiler to use;
# 5. click "Generate" and make files or nmake files(MSVC) will be generated in the build folder you have selected;
# 6. go to your build folder or just click "Open Project";
# 7. run make or build with Microsoft Visual Studio;
# enjoy!

# ----------------------
# Tested on:
# 1. Windows 10 with Microsoft Visual Studio 2019;
# 2. Ubuntu 20.04 with gcc 10.0;

cmake_minimum_required(VERSION 3.17)

# ----------------------
# set cmake base info
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# --------------------
#  Set Target Info
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install CACHE PATH "Where to install output files")
set(CMAKE_DEBUG_POSTFIX d)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(PROJECT_NAME istyle)
project(${PROJECT_NAME} VERSION 0.0.1  LANGUAGES CXX)

set(PROJ_SRC_H "")
set(PROJ_SRC_CPP "")

file(GLOB_RECURSE src_h
    LIST_DIRECTORIES false
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/src/
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp"
)

foreach(src ${src_h})
    set(src_path_absolute ${CMAKE_CURRENT_SOURCE_DIR}/src/${src})
    get_filename_component(src_path "${src}" PATH)
    string(REPLACE "/" "\\" src_path_msvc "${src_path}")
    list(APPEND PROJ_SRC_H ${src_path_absolute})
    source_group("${src_path_msvc}" FILES "${src_path_absolute}")
endforeach()

file(GLOB_RECURSE src_cpp
    LIST_DIRECTORIES false
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/src/
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

foreach(src ${src_cpp})
    set(src_path_absolute ${CMAKE_CURRENT_SOURCE_DIR}/src/${src})
    get_filename_component(src_path "${src}" PATH)
    string(REPLACE "/" "\\" src_path_msvc "${src_path}")
    list(APPEND PROJ_SRC_CPP ${src_path_absolute})
    source_group("${src_path_msvc}" FILES "${src_path_absolute}")
endforeach()

add_executable(${PROJECT_NAME} ${PROJ_SRC_H} ${PROJ_SRC_CPP})

target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/
)
