add_subdirectory(server/o3dgc/src)

include(GNUInstallDirs)

install(TARGETS o3dgc_common_lib
        EXPORT  o3dgc_common_lib-targets
        LIBRARY       DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE       DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/open3dgc")

install(EXPORT o3dgc_common_lib-targets
        FILE o3dgc_common_lib-config.cmake
        NAMESPACE openddlparser::
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/open3dgc")