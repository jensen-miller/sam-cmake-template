INCLUDE(CMakeForceCompiler)

SET ( CMAKE_SYSTEM_NAME Generic )
SET ( CMAKE_SYSTEM_PROCESSOR arm )

SET ( CMAKE_SYSTEM_VERSION 1 )

SET ( PACKS_REPO "C:/ProgramData/Atmel/AtmelStudio/7.0/packs")

#
#	ARM GCC Toolchain Configuration
#

SET ( CMAKE_C_COMPILER arm-none-eabi-gcc )
SET ( CMAKE_CXX_COMPILER arm-none-eabi-g++ )
SET ( CMAKE_OBJCOPY arm-none-eabi-objcopy )
SET ( CMAKE_LINKER arm-none-eabi-ld )
SET ( CMAKE_SIZE arm-none-eabi-size )
SET ( CMAKE_C_STANDARD 99 )
SET ( CMAKE_CXX_STANDARD 14 )


#
#	Target-System Specific
#
if (NOT ARM_CPU)
	set (
		ARM_CPU cortex-m0
		CACHE STRING "Set default MCU: cortex-m0 (see 'arm-none-eabi-gcc --target-help' for valid values)"
	)
endif(NOT ARM_CPU)


if (NOT ATMEL_ARCH)
	set (
		ATMEL_ARCH SAMD21
		CACHE STRING "Set the default architecture: SAMD21"
	)
endif(NOT ATMEL_ARCH)


if (NOT SAM_MCU)
	set (
		SAM_MCU samd21g18a
		CACHE STRING "Set the default MCU platform: samd21g18a"
	)
endif(NOT SAM_MCU)


#
#	Bossac Specific
#
if (NOT ARM_UPLOADTOOL)
	SET (
		ARM_UPLOADTOOL bossac
		CACHE STRING "Set default upload tool: bossac"
	)
	find_program(ARM_UPLOADTOOL bossac)
endif(NOT ARM_UPLOADTOOL)


if (NOT UPLOAD_PORT)
	SET (
		UPLOAD_PORT COM4
		CACHE STRING "Set upload port: COM<port_num>"
	)
endif(NOT UPLOAD_PORT)


#
#	UF2 Specific
#
if (NOT SHELL_COPY_COMMAND)
	SET (
		SHELL_COPY_COMMAND copy
		CACHE STRING "Set shell copy command: default 'copy'"
	)
endif(NOT SHELL_COPY_COMMAND)


if (NOT UF2_DRIVE_MOUNT)
	SET (
		UF2_DRIVE_MOUNT "D:"
		CACHE STRING "Set the mount point the UF2 populates: default 'D:'"
	)
endif(NOT UF2_DRIVE_MOUNT)




#
#	Environment Configuring
#


# where is the target environment
SET(CMAKE_FIND_ROOT_PATH  "C:\\Program Files (x86)\\Atmel\\Studio\\7.0\\toolchain\\arm\\arm-gnu-toolchain")

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


##
#	FUNCTION add_sam_executable
#
#	PARAM EXECUTABLE_NAME The name of the executable.
#	ARGN Any source files required by the executable.
#
function (add_sam_executable EXECUTABLE_NAME)

	set (additional_source_files ${ARGN})
	list(LENGTH additional_source_files num_of_source_files)

	if (num_of_source_files LESS 0)
		message(FATAL_ERROR "No source files provided for ${EXECUTABLE_NAME}")
	else()
		foreach(src_file ${additional_source_files})
			message (STATUS "Including source: ${src_file}")
		endforeach()
	endif()

	set (ELF_OUTPUT_FILE "${EXECUTABLE_NAME}.elf")
	set (BIN_OUTPUT_FILE "${EXECUTABLE_NAME}.bin")
	set (UF2_OUTPUT_FILE "${EXECUTABLE_NAME}.uf2")
	#set (HEX_OUTPUT_FILE "${EXECUTABLE_NAME}.hex")
	#set (LST_OUTPUT_FILE "${EXECUTABLE_NAME}.lst")
	set (MAP_OUTPUT_FILE "${EXECUTABLE_NAME}.map")
	#set (EEPROM_IMAGE "${EXECUTABLE_NAME}-eeprom.hex")



	##
	#	Create ELF.
	add_executable(${ELF_OUTPUT_FILE} EXCLUDE_FROM_ALL ${additional_source_files})

	target_include_directories(${ELF_OUTPUT_FILE} PUBLIC "C:/ProgramData/Atmel/AtmelStudio/7.0/packs/arm/CMSIS/5.4.0/CMSIS/Core/Include" PUBLIC "C:/ProgramData/Atmel/AtmelStudio/7.0/packs/atmel/SAMD51_DFP/1.2.139/samd51a/include"  )
	set_target_properties (
		${ELF_OUTPUT_FILE}
		PROPERTIES
			COMPILE_FLAGS "-x c -mthumb -DDEBUG -D__SAMD51J20A__ -O1 -ffunction-sections -mlong-calls -g3 -Wall -mcpu=cortex-m4 -c -std=gnu99 -MD -MP"# -MF \"Device_Startup/startup_samd51.d\" -MT\"Device_Startup/startup_samd51.d\" -MT\"Device_Startup/startup_samd51.o\"   -o \"Device_Startup/startup_samd51.o\" \"../Device_Startup/startup_samd51.c\""
			LINK_FLAGS "-mthumb -Wl,-Map=\"${EXECUTABLE_NAME}.map\" -Wl,--start-group -lm  -Wl,--end-group -L\"${CMAKE_SOURCE_DIR}\\scripts\\gcc\"  -Wl,--gc-sections -mcpu=${ARM_CPU} -T ${SAM_MCU}_flash.ld"
	)



	##
	#	Create binary from ELF.
	add_custom_target (
		${BIN_OUTPUT_FILE}
		${CMAKE_OBJCOPY} -O binary ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${ELF_OUTPUT_FILE} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${BIN_OUTPUT_FILE}
		DEPENDS ${ELF_OUTPUT_FILE}
	)



	##
	#	Create the UF2 file.
	add_custom_target (
		${UF2_OUTPUT_FILE}
		python ${CMAKE_SOURCE_DIR}/scripts/uf2/uf2conv.py -c -b 0x4000 -o ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${UF2_OUTPUT_FILE} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${BIN_OUTPUT_FILE}
		DEPENDS ${BIN_OUTPUT_FILE}
	)
	


	##
	#	Set the executable to default to the ELF.
	add_custom_target(
		${EXECUTABLE_NAME}
		ALL
		DEPENDS ${ELF_OUTPUT_FILE}
	)

	set_target_properties (
		${EXECUTABLE_NAME}
		PROPERTIES
			OUTPUT_NAME ${ELF_OUTPUT_FILE}
	)

	get_directory_property (
		clean_files ADDITIONAL_MAKE_CLEAN_FILES
	)
	set_directory_properties (
		PROPERTIES
			ADDITIONAL_MAKE_CLEAN_FILES "${MAP_OUTPUT_FILE}"
	)



	##
	#	Create utility project for uploading via BOSSA
	add_custom_target (
		Upload_${EXECUTABLE_NAME}				
		${ARM_UPLOADTOOL} -i -d --port=${UPLOAD_PORT} -U --offset=0x4000 -w -v ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${BIN_OUTPUT_FILE} -R
		DEPENDS ${BIN_OUTPUT_FILE}
	)



	##
	#	Copy UF2 file to the MSC drive.
	add_custom_target (
		Flash_${UF2_OUTPUT_FILE}
		${SHELL_COPY_COMMAND} bin\\${UF2_OUTPUT_FILE} ${UF2_DRIVE_MOUNT}
		VERBATIM
		USES_TERMINAL
		DEPENDS ${UF2_OUTPUT_FILE}
	)

endfunction(add_sam_executable)