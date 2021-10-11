cmake_minimum_required(VERSION 3.20)

project(assimp-vcpkg-feature-testbed)

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 11)

find_package(assimp REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE assimp::assimp)
