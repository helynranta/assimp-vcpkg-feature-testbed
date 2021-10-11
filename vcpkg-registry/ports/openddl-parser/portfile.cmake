vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO lerppana/openddl-parser
        REF f3fc5825ea41edf0dfb4fc016ee6e507ba7a7850
        SHA512 61d4f413ef0ef221ecc2d9fa9505c9a276a9495789a76f325c3db08ac7587423c8b54e10829e7a8c5c808f6a815edfb92d24596da483a9eed95a191a64e2562d
        HEAD_REF install-target
)

vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
        OPTIONS
        -DCOVERALLS=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/openddlparser" TARGET_PATH "share/openddlparser")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)