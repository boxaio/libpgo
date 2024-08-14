if(TARGET fmt::fmt-header-only)
  return()
endif()

message(STATUS "Loading fmtlib...")

include(FetchContent)
FetchContent_Declare(
  fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG v10.2.1
  # URL https://github.com/fmtlib/fmt/releases/download/10.2.1/fmt-10.2.1.zip
  EXCLUDE_FROM_ALL
  DOWNLOAD_EXTRACT_TIMESTAMP ON
  FIND_PACKAGE_ARGS NAMES fmt
)

FetchContent_MakeAvailable(fmt)

message(STATUS "Done.")