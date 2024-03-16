include make.opts

EXE_SOLVER = ./bin/ucs.x
EXE_DECOMP = ./bin/udecomp.x
EXE_GRIDMOD = ./bin/gridmod.x
EXE_RECOMP = ./bin/urecomp.x
EXE_FINDPOINT = ./bin/findpoint.x
EXE_PORTOPT = ./bin/opt.x
EXE_CHEMPROPS = ./bin/chemprops.x
EXE_STRUCT_SOLVER = ./bin/csd.x
EXE_STRUCT_ERROR = ./bin/esd.x
EXE_TESTS = ./bin/tests.x

# --------- BEGIN COMMON LIBRARY SECTION

SRCS_COMMON = ./ucs/timer.cpp ./ucs/endian_util.cpp ./ucs/strings_util.cpp \
	./ucs/h5layer.cpp ./ucs/parameterParser.cpp ./ucs/base64.cpp ./ucs/oddsNends.cpp
OBJS_COMMON = $(SRCS_COMMON:.cpp=.o)
DEPS_COMMON = $(SRCS_COMMON:.cpp=.d)

# --------- BEGIN FLUID DYNAMICS CORE SECTION

SRCS_SOLVER = ./ucs/main.cpp ./ucs/eqnset.cpp ./ucs/etypes.cpp ./ucs/threaded.cpp ./ucs/parallel.cpp \
	./ucs/customics.cpp ./ucs/portFileio.cpp \
	./ucs/elements.cpp  ./ucs/derivatives.cpp ./ucs/pythonInterface.cpp ./ucs/xmlreader.cpp \
	./ucs/exceptions.cpp
SRCS_DECOMP = ./ucs/decomp.cpp ./ucs/mesh.cpp ./ucs/etypes.cpp ./ucs/parallel.cpp \
	  ./ucs/exceptions.cpp
SRCS_GRIDMOD = ./ucs/gridmod.cpp ./ucs/mesh.cpp ./ucs/etypes.cpp ./ucs/parallel.cpp \
	  ./ucs/exceptions.cpp
SRCS_RECOMP = ./ucs/recomp.cpp ./ucs/mesh.cpp ./ucs/etypes.cpp ./ucs/parallel.cpp \
	  ./ucs/exceptions.cpp
SRCS_FINDPOINT = ./ucs/find_point.cpp ./ucs/mesh.cpp ./ucs/etypes.cpp ./ucs/parallel.cpp \
	  ./ucs/exceptions.cpp

OBJS_SOLVER = $(SRCS_SOLVER:.cpp=.o)
DEPS_SOLVER = $(SRCS_SOLVER:.cpp=.d)
OBJS_DECOMP = $(SRCS_DECOMP:.cpp=.o)
DEPS_DECOMP = $(SRCS_DECOMP:.cpp=.d)
OBJS_GRIDMOD = $(SRCS_GRIDMOD:.cpp=.o)
DEPS_GRIDMOD = $(SRCS_GRIDMOD:.cpp=.d)
OBJS_RECOMP = $(SRCS_RECOMP:.cpp=.o)
DEPS_RECOMP = $(SRCS_RECOMP:.cpp=.d)
OBJS_FINDPOINT = $(SRCS_FINDPOINT:.cpp=.o)
DEPS_FINDPOINT = $(SRCS_FINDPOINT:.cpp=.d)

# --------- BEGIN CHEMICAL PROPERTIES UTILITY SECTION

SRCS_CHEMPROPS = ./ucs/chemprops.cpp ./ucs/elements.cpp ./ucs/exceptions.cpp
OBJS_CHEMPROPS = $(SRCS_CHEMPROPS:.cpp=.o)
DEPS_CHEMPROPS = $(SRCS_CHEMPROPS:.cpp=.d)

# --------- BEGIN OPTIMIZATION TOOLKIT SECTION

CSRCS_PORTOPT = ./ucs/portDriver.cpp ./ucs/portFunctions.cpp ./ucs/portFileio.cpp ./ucs/lineSearch.cpp ./ucs/xmlreader.cpp ./ucs/exceptions.cpp
FSRCS_PORTOPT = ./ucs/portF.f
OBJS_PORTOPT = $(CSRCS_PORTOPT:.cpp=.o) $(FSRCS_PORTOPT:.cpp=.o)

# --------- BEGIN STRUCTURAL DYNAMICS SECTION

SRCS_STRUCT_SOLVER = ./structuralDynamics/main.cpp ./structuralDynamics/element_lib.cpp \
	./structuralDynamics/structparam.cpp ./structuralDynamics/utility.cpp \
	./structuralDynamics/explicit.cpp ./structuralDynamics/implicit.cpp \
	./structuralDynamics/forces.cpp ./structuralDynamics/bc.cpp ./structuralDynamics/io.cpp \
	./structuralDynamics/fluid_structure.cpp ./ucs/xmlreader.cpp
OBJS_STRUCT_SOLVER = $(SRCS_STRUCT_SOLVER:.cpp=.o)
DEPS_STRUCT_SOLVER = $(SRCS_STRUCT_SOLVER:.cpp=.d)

SRCS_ALL = $(SRCS_SOLVER) ./ucs/decomp.cpp ./ucs/recomp.cpp ./ucs/mesh.cpp ./ucs/etypes.cpp ./ucs/find_point.cpp $(CSRCS_PORTOPT)\
	 $(SRCS_CHEMPROPS) $(SRCS_STRUCT_SOLVER) $(SRCS_COMMON) $(SRCS_TEST) ./ucs/gridmod.cpp
OBJS_ALL = $(SRCS_ALL:.cpp=.o)
DEPS_ALL = $(SRCS_ALL:.cpp=.d)

# --------- BEGIN TEST SECTION
SRCS_TEST = ./unitTest/main.cpp ./ucs/mesh.cpp ./ucs/etypes.cpp ./ucs/parallel.cpp  ./ucs/pythonInterface.cpp ./ucs/exceptions.cpp
OBJS_TEST = $(SRCS_TEST:.cpp=.o) 
DEPS_TEST = $(SRCS_TEST:.cpp=.d)

# --------- BEGIN EXECUTABLE TARGETS SECTION

$(EXE_SOLVER):  $(TINYXMLDIR)/libtinyxml.a  $(DEPS_SOLVER) $(OBJS_SOLVER) ./ucs/libcommon.a structuralDynamics/libstructdyn.a $(LAPACK_LIB)/liblapacke.a $(HDF5_LIB)/libhdf5.a
	$(MPICXX) $(LINK_OPTS) -o $(EXE_SOLVER) $(LCXXFLAGS) $(OBJS_SOLVER) $(CXXLIBS) -lstructdyn -ltinyxml


$(EXE_DECOMP): $(METISINSTALLDIR)/libmetis.a  ./ucs/libcommon.a  $(HDF5_LIB)/libhdf5.a $(DEPS_DECOMP) $(OBJS_DECOMP) 
	$(MPICXX) $(LINK_OPTS) -o $(EXE_DECOMP) $(LCXXFLAGS) -L$(METIS_LIB) $(OBJS_DECOMP) $(CXXLIBS) -lmetis -ltinyxml -lcommon

$(EXE_GRIDMOD): ./ucs/libcommon.a  $(HDF5_LIB)/libhdf5.a $(DEPS_GRIDMOD) $(OBJS_GRIDMOD) 
	$(MPICXX) $(LINK_OPTS) -o $(EXE_GRIDMOD) $(LCXXFLAGS) -L$(METIS_LIB) $(OBJS_GRIDMOD) $(CXXLIBS) -ltinyxml -lcommon

$(EXE_RECOMP):  $(DEPS_RECOMP) $(OBJS_RECOMP) $(HDF5_LIB)/libhdf5.a ./ucs/libcommon.a
	$(MPICXX) $(LINK_OPTS) -o $(EXE_RECOMP) $(LCXXFLAGS) $(OBJS_RECOMP) $(CXXLIBS) -ltinyxml -lcommon

$(EXE_FINDPOINT): $(DEPS_FINDPOINT) $(OBJS_FINDPOINT)
	$(MPICXX) $(LINK_OPTS) -o $(EXE_FINDPOINT) $(LCXXFLAGS) $(OBJS_FINDPOINT) $(CXXLIBS) -ltinyxml

$(EXE_PORTOPT): $(OBJS_PORTOPT)
	$(FXX) $(FXX_LINK_OPTS) -o $(EXE_PORTOPT) $(LCXXFLAGS) $(OBJS_PORTOPT) $(FXXLIBS) -lcommon -ltinyxml -lmpi_cxx

$(EXE_CHEMPROPS): $(DEPS_CHEMPROPS) $(OBJS_CHEMPROPS) ./ucs/libcommon.a
	$(MPICXX) $(LINK_OPTS) -o $(EXE_CHEMPROPS) $(LCXXFLAGS) $(OBJS_CHEMPROPS) $(CXXLIBS)

$(EXE_STRUCT_SOLVER): $(DEPS_STRUCT_SOLVER) $(OBJS_STRUCT_SOLVER) $(LAPACK_LIB)/liblapacke.a ./ucs/libcommon.a
	$(MPICXX) -o $(EXE_STRUCT_SOLVER) $(LCXXFLAGS) $(OBJS_STRUCT_SOLVER) $(CXXLIBS) -llapacke -ltinyxml -lhdf5

$(EXE_STRUCT_ERROR): ./structuralDynamics/error.o ./ucs/libcommon.a
	$(MPICXX) -o $(EXE_STRUCT_ERROR) $(LCXXFLAGS) ./structuralDynamics/error.o $(CXXLIBS)

$(EXE_TESTS): $(DEPS_TEST) $(OBJS_TEST) $(GTEST_LIB)/.libs/libgtest.a ./ucs/libcommon.a structuralDynamics/libstructdyn.a
	$(MPICXX) $(LINK_OPTS) -o $(EXE_TESTS) $(LCXXFLAGS) $(OBJS_TEST) $(CXXLIBS) $(GTEST_LIB)/.libs/libgtest.a -lstructdyn -lcommon

SRCDIRS = ./structuralDynamics ./ucs
ROOT = $$PWD

./structuralDynamics/libstructdyn.a: $(DEPS_STRUCT_SOLVER) $(OBJS_STRUCT_SOLVER)
	ar rvs ./structuralDynamics/libstructdyn.a $(OBJS_STRUCT_SOLVER)

./ucs/libcommon.a: $(DEPS_COMMON) $(OBJS_COMMON)
	ar rvs ./ucs/libcommon.a $(OBJS_COMMON) 

$(HDF5_LIB)/libhdf5.a: 
	@orig=$$PWD;\
	cd $$PWD/$(HDF5DIR); \
	./configure --prefix $$PWD/build; \
	$(MAKE); \
	$(MAKE) install; \
	$(MAKE) lib;

$(METIS_LIB)/libmetis.a: 
	@orig=$$PWD;\
	cd $$PWD/$(METISDIR); \
	$(MAKE) config; \
	$(MAKE)

$(TINYXML_LIB)/libtinyxml.a:
	@orig=$$PWD;\
	cd $$PWD/$(TINYXMLDIR);\
	$(MAKE)

$(GTEST_LIB)/.libs/libgtest.a: 
	@orig=$$PWD;\
	cd $$PWD/$(GTESTDIR); \
	./configure; \
	$(MAKE)

$(LAPACK_LIB)/liblapacke.a:
	@orig=$$PWD
	cd $$PWD/$(LAPACK_LIB);\
	$(MAKE) lapackelib

.cpp.o:
	$(MPICXX) -c $< $(CXX_OPTS) $(INCLUDES) -o $@

%.d:%.cpp
	$(MPICXX) -MM $< $(INCLUDES) -MT $(<:.cpp=.o) > $@

.f.o: 
	$(FXX) -c $< $(FXX_OPTS) $(INCLUDES) -o $@

clean:
	rm $(OBJS_ALL); \
	rm $(DEPS_ALL); \
	rm $(EXE_SOLVER); \
	rm $(EXE_DECOMP); \
	rm $(EXE_GRIDMOD); \
	rm $(EXE_RECOMP); \
	rm $(DEPS_TEST); \
	rm $(EXE_FINDPOINT); \
	rm $(EXE_PORTOPT); \
	rm $(EXE_CHEMPROPS); \
	rm $(EXE_TESTS); \
	rm $(EXE_STRUCT_SOLVER); \
	rm $(EXE_STRUCT_ERROR); \
	rm ./structuralDynamics/error.o; \
	rm ./ucs/libcommon.a; \
	rm ./structuralDynamics/libstructdyn.a; 

cleanall:
	@orig=$$PWD;\
	$(MAKE) clean;\
	cd $$orig/$(HDF5DIR);\
	$(MAKE) clean;\
	$(MAKE) distclean-am;\
	cd $$orig/$(METISDIR);\
	$(MAKE) clean;\
	$(MAKE) distclean;\
	cd $$orig/$(TINYXMLDIR);\
	$(MAKE) clean;\
	cd $$orig/$(LAPACKDIR);\
	$(MAKE) clean;\
	rm $$orig/$(METISINSTALLDIR)/configRun;\
	rm $$orig/$(HDF5INSTALLDIR)/configRun

todo: 
	@orig=$$PWD;\
	for dir in $(SRCDIRS);  do\
	  cd $$dir;\
	  pwd;\
	  grep -iRn todo ./*.cpp ./*.h ./*.tcc;\
	  cd $$orig ;\
	done	
dist:
	tar -cvzf src.tgz ./* --exclude='src.tgz'

cleanucs:
	rm $(OBJS_ALL) $(EXE_ALL) $(DEPS_ALL)

~/.proteusCFD/database/chemdb.hdf5:
	@orig=$$PWD;\
	cd ./chemdata;\
	./chemDB.py

all: $(EXE_SOLVER) $(EXE_DECOMP) $(EXE_GRIDMOD) $(EXE_RECOMP) $(EXE_FINDPOINT) $(EXE_TESTS)\
	$(EXE_CHEMPROPS) $(EXE_STRUCT_SOLVER) $(EXE_STRUCT_ERROR) $(EXE_PORTOPT) database

tools: $(EXE_DECOMP) $(EXE_GRIDMOD) $(EXE_RECOMP) $(EXE_CHEMPROPS) $(EXE_FINDPOINT)
tests: $(EXE_TESTS)
chemprops: $(EXE_CHEMPROPS)
ucs: $(EXE_SOLVER)
decomp: $(EXE_DECOMP)
recomp: $(EXE_RECOMP)
gridmod: $(EXE_GRIDMOD)
database: ~/.proteusCFD/database/chemdb.hdf5

.PHONY: tests chemprops all tools ucs decomp recomp gridmod database

-include $(DEPS_ALL)

