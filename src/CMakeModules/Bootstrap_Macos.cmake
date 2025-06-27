cmake_host_system_information(RESULT CONFIG_CPU_COUNT QUERY NUMBER_OF_PHYSICAL_CORES)

function (add_external_dependencies PROJECT)
    add_dependencies(${PROJECT} libvlc2)
endfunction()

if (NOT Qt6_ROOT)
    message(FATAL_ERROR "You must specify a root value to the qt6 installation -DQt6_ROOT=$HOME/Qt/6.2.0/macos")
endif()

#libvlc
if (CMAKE_OSX_ARCHITECTURES MATCHES "(arm|aarch)")
	ExternalProject_Add(libvlc2
		URL ${CASPARCG_DOWNLOAD_MIRROR}/libvlc/libvlc-3.0.20-macos-arm64.zip
		URL_HASH MD5=bdf16f561cf9ee85bee66ab63d8ce191
		DOWNLOAD_DIR ${CASPARCG_DOWNLOAD_CACHE}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND ""
		INSTALL_COMMAND ""
	)
else()
	ExternalProject_Add(libvlc2
		URL ${CASPARCG_DOWNLOAD_MIRROR}/libvlc/libvlc-3.0.20-macos-x64.zip
		URL_HASH MD5=18a9c2b2efaec06ee5d3fac51f89f129
		DOWNLOAD_DIR ${CASPARCG_DOWNLOAD_CACHE}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND ""
		INSTALL_COMMAND ""
	)
endif()
ExternalProject_Get_Property(libvlc2 SOURCE_DIR)
set(LIBVLC_INCLUDE_DIR "${SOURCE_DIR}/include")
set(LIBVLC_LIBRARY "libvlc.dylib")
set(LIBVLC_CORE_LIBRARY "libvlccore.dylib")
link_directories("${SOURCE_DIR}/lib")
casparcg_add_runtime_dependency("${SOURCE_DIR}/lib/libvlc.dylib")
casparcg_add_runtime_dependency("${SOURCE_DIR}/lib/libvlccore.dylib")
casparcg_add_runtime_dependency_dir("${SOURCE_DIR}/plugins")

function(casparcg_copy_runtime_dependencies)
	set(FRAMEWORKS_DIR "${CMAKE_BINARY_DIR}/Shell/casparcg-client.app/Contents/Frameworks/")
	add_custom_command(TARGET casparcg_copy_dependencies POST_BUILD COMMAND ${CMAKE_COMMAND} -E make_directory \"${FRAMEWORKS_DIR}\")

	foreach(FILE_TO_COPY ${CASPARCG_RUNTIME_DEPENDENCIES})
		get_filename_component(FOLDER_NAME "${FILE_TO_COPY}" NAME)
		add_custom_command(
			TARGET casparcg_copy_dependencies
			POST_BUILD 
			COMMAND echo \"Copy ${FILE_TO_COPY}\" &&
				${CMAKE_COMMAND} -E copy \"${FILE_TO_COPY}\" \"${FRAMEWORKS_DIR}\" &&
				${CMAKE_COMMAND} -E copy \"${FILE_TO_COPY}\" \"${CMAKE_CURRENT_BINARY_DIR}/\"
		)
	endforeach(FILE_TO_COPY)

	foreach(FILE_TO_COPY ${CASPARCG_RUNTIME_DEPENDENCIES_DIRS})
		get_filename_component(FOLDER_NAME "${FILE_TO_COPY}" NAME)
		add_custom_command(
			TARGET casparcg_copy_dependencies
			POST_BUILD 
			COMMAND echo \"Copy ${FILE_TO_COPY}\" &&
				${CMAKE_COMMAND} -E copy_directory \"${FILE_TO_COPY}\" \"${FRAMEWORKS_DIR}/${FOLDER_NAME}/\" &&
				${CMAKE_COMMAND} -E copy_directory \"${FILE_TO_COPY}\" \"${CMAKE_CURRENT_BINARY_DIR}/${FOLDER_NAME}/\"
		)
	endforeach(FILE_TO_COPY)
endfunction()
