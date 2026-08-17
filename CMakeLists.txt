cmake_minimum_required(VERSION 4.4.2)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(
    slang-module
    VERSION      0.1.0
    SPDX_LICENSE ""
    DESCRIPTION  ""
    HOMEPAGE_URL ""
    LANGUAGES    NONE
)

include(SlangModuleSetOption)
slang_module_set_option(SLANG_MODULE_SOURCES "" STRING "Slang source files to compile")

find_program(
    SLANGC_EXECUTABLE
    slangc
    DOC "Slang compiler"
    REQUIRED
)

set(SPIRV_OUTPUTS "")
foreach(SLANG_MODULE_SOURCE IN LISTS SLANG_MODULE_SOURCES)
    cmake_path(
        ABSOLUTE_PATH
        SLANG_MODULE_SOURCE
        BASE_DIRECTORY  ${CMAKE_SOURCE_DIR}
        NORMALIZE
        OUTPUT_VARIABLE SLANG_MODULE_SOURCE_ABSOLUTE_PATH
    )
    cmake_path(GET SLANG_MODULE_SOURCE_ABSOLUTE_PATH STEM SLANG_MODULE_SOURCE_STEM)

    set(SPIRV_OUTPUT "shaders/${SLANG_MODULE_SOURCE_STEM}.spv")

    add_custom_command(
        OUTPUT ${SPIRV_OUTPUT}
        COMMAND
            ${SLANGC_EXECUTABLE}
            ${SLANG_MODULE_SOURCE_ABSOLUTE_PATH}
            -target spirv
            -profile spirv_1_4
            -o ${SPIRV_OUTPUT}
        DEPENDS ${SLANG_MODULE_SOURCE_ABSOLUTE_PATH}
        COMMENT "Compiling slang shader: ${SLANG_MODULE_SOURCE}"
        VERBATIM
    )

    list(APPEND SPIRV_OUTPUTS ${SPIRV_OUTPUT})
endforeach()

add_custom_target(${PROJECT_NAME} DEPENDS ${SPIRV_OUTPUTS})
