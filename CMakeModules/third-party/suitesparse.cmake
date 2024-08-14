if(TARGET SuiteSparse::SuiteSparse_config)
  return()
endif()

message(STATUS "Loading SuiteSparse...")

set(SUITESPARSE_USE_CUDA OFF CACHE BOOL "" FORCE)
set(SUITESPARSE_DEMOS OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(SUITESPARSE_ENABLE_PROJECTS "suitesparse_config;amd;camd;ccolamd;colamd;cholmod;cxsparse;klu;umfpack;spqr;" CACHE STRING "" FORCE)
set(SUITESPARSE_USE_FORTRAN OFF CACHE BOOL "" FORCE)

include(FetchContent)
FetchContent_Declare(
  suitesparse
  GIT_REPOSITORY https://github.com/DrTimothyAldenDavis/SuiteSparse.git
  GIT_TAG v7.7.0 
  # URL https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.7.0.tar.gz
  # URL https://drive.google.com/uc?export=download&id=1JrLDUGNOF9tr9aefunw9nFOBAb4X72S-
  EXCLUDE_FROM_ALL
  DOWNLOAD_EXTRACT_TIMESTAMP ON
  FIND_PACKAGE_ARGS NAMES SuiteSparse COMPONENTS SuiteSparse_config cholmod spqr umfpack
)

FetchContent_MakeAvailable(suitesparse)


message(STATUS "Done.")