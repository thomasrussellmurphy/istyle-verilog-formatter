#-------------------------------------------------------------------------------
#
# File:         Makefile
#
# Author:       Stephen Brennan
#
# Date Created: Friday, 17 July 2015
#
# Description:  Generic C Makefile
#
# This is a generic makefile, suitable for any C programming project.  It comes
# with several features:
# - Running tests, with Valgrind.
# - Generation of documentation through Doxygen.  You'll need to provide a
#   Doxyfile.
# - Code coverage reports via gcov.
# - Build configurations: debug, release, and coverage.
# - Automatic dependency generation, so you never need to update this file.
#
# To use:
# 1. You should organize your project like this:
#    src/
#    |--- code.c
#    |--- module-1.h
#    |--- module-1/code.c
#    \--- module-2/code.c
#    test/
#    \--- test-code.c
#    inc/
#    \--- public-header.h
# 2. Fill out the variables labelled CONFIGURATION.
# 3. Build configurations are: debug, release, coverage.  Run make like this:
#    make CFG=configuration target
#    The default target is release, so you can omit it normally.
# 4. Targets:
#    - all: makes your main project
#    - test: makes and runs tests
#    - doc: builds documentation
#    - cov: generates code coverage (MUST have CFG=coverage)
#    - clean: removes object and binary files
#    - clean_{doc,cov,dep}: removes documentation/coverage/dependencies
#
# This code is in the public domain, for anyone to use or modify in any way.
#
#-------------------------------------------------------------------------------

# --- CONFIGURATION: Definitely change this stuff!
# PROJECT_NAME - not actually used.  but what's your project's name?
PROJECT_NAME="iStyle Verilog Formatter"
# PROJECT_TYPE - staticlib, dynamiclib, executable
PROJECT_TYPE=executable
# PROJECT_MAIN - filename within your source directory that contains main()
PROJECT_MAIN=astyle_main.cpp
# TARGET - the name you want your target to have (bin/release/[whatgoeshere])
TARGET=iStyle
# TEST_TARGET - the name you want your tests to have (probably test)
TEST_TARGET=test
# STATIC_LIBS - path to any static libs you need.  you may need to make a rule
# to generate them from subprojects.
STATIC_LIBS=
# EXTRA_INCLUDES - folders that should also be include directories (say, for
# static libs?)
EXTRA_INCLUDES=

# --- DIRECTORY STRUCTURE: This structure is highly recommended, but you can
# change it.  The most important thing is that *none* of these directories are
# subdirectories of each other.  They should be completely disjoint.  Also,
# being too creative with directories could seriously mess up gcov, which is a
# finicky beast.
SOURCE_DIR=src
TEST_DIR=test
INCLUDE_DIR=inc
OBJECT_DIR=obj
BINARY_DIR=bin
DEPENDENCY_DIR=dep
DOCUMENTATION_DIR=doc
COVERAGE_DIR=cov

# --- COMPILATION FLAGS: Things you may want/need to configure, but I've put
# them at sane defaults.
CC=g++
FLAGS=-Wall -Wextra -pedantic
INC=-I$(INCLUDE_DIR) -I$(SOURCE_DIR) $(addprefix -I,$(EXTRA_INCLUDES))
CFLAGS=$(FLAGS) -std=c++03  -fPIC $(INC) -c
LFLAGS=$(FLAGS)

# --- BUILD CONFIGURATIONS: Feel free to get creative with these if you'd like.
# The advantage here is that you can update variables (like compile flags) based
# on the build configuration.
CFG=release
ifeq ($(CFG),debug)
FLAGS += -g -DDEBUG
endif
ifeq ($(CFG),coverage)
CFLAGS += -fprofile-arcs -ftest-coverage
LFLAGS += -fprofile-arcs -lgcov
endif
ifneq ($(CFG),debug)
ifneq ($(CFG),release)
ifneq ($(CFG),coverage)
$(error Bad build configuration.  Choices are debug, release, coverage.)
endif
endif
endif

# --- FILENAME LISTS: (and other internal variables) You probably don't need to
# mess around with this stuff, unless you have a decent understanding of
# everything this Makefile does.
DIR_GUARD=@mkdir -p $(@D)
OBJECT_MAIN=$(OBJECT_DIR)/$(CFG)/$(SOURCE_DIR)/$(patsubst %.cpp,%.o,$(PROJECT_MAIN))

SOURCES=$(shell find $(SOURCE_DIR) -type f -name "*.cpp")
OBJECTS=$(patsubst $(SOURCE_DIR)/%.cpp,$(OBJECT_DIR)/$(CFG)/$(SOURCE_DIR)/%.o,$(SOURCES))

TEST_SOURCES=$(shell find $(TEST_DIR) -type f -name "*.cpp")
TEST_OBJECTS=$(patsubst $(TEST_DIR)/%.cpp,$(OBJECT_DIR)/$(CFG)/$(TEST_DIR)/%.o,$(TEST_SOURCES))

DEPENDENCIES  = $(patsubst $(SOURCE_DIR)/%.cpp,$(DEPENDENCY_DIR)/$(SOURCE_DIR)/%.d,$(SOURCES))
DEPENDENCIES += $(patsubst $(TEST_DIR)/%.cpp,$(DEPENDENCY_DIR)/$(TEST_DIR)/%.d,$(TEST_SOURCES))

# --- GLOBAL TARGETS: You can probably adjust and augment these if you'd like.
.PHONY: all test clean clean_all clean_cov clean_doc

all: $(BINARY_DIR)/$(CFG)/$(TARGET)

test: $(BINARY_DIR)/$(CFG)/$(TEST_TARGET)
	valgrind $(BINARY_DIR)/$(CFG)/$(TEST_TARGET)

doc: $(SOURCES) $(TEST_SOURCES) Doxyfile
	doxygen

cov: $(BINARY_DIR)/$(CFG)/$(TEST_TARGET)
	@if [ "$(CFG)" != "coverage" ]; then \
	  echo "You must run 'make CFG=coverage coverage'."; \
	  exit 1; \
	fi
	rm -f coverage.info
	$(BINARY_DIR)/$(CFG)/$(TEST_TARGET)
	lcov -c -d $(OBJECT_DIR)/$(CFG) -b $(SOURCE_DIR) -o coverage.info
	lcov -e coverage.info "`pwd`/$(SOURCE_DIR)/*" -o coverage.info
	genhtml coverage.info -o $(COVERAGE_DIR)
	rm coverage.info

clean:
	rm -rf $(OBJECT_DIR)/$(CFG)/* $(BINARY_DIR)/$(CFG)/* $(SOURCE_DIR)/*.gch

clean_all: clean_cov clean_doc
	rm -rf $(OBJECT_DIR) $(BINARY_DIR) $(DEPENDENCY_DIR) $(SOURCE_DIR)/*.gch

clean_docs:
	rm -rf $(DOCUMENTATION_DIR)

clean_cov:
	rm -rf $(COVERAGE_DIR)

# RULE TO BUILD YOUR MAIN TARGET HERE: (you may have to edit this, but it it
# configurable).
$(BINARY_DIR)/$(CFG)/$(TARGET): $(OBJECTS) $(STATIC_LIBS)
	$(DIR_GUARD)
ifeq ($(PROJECT_TYPE),staticlib)
	ar rcs $@ $^
endif
ifeq ($(PROJECT_TYPE),dynamiclib)
	$(CC) -shared $(LFLAGS) $^ -o $@
endif
ifeq ($(PROJECT_TYPE),executable)
	$(CC) $(LFLAGS) $^ -o $@
endif

# RULE TO BULID YOUR TEST TARGET HERE: (it's assumed that it's an executable)
$(BINARY_DIR)/$(CFG)/$(TEST_TARGET): $(filter-out $(OBJECT_MAIN),$(OBJECTS)) $(TEST_OBJECTS) $(STATIC_LIBS)
	$(DIR_GUARD)
	$(CC) $(LFLAGS) $^ -o $@

# --- Generic Compilation Command
$(OBJECT_DIR)/$(CFG)/%.o: %.cpp
	$(DIR_GUARD)
	$(CC) $(CFLAGS) $< -o $@

# --- Automatic Dependency Generation
$(DEPENDENCY_DIR)/%.d: %.cpp
	$(DIR_GUARD)
	$(CC) $(CFLAGS) -MM $< | sed -e 's!\(.*\)\.o:!$@ $(OBJECT_DIR)/$$(CFG)/$(<D)/\1.o:!' > $@

# --- Include Generated Dependencies
ifneq "$(MAKECMDGOALS)" "clean_all"
-include $(DEPENDENCIES)
endif
