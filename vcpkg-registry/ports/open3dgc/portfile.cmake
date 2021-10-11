vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO amd/rest3d
        REF ecc287150791c1d5aef10f0606de46b2147c0944
        SHA512 fb39478e2f62856c9c939c80302b036af59ae2211485e271eb689f6162a9dc3b3e7a030c82d81ce384cdd5c308c3b50a0d7ff7a2cad06805413cd4a65e5b132b
        HEAD_REF master
        PATCHES
            remove_tests.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(SOURCE_PATH ${SOURCE_PATH} PREFER_NINJA)

vcpkg_install_cmake()

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)