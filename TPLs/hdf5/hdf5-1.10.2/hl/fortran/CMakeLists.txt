cmake_minimum_required (VERSION 3.10)
PROJECT (HDF5_HL_F90 C CXX Fortran)

#-----------------------------------------------------------------------------
# List Source files
#-----------------------------------------------------------------------------
add_subdirectory (src)

#-----------------------------------------------------------------------------
# Build the HL Fortran Examples
#-----------------------------------------------------------------------------
if (HDF5_BUILD_EXAMPLES)
  add_subdirectory (examples)
endif ()

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------
if (BUILD_TESTING)
  add_subdirectory (test)
endif ()
