vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO kimkulling/openddl-parser
        REF 1131ef29f0ff60325181733904583cbb6f25dbfd
        SHA512 e146f9b7e5d26f633e269c765de0489027cdabf13466cbab4601e3d24f682c3d3774113fa98e118f86a3cf343c9ecabbcb6541abbd001f4c0d7775114418da6e
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