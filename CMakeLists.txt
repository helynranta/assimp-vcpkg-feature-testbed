cmake_minimum_required(VERSION 3.20)

project(assimp-vcpkg-feature-testbed)

find_package(assimp REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE assimp::assimp)