function (add_external_dependencies PROJECT)
    add_dependencies(${PROJECT} libvlc2)
endfunction()

#libvlc
ExternalProject_Add(libvlc2
	URL ${CASPARCG_DOWNLOAD_MIRROR}/libvlc/libvlc-3.0.20-win32-x64.zip
	URL_HASH MD5=950fa6d33f80787a80fec894bd9b9403
	DOWNLOAD_DIR ${CASPARCG_DOWNLOAD_CACHE}
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)
ExternalProject_Get_Property(libvlc2 SOURCE_DIR)
set(LIBVLC_INCLUDE_DIR "${SOURCE_DIR}/include")
set(LIBVLC_LIBRARY "libvlc")
set(LIBVLC_CORE_LIBRARY "libvlccore")
link_directories("${SOURCE_DIR}")
casparcg_add_runtime_dependency("${SOURCE_DIR}/libvlc.dll")
casparcg_add_runtime_dependency("${SOURCE_DIR}/libvlccore.dll")
casparcg_add_runtime_dependency_dir("${SOURCE_DIR}/plugins")

set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT shell)

set (CMAKE_PREFIX_PATH "${BUILD_QT_PATH}")

function(casparcg_copy_runtime_dependencies)
	foreach(FILE_TO_COPY ${CASPARCG_RUNTIME_DEPENDENCIES})
		get_filename_component(FOLDER_NAME "${FILE_TO_COPY}" NAME)
		add_custom_command(
			TARGET casparcg_copy_dependencies
			POST_BUILD 
			COMMAND echo \"Copy ${FILE_TO_COPY}\" &&
				${CMAKE_COMMAND} -E copy \"${FILE_TO_COPY}\" \"${OUTPUT_FOLDER}/\" &&
				${CMAKE_COMMAND} -E copy \"${FILE_TO_COPY}\" \"${CMAKE_CURRENT_BINARY_DIR}/\"
		)
	endforeach(FILE_TO_COPY)

	foreach(FILE_TO_COPY ${CASPARCG_RUNTIME_DEPENDENCIES_DIRS})
		get_filename_component(FOLDER_NAME "${FILE_TO_COPY}" NAME)
		add_custom_command(
			TARGET casparcg_copy_dependencies
			POST_BUILD 
			COMMAND echo \"Copy ${FILE_TO_COPY}\" &&
				${CMAKE_COMMAND} -E copy_directory \"${FILE_TO_COPY}\" \"${OUTPUT_FOLDER}/${FOLDER_NAME}/\" &&
				${CMAKE_COMMAND} -E copy_directory \"${FILE_TO_COPY}\" \"${CMAKE_CURRENT_BINARY_DIR}/${FOLDER_NAME}/\"
		)
	endforeach(FILE_TO_COPY)
endfunction()
