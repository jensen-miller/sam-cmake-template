#------------------------------------------------------------------------------
#	Project template for SAM<X> using CMake
#
#	Copyright (c) 2020 Jensen Miller
#
#------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.8)

project ("SAM-CMAKE")


set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/archive")
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")




# Setup binary
add_sam_executable("samd51j20a-example" "src/main.c" "src/system/system_samd51.c" "src/system/startup_samd51.c")

#target_include_directories("samd51j20a-example" PUBLIC "include")


