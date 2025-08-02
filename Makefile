#!/usr/bin/make -f

# This Makefile has been proudly crafted by Malte Schilling in 2025.
# It is released into the Public Domain, you are free to use it in any
# project under any license!

#######################
# BEGIN OF USER SETUP #
#######################

# Default target
# Set this to 'target' to build the executable, 'all' to build everything
defaulttarget: target

# Compiler and Flags
COMPILER ?= g++
COMPILER_FLAGS =
STANDARD = c++17
LINKER_FLAGS =
WARNINGS = -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion -Wformat=2

override CONST_COMPILER_FLAGS = $(COMPILER_FLAGS) $(WARNINGS) -std=$(STANDARD) -O2 -I$(HDR_DIR)

# Directories
SRC_DIR ?= src
HDR_DIR ?= src
BUILD_DIR ?= build
INSTALL_DIR ?= ~/bin

# Source, Header and Object files
SRCS = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*.c)
HDRS = $(wildcard $(HDR_DIR)/*.hpp) $(wildcard $(HDR_DIR)/*.h)
OBJS = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))
ASMS = $(addprefix $(BUILD_DIR)/, $(addsuffix .s, $(notdir $(basename $(SRCS)))))
DOTI = $(addprefix $(BUILD_DIR)/, $(addsuffix .i, $(notdir $(basename $(SRCS)))))

# Output
TARGET = stopwatch

################
# END OF SETUP #
################

# Build executable, assembly files and preprocessed files
.PHONY: all
all: $(TARGET) $(ASMS) $(DOTI)

# Build the executable
.PHONY: target
target: $(TARGET)


# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)
	@if [ "$@" = "$(firstword $(OBJS))" ]; then																	\
		printf "\n$(BOLD)$(CYAN)Compiling:$(RESET) $(BOLD)$(NEEDEDOBJS) Files: ";								\
		if [ "$(NEEDEDOBJS)" -ne 0 ]; then																		\
			echo "[ $(foreach var,$(notdir $(REBUILD_OBJS)),$(UNDERLINE)$(BOLD)$(var)$(RESET)) ]";				\
		else																									\
			echo;																								\
		fi;																										\
		if [ "$(NEEDEDOBJS)" = "0" ]; then																		\
			echo "$(BOLD)$(YELLOW)WARNING:$(RESET)";															\
			echo "$(YELLOW)Looks like you supplied "-B" or "--always-make" to \
	"make". Some Variables may be wrong.$(RESET)";																\
			echo "$(YELLOW)You may also encounter some errors, which are \
	$(BOLD)NOT$(RESET)$(YELLOW) breaking the build process.$(RESET)\n";											\
			echo "$(GREEN)$(BOLD)SOLUTION:$(RESET)";															\
			echo "If you want to rebuild everything simply run "make clean" before rebuilding!$(RESET)\n";		\
		fi;																										\
		sleep 1;																								\
	fi
	@echo "$(BMAGENTA)$(UNDERLINE)Now Compiling:$(RESET) $(BOLD)$< $(RESET)into $(BOLD)$(dir $@)$(UNDERLINE)$(notdir $@)$(RESET)"
	@$(COMPILER) -c $< -o $@ $(CONST_COMPILER_FLAGS)
	@echo "$(GREEN)$(UNDERLINE)Done compiling$(RESET) $(BOLD)$(UNDERLINE)$(notdir $@)$(RESET)"
	@$(eval DONEOBJS = $(shell expr $(DONEOBJS) + "1"))
	@printf "$(BOLD)$(CYAN)Progress: $(BOLD)$(GREEN)%.0f%%$(RESET)\n" $(shell echo "scale=2; ($(DONEOBJS) * 100) / $(NEEDEDOBJS)" | bc)

# Assemble
.PHONY: assemble
assemble: $(ASMS)
$(BUILD_DIR)/%.s: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)
	@if [ "$@" = "$(firstword $(ASMS))" ]; then																	\
		printf "\n$(BOLD)$(CYAN)Assembling:$(RESET)\n";																	\
	fi
	@echo "$(BMAGENTA)$(UNDERLINE)Now Assembling:$(RESET) $(BOLD)$< $(RESET)into $(BOLD)$(dir $@)$(UNDERLINE)$(notdir $@)$(RESET)"
	@$(COMPILER) -S $< -o $@ $(CONST_COMPILER_FLAGS)
	@echo "$(GREEN)$(UNDERLINE)Done assembling$(RESET) $(BOLD)$(UNDERLINE)$(notdir $@)$(RESET)"

# Preprocess
.PHONY: preprocess
preprocess: $(DOTI)
$(BUILD_DIR)/%.i: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)
	@if [ "$@" = "$(firstword $(DOTI))" ]; then														\
		printf "\n$(BOLD)$(CYAN)Preprocessing:$(RESET)\n";											\
	fi
	@echo "$(BMAGENTA)$(UNDERLINE)Now Preprocessing:$(RESET) $(BOLD)$< $(RESET)into $(BOLD)$(dir $@)$(UNDERLINE)$(notdir $@)$(RESET)"
	@$(COMPILER) -E $< -o $@ $(CONST_COMPILER_FLAGS)
	@echo "$(GREEN)$(UNDERLINE)Done preprocessing$(RESET) $(BOLD)$(UNDERLINE)$(notdir $@)$(RESET)"

# Link
$(TARGET): $(OBJS)
	@echo "\n$(BOLD)$(CYAN)Linking: $(BOLD)$(UNDERLINE)$(TARGET)$(RESET)"
	$(COMPILER) $^ -o $@ $(LINKER_FLAGS)
	@echo "$(BOLD)$(GREEN)DONE BUILDING EXECUTABLE!$(RESET)"

# Make the build directory if needed
$(BUILD_DIR):
	@echo "\n$(BOLD)$(CYAN)Making build directory:$(RESET)"
	mkdir -pv $(BUILD_DIR)

# Install target
.PHONY: install
install: $(TARGET)
	@echo "\n$(BOLD)$(CYAN)Installing $(TARGET) at $(INSTALL_DIR):$(RESET)"
	@cp -fv $(TARGET) $(INSTALL_DIR) || sudo mv -iv $(TARGET) $(INSTALL_DIR)

# Uninstall target
.PHONY: uninstall
uninstall: $(INSTALL_DIR)/$(TARGET)
	@echo "$(BOLD)$(CYAN)Uninstalling $(INSTALL_DIR)/$(TARGET)$(RESET)"
	@rm -rfv $(INSTALL_DIR)/$(TARGET) || sudo rm -rfv $(INSTALL_DIR)/$(TARGET)
	@echo "$(BOLD)$(GREEN)DONE UNINSTALLING!$(RESET)"

# Clean Object files
.PHONY: clean
clean:
	@echo "\n$(BOLD)$(CYAN)Removing object files and build directory:$(RESET)"
	rm -rfv $(BUILD_DIR)

# Clean out file and objects
.PHONY:cleanall
cleanall: clean
	@echo "\n$(BOLD)$(CYAN)Removing executable:$(RESET)"
	rm -rfv $(TARGET)

# help target
.PHONY: help
help:
	@echo "\n$(BOLD)$(CYAN)Help for this Makefile:$(RESET)"
	@echo "Invoke $(BWHITE)\"make\"$(RESET)                      to build $(BOLD)$(TARGET)$(RESET)"
	@echo "or     $(BWHITE)\"make [target] [option(s)]\"$(RESET) to specify a target and/or options."
	@echo
	@echo "The following are the valid targets for this Makefile:"
	@echo "... $(BOLD)all$(RESET)               build the executable, assembly files and preprocessed files"
	@echo "... $(BOLD)target$(RESET)            make the executable"
	@echo "... $(BOLD)install$(RESET)           make and move the executable to $(INSTALL_DIR)"
	@echo "... $(BOLD)uninstall$(RESET)         removes the executable from $(INSTALL_DIR)"
	@echo "... $(BOLD)help$(RESET)              prints this help message"
	@echo "... $(BOLD)assemble$(RESET)          compiles the source files into assembly files in the build directory ($(BUILD_DIR))"
	@echo "... $(BOLD)preprocess$(RESET)        compiles the source files into preprocessed files in the build directory ($(BUILD_DIR))"
	@echo "... $(BOLD)clean$(RESET)             removes the build directory and its contents like object files"
	@echo "... $(BOLD)cleanall$(RESET)          removes all of the above and also the executable inside this folder"
	@echo "also the following are valid targets:"
	@echo "$(BOLD)$(TARGET) $(OBJS) $(ASMS)$(RESET)\n"
	@echo "The following are the valid options for this Makefile:"
	@echo "... $(BOLD)BUILD_DIR=$(RESET)        directory, where intermediate files will be stored,   default is $(BUILD_DIR)"
	@echo "... $(BOLD)SRC_DIR=$(RESET)          directory, where make will look for source files,     default is $(SRC_DIR)"
	@echo "... $(BOLD)HDR_DIR=$(RESET)          directory, where make will look for header files,     default is $(HDR_DIR)"
	@echo "... $(BOLD)INSTALL_DIR=$(RESET)      directory, where the executable will be installed to, default is $(INSTALL_DIR)"
	@echo "... $(BOLD)COMPILER=$(RESET)         compiler to use,                                      default is $(COMPILER)"
	@echo "... $(BOLD)COMPILER_FLAGS=$(RESET)   compiler flags to use,                                default is empty"
	@echo "... $(BOLD)STANDARD=$(RESET)         C++ standard to use,                                  default is $(STANDARD)"
	@echo "... $(BOLD)LINKER_FLAGS=$(RESET)     linker flags to use,                                  default is empty"

# Some ASCII Escapes as constants
override RESET = \033[0m
override BOLD = \033[1m
override ITALIC = \033[36m
override UNDERLINE = \033[4m
override SWAPBGFG = \033[7m
override SWAPFGBG = $(SWAPBGFG)
override BLACK = \033[30m
override RED = \033[31m
override GREEN = \033[32m
override YELLOW = \033[33m
override BLUE = \033[34m
override MAGENTA = \033[35m
override CYAN = \033[36m
override WHITE = \033[37m
override BBLACK = \033[90m
override BRED = \033[91m
override BGREEN = \033[92m
override BYELLOW = \033[93m
override BBLUE = \033[94m
override BMAGENTA = \033[95m
override BCYAN = \033[96m
override BWHITE = \033[97m

DONEOBJS := 0
override TSOBJS     = $(foreach obj, $(OBJS), $(shell stat -c %Y $(obj) 2>/dev/null || echo 0))
override TSSRCS     = $(foreach src, $(SRCS), $(shell stat -c %Y $(src) 2>/dev/null || echo 0))
NEEDEDOBJS := $(shell \
	count=0; \
	i=0; \
	for src in $(SRCS); do \
		obj=$$(echo $(OBJS) | cut -d" " -f$$((i+1))); \
		ts_src=$$(stat -c %Y $$src 2>/dev/null || echo 0); \
		ts_obj=$$(stat -c %Y $$obj 2>/dev/null || echo 0); \
		if [ $$ts_src -gt $$ts_obj ]; then count=$$((count+1)); fi; \
		i=$$((i+1)); \
	done; \
	echo $$count \
)
override REBUILD_OBJS := $(shell \
	i=0; \
	for src in $(SRCS); do \
		obj=$$(echo $(OBJS) | cut -d" " -f$$((i+1))); \
		ts_src=$$(stat -c %Y $$src 2>/dev/null || echo 0); \
		ts_obj=$$(stat -c %Y $$obj 2>/dev/null || echo 0); \
		if [ $$ts_src -gt $$ts_obj ]; then echo $$obj; fi; \
		i=$$((i+1)); \
	done \
)

