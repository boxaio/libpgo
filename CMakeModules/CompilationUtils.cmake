function(add_flag tgt platform mode domain flag)
  if(platform STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    string(TOUPPER "${mode}" mode_upper)

    if(mode_upper STREQUAL "ALL")
      target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
    else()
      target_compile_options(${tgt} ${domain} "$<$<AND:$<CONFIG:${mode_upper}>,$<COMPILE_LANGUAGE:CXX>>:${flag}>")
    endif()
  elseif(platform STREQUAL "GNU" AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
  elseif(platform STREQUAL "Clang" AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
  elseif(platform STREQUAL "AppleClang" AND CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
  endif()

  if(platform STREQUAL "MSVC" AND CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    string(TOUPPER "${mode}" mode_upper)

    if(mode_upper STREQUAL "ALL")
      target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
    else()
      target_compile_options(${tgt} ${domain} "$<$<AND:$<CONFIG:${mode_upper}>,$<COMPILE_LANGUAGE:C>>:${flag}>")
    endif()
  elseif(platform STREQUAL "GNU" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
  elseif(platform STREQUAL "Clang" AND CMAKE_C_COMPILER_ID STREQUAL "Clang")
    target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
  elseif(platform STREQUAL "AppleClang" AND CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
    target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
  endif()
endfunction()

function(add_flag_poxis tgt domain flag)
  add_flag(${tgt} GNU All ${domain} ${flag})
  add_flag(${tgt} Clang All ${domain} ${flag})
  add_flag(${tgt} AppleClang All ${domain} ${flag})
endfunction()

function(add_flag_cuda tgt platform mode domain flag)
  if(platform STREQUAL "MSVC")
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
      string(TOUPPER "${mode}" mode_upper)

      if(mode_upper STREQUAL "ALL")
        target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CUDA>:${flag}>")
      else()
        target_compile_options(${tgt} ${domain} "$<$<AND:$<CONFIG:${mode_upper}>,$<COMPILE_LANGUAGE:CUDA>>:${flag}>")
      endif()
    endif()
  elseif(platform STREQUAL "GNU")
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
      target_compile_options(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CUDA>:${flag}>")
    endif()
  else()
  endif()
endfunction()

function(add_def tgt platform mode domain flag)
  if(platform STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    string(TOUPPER "${mode}" mode_upper)

    if(mode_upper STREQUAL "ALL")
      target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
    else()
      target_compile_definitions(${tgt} ${domain} "$<$<AND:$<CONFIG:${mode_upper}>,$<COMPILE_LANGUAGE:CXX>>:${flag}>")
    endif()
  elseif(platform STREQUAL "GNU" AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
  elseif(platform STREQUAL "Clang" AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
  elseif(platform STREQUAL "AppleClang" AND CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
  endif()

  if(platform STREQUAL "MSVC" AND CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    string(TOUPPER "${mode}" mode_upper)

    if(mode_upper STREQUAL "ALL")
      target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
    else()
      target_compile_definitions(${tgt} ${domain} "$<$<AND:$<CONFIG:${mode_upper}>,$<COMPILE_LANGUAGE:C>>:${flag}>")
    endif()
  elseif(platform STREQUAL "GNU" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
  elseif(platform STREQUAL "Clang" AND CMAKE_C_COMPILER_ID STREQUAL "Clang")
    target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
  elseif(platform STREQUAL "AppleClang" AND CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
    target_compile_definitions(${tgt} ${domain} "$<$<COMPILE_LANGUAGE:C>:${flag}>")
  endif()
endfunction()

function(add_link_flag tgt platform mode flag)
  get_target_property(target_type ${tgt} TYPE)

  if(platform STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    string(TOUPPER "${mode}" mode_upper)

    if(mode_upper STREQUAL "ALL")
      if(target_type STREQUAL "INTERFACE_LIBRARY")
        target_link_libraries(${tgt} INTERFACE ${flag})
      else()
        set_target_properties(${tgt} PROPERTIES LINK_FLAGS ${flag})
      endif()
    else()
      if(target_type STREQUAL "INTERFACE_LIBRARY")
        target_link_libraries(${tgt} INTERFACE $<$<CONFIG:${mode}>:${flag}>)
      else()
        set_target_properties(${tgt} PROPERTIES LINK_FLAGS_${mode_upper} ${flag})
      endif()
    endif()
  elseif((platform STREQUAL "GNU" AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR
    (platform STREQUAL "Clang" AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang") OR
    (platform STREQUAL "AppleClang" AND CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang"))
    if(target_type STREQUAL "INTERFACE_LIBRARY")
      set_property(TARGET ${tgt} APPEND PROPERTY INTERFACE_LINK_OPTIONS ${flag})
    else()
      set_property(TARGET ${tgt} APPEND PROPERTY LINK_OPTIONS ${flag})
    endif()
  endif()
endfunction()

function(add_link_flag_poxis tgt flag)
  add_link_flag(${tgt} GNU All ${flag})
  add_link_flag(${tgt} Clang All ${flag})
  add_link_flag(${tgt} AppleClang All ${flag})
endfunction()

macro(find_gcc_libs)
  execute_process(COMMAND g++ -print-file-name=libstdc++.so OUTPUT_VARIABLE CXX_STDCXX_PATH_RAW)
  string(STRIP ${CXX_STDCXX_PATH_RAW} CXX_STDCXX_PATH)

  execute_process(COMMAND g++ -print-file-name=libstdc++fs.a OUTPUT_VARIABLE CXX_STDCXXFS_PATH_RAW)
  string(STRIP ${CXX_STDCXXFS_PATH_RAW} CXX_STDCXXFS_PATH)
endmacro()

function(add_std_fs tgt)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(STATUS "Adding filesystem")
    target_link_libraries(${tgt} PRIVATE ${CXX_STDCXXFS_PATH})
  endif()
endfunction()

function(add_std tgt)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_link_libraries(${tgt} PRIVATE ${CXX_STDCXX_PATH})
  endif()
endfunction()

function(chk_tgt deps is_ok)
  foreach(tgt ${deps})
    if(NOT TARGET ${tgt})
      set(${is_ok} 0 PARENT_SCOPE)
      message(ERROR "==========> ${tgt} not found")
      return()
    endif()
  endforeach()

  set(${is_ok} 1 PARENT_SCOPE)
endfunction()

macro(fix_mkl_tbb_debug tgt)
  if(MSVC)
    set_target_properties(${tgt} PROPERTIES LINK_FLAGS_DEBUG /NODEFAULTLIB:tbb.lib)
  endif()
endmacro()

macro(fix_glut32 tgt)
  if(MSVC)
    set_target_properties(${tgt} PROPERTIES LINK_FLAGS /NODEFAULTLIB:glut32.lib)
  endif()
endmacro()

function(add_mkl_dep tgt)
  foreach(mkl_tgt ${mkl_library_targets})
    target_link_libraries(${tgt} INTERFACE ${mkl_tgt})
  endforeach()
endfunction()
