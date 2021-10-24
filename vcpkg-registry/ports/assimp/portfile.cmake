vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lerppana/assimp
    REF 44de3bd46ed4644638d842a4202bea6bd30dc3d0 # v5.0.1
    SHA512 25b1271f102ecd418e6ddcaf5b2b31149a7393b951dcf68cc0eadd5e18a7e0d77ac5ce65bdf4fce4fc9d448d76a241b4910450fcae63d299578844053f37ff1a
    HEAD_REF update-cmake
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" ASSIMP_BUILD_SHARED_LIBS)

set (ASSIMP_VCPKG_IMPOTER_EXPORTER_FEATURES "")
foreach(feature ${FEATURES})
    string( FIND ${feature} "-importer" ASSIMP_VCPKG_FEATURE_TEST)
    if (NOT ${ASSIMP_VCPKG_FEATURE_TEST} EQUAL -1)
        # essage("${feature} is importer")
        string(SUBSTRING ${feature} 0 ${ASSIMP_VCPKG_FEATURE_TEST} ASSIMP_VCPKG_FEATURE_TEST)
        string(TOUPPER ${ASSIMP_VCPKG_FEATURE_TEST} ASSIMP_VCPKG_FEATURE_TEST)
        set (ASSIMP_VCPKG_FEATURE_TEST ASSIMP_BUILD_${ASSIMP_VCPKG_FEATURE_TEST}_IMPORTER)
        list (APPEND ASSIMP_VCPKG_IMPOTER_EXPORTER_FEATURES "-D${ASSIMP_VCPKG_FEATURE_TEST}=ON")
    endif()
    string( FIND ${feature} "-exporter" ASSIMP_VCPKG_FEATURE_TEST)
    if (NOT ${ASSIMP_VCPKG_FEATURE_TEST} EQUAL -1)
        string(SUBSTRING ${feature} 0 ${ASSIMP_VCPKG_FEATURE_TEST} ASSIMP_VCPKG_FEATURE_TEST)
        string(TOUPPER ${ASSIMP_VCPKG_FEATURE_TEST} ASSIMP_VCPKG_FEATURE_TEST)
        set (ASSIMP_VCPKG_FEATURE_TEST ASSIMP_BUILD_${ASSIMP_VCPKG_FEATURE_TEST}_EXPORTER)
        list (APPEND ASSIMP_VCPKG_IMPOTER_EXPORTER_FEATURES "-D${ASSIMP_VCPKG_FEATURE_TEST}=ON")
    endif()
endforeach()
message("${ASSIMP_VCPKG_IMPOTER_EXPORTER_FEATURES}")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DASSIMP_BUILD_TESTS=OFF
            -DASSIMP_BUILD_ASSIMP_TOOLS=OFF
            -DASSIMP_BUILD_ZLIB=OFF
            -DASSIMP_BUILD_SHARED_LIBS=${ASSIMP_BUILD_SHARED_LIBS}
            -DASSIMP_INSTALL_PDB=OFF
            -DIGNORE_GIT_HASH=ON
            -DASSIMP_BUILD_ALL_EXPORTERS_BY_DEFAULT=OFF
            -DASSIMP_BUILD_ALL_IMPORTERS_BY_DEFAULT=OFF
            -DASSIMP_VCPKG_BUILD=ON
            ${ASSIMP_VCPKG_IMPOTER_EXPORTER_FEATURES}
)

vcpkg_install_cmake()

# this is from the original port, have no idea what it is supposed to do
if(VCPKG_TARGET_IS_WINDOWS)
    set(VCVER vc140 vc141 vc142 )
    set(CRT mt md)
    set(DBG_NAMES)
    set(REL_NAMES)
    foreach(_ver IN LISTS VCVER)
        foreach(_crt IN LISTS CRT)
            list(APPEND DBG_NAMES assimp-${_ver}-${_crt}d)
            list(APPEND REL_NAMES assimp-${_ver}-${_crt})
        endforeach()
    endforeach()
endif()

find_library(ASSIMP_REL NAMES assimp ${REL_NAMES} PATHS "${CURRENT_PACKAGES_DIR}/lib" NO_DEFAULT_PATH)
find_library(ASSIMP_DBG NAMES assimp assimpd ${DBG_NAMES} PATHS "${CURRENT_PACKAGES_DIR}/debug/lib" NO_DEFAULT_PATH)
if(ASSIMP_REL)
    get_filename_component(ASSIMP_NAME_REL "${ASSIMP_REL}" NAME_WLE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/assimp.pc" "-lassimp" "-l${ASSIMP_NAME_REL}")
endif()
if(ASSIMP_DBG)
    get_filename_component(ASSIMP_NAME_DBG "${ASSIMP_DBG}" NAME_WLE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/assimp.pc" "-lassimp" "-l${ASSIMP_NAME_DBG}")
endif()

vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/assimp" TARGET_PATH "share/assimp")
vcpkg_fixup_pkgconfig() # Probably requires more fixing for static builds. See qt5-3d and the config changes below

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
