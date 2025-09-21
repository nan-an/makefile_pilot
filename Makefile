# Make file for buildinga C project
# C source files are to be in "src" directory
# Header files are to be in "include" directory
# Object files will be placed in "dist" directory
# The final executable will be named as Project name
# Usage:
#   make        - to build the project
#   make clean  - to remove object files and executable
#   make run    - to run the executable
#   make debug  - to build with debug information
#   make release- to build with optimizations
#   make help   - to display this help message
#   Author: github/ash-nan
#   Date: 2025-09-14
#   Version: 1.0.0
#   License: MIT

# CHANGE THE PROJECT NAME AND VERSION AS NEEDED.
PROJECT = pilot
PROJECT_VERSION = 0.1.0
# CC = clang-19
# LD = clang-19
CC = gcc
LD = gcc
MC = /usr/bin/valgrind
MACMC = /usr/bin/leaks
INCLUDE_DIR = include
SRC_DIR = src
OBJ_DIR = dist
DEP_DIR = .dep

TEST_DIR = tests
TEST_SRC_DIR = $(TEST_DIR)/src
TEST_OBJ_DIR = $(TEST_DIR)/dist
TEST_DEP_DIR = $(TEST_DIR)/.dep

CFLAGS = -Wall -Wextra -g -fPIC -pedantic -pthread -std=c11 -I./$(INCLUDE_DIR)

# passing the version of the project as a preprocessor macro definition.
CFLAGS += -DPROJECT_VERSION=\"$(PROJECT_VERSION)\"

# Linker flags can be added here if needed.
LDFLAGS = -lpthread

# Include external dependencies if any.
include depends.mk


MAIN_FILE := $(SRC_DIR)/main.c
MAIN_OBJ := $(OBJ_DIR)/main.o


SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
LIB_SRCS := $(filter-out $(MAIN_FILE),$(SRCS))
LIB_OBJS := $(filter-out $(MAIN_OBJ),$(OBJS))

DEPS := $(patsubst $(SRC_DIR)/%.c,$(DEP_DIR)/%.d,$(SRCS))
DEPFLAGS = -MMD -MP -MF $(DEP_DIR)/$*.d

TARGET = $(OBJ_DIR)/$(PROJECT)
LIB_TARGET = $(OBJ_DIR)/lib$(PROJECT).a
LIB_SHARED_TARGET = $(OBJ_DIR)/lib$(PROJECT).so


TEST_SRCS := $(wildcard $(TEST_SRC_DIR)/*.c)
TEST_OBJS := $(patsubst $(TEST_SRC_DIR)/%.c,$(TEST_OBJ_DIR)/%.o,$(TEST_SRCS))
TEST_DEPS := $(patsubst $(TEST_SRC_DIR)/%.c,$(TEST_DEP_DIR)/%.d,$(TEST_SRCS))
TEST_TARGETS = $(patsubst $(TEST_SRC_DIR)/%.c,$(TEST_OBJ_DIR)/%_tests,$(TEST_SRCS))
TEST_CFLAGS = $(CFLAGS) -I./$(TEST_DIR)/include -DTEST
TEST_DEPFLAGS = -MMD -MP -MF $(TEST_DEP_DIR)/$*.d
TEST_LDFLAGS =

.PHONY: all clean vars bear mc macmc


all: $(OBJ_DIR) $(TARGET) $(LIB_TARGET) $(LIB_SHARED_TARGET)
	@echo "Build complete. Executable is $(TARGET)"

# Linking step, so Linker and Linker flags are used here.
$(TARGET): $(SRCS)
	$(LD) $(CFLAGS) $(SRCS) -o $@ $(LDFLAGS)

$(LIB_TARGET): $(LIB_OBJS)
	ar rcs $@ $^

$(LIB_SHARED_TARGET): $(LIB_OBJS)
	$(CC) -shared -o $@ $^


# This should be individual file pattern then only $< will work.
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR) $(DEP_DIR)
	$(CC) -c $(CFLAGS) $(DEPFLAGS) -o $@ $<


$(OBJ_DIR) $(DEP_DIR):
	mkdir -p $@

$(DEP_DIR)/%.d:
	

# This shouls set up correct dependency between .o and .h files.
include $(DEPS)

mc: $(TEST_OBJS) $(TEST_TARGETS)
	@echo "All tests built."
	@for test in $(TEST_TARGETS); do \
		echo "Running memory check on $$test..."; \
		$(MC) --tool=memcheck --gen-suppressions=all --leak-check=full --leak-resolution=med --track-origins=yes --vgdb=no ./$$test;	 \
	done

# Mac OS specific memory check using Leaks tool.
macmc: $(TEST_OBJS) $(TEST_TARGETS)
	@echo "All tests built."
	@for test in $(TEST_TARGETS); do \
		echo "Running memory check with Mac OS Leaks on $$test..."; \
		$(MACMC) --atExit --list -- ./$$test;	 \
	done

# Test targets
tests: $(TEST_OBJS) $(TEST_TARGETS)
	@echo "All tests built."
	@for test in $(TEST_TARGETS); do \
		echo "Running $$test..."; \
		./$$test; \
	done

$(TEST_OBJ_DIR) $(TEST_DEP_DIR):
	mkdir -p $@

$(TEST_OBJ_DIR)/%_tests: $(TEST_OBJ_DIR)/%.o $(LIB_TARGET)
	$(LD) $(TEST_LDFLAGS) -o $@ $< $(LIB_TARGET)

$(TEST_OBJ_DIR)/%.o: $(TEST_SRC_DIR)/%.c | $(TEST_OBJ_DIR) $(TEST_DEP_DIR)
	$(CC) -c $(TEST_CFLAGS) $(TEST_DEPFLAGS) -o $@ $<

$(TEST_DEP_DIR)/%.d:
	# Dependency files for test sources will be generated here.

include $(TEST_DEPS)

clean:
	rm -rf $(OBJ_DIR) $(DEP_DIR) $(TARGET) $(LIB_TARGET) $(LIB_SHARED_TARGET) $(TEST_OBJ_DIR) $(TEST_DEP_DIR) $(TEST_TARGETS)
	@echo "Cleaned up build artifacts."

bear: clean
	@echo "Generating compile_commands.json using bear..."
	bear -- $(MAKE) all tests

vars:
	@echo "Build Variables:"
	@echo "================"
	@echo "MAKE TOOL: $(MAKE)"
	@echo "Project: $(PROJECT)"
	@echo "Compiler: $(CC)"
	@echo "Linker: $(LD)"
	@echo "Compiler Flags: $(CFLAGS)"
	@echo "Linker Flags: $(LDFLAGS)"
	@echo "Source Directory: $(SRC_DIR)"
	@echo "Object Directory: $(OBJ_DIR)"
	@echo "Source Files: $(SRCS)"
	@echo "Object Files: $(OBJS)"
	@echo "Dependency Files: $(DEPS)"
	@echo "Target Executable: $(TARGET)"
	@echo "Library Target: $(LIB_TARGET)"
	@echo "Shared Library Target: $(LIB_SHARED_TARGET)"
	@echo "Test Source Directory: $(TEST_SRC_DIR)"
	@echo "Test Object Directory: $(TEST_OBJ_DIR)"
	@echo "Test Source Files: $(TEST_SRCS)"
	@echo "Test Object Files: $(TEST_OBJS)"
	@echo "Test Dependency Files: $(TEST_DEPS)"
	@echo "Test Targets: $(TEST_TARGETS)"
	@echo "Test Compiler Flags: $(TEST_CFLAGS)"
	@echo "Test Linker Flags: $(TEST_LDFLAGS)"
	@echo "================"
