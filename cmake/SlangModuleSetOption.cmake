include_guard(GLOBAL)

macro(slang_module_set_option VAR DEFAULT TYPE HELP)
    if(NOT DEFINED ${VAR})
        set(${VAR} ${DEFAULT})
    endif()
    set(
        CACHE{${VAR}}
        TYPE  ${TYPE}
        HELP  ${HELP}
        FORCE
        VALUE ${${VAR}}
    )
endmacro()
