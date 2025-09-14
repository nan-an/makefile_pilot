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
PROJECT = pilot
PROJECT_VERSION = 0.1.0
CC = gcc
INCLUDE_DIR = include
SRC_DIR = src
OBJ_DIR = dist
DEP_DIR = .dep

CFLAGS = -Wall -Wextra -g -pedantic -std=c11 -I./$(INCLUDE_DIR)

# passing the version of the project as a preprocessor macro definition.
CFLAGS += -DPROJECT_VERSION=\"$(PROJECT_VERSION)\"

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

DEPS := $(patsubst $(SRC_DIR)/%.c,$(DEP_DIR)/%.d,$(SRCS))
DEPFLAGS = -MMD -MP -MF $(DEP_DIR)/$*.d

TARGET = $(OBJ_DIR)/$(PROJECT)

.PHONY: all clean vars


all: $(OBJ_DIR) $(TARGET)
	@echo "Build complete. Executable is $(TARGET)"

$(TARGET): $(OBJS)
	$(CC) -o $@ $^

# This should be individual file pattern then only $< will work.
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR) $(DEP_DIR)
	$(CC) -c $(CFLAGS) $(DEPFLAGS) -o $@ $<


$(OBJ_DIR) $(DEP_DIR):
	mkdir -p $@

$(DEP_DIR)/%.d:
	

include $(DEPS)


clean:
	rm -rf $(OBJ_DIR) $(DEP_DIR) $(TARGET)

bear: clean
	@echo "Generating compile_commands.json using bear..."
	bear -- $(MAKE) all

vars:
	@echo "Build Variables:"
	@echo "================"
	@echo "MAKE TOOL: $(MAKE)"
	@echo "Project: $(PROJECT)"
	@echo "Compiler: $(CC)"
	@echo "Path to compile_command.json: $(CC_J)"
	@echo "Compiler Flags: $(CFLAGS)"
	@echo "Source Directory: $(SRC_DIR)"
	@echo "Object Directory: $(OBJ_DIR)"
	@echo "Source Files: $(SRCS)"
	@echo "Object Files: $(OBJS)"
	@echo "Target Executable: $(TARGET)"
