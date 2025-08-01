#!/usr/bin/make -f

# This Makefile has been proudly crafted by Malte Schilling in 2025.
# It is released into the Public Domain, you are free to use it in any
# project under any license!

#######################
# BEGIN OF USER SETUP #
#######################

# Compiler and Flags
CXX ?= g++
CXXFLAGS = $(WARNINGS) -std=$(STANDARD) -O2 -I$(SRC_DIR)
STANDARD = c++17
WARNINGS = -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion -Wformat=2
LDFLAGS =

# Directories
SRC_DIR = src
HDR_DIR = src
BUILD_DIR = build
INSTALLDIR = ~/bin/

# Source, Header and Object files
SRCS = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*.c)
HDRS = $(wildcard $(HDR_DIR)/*.hpp) $(wildcard $(HDR_DIR)/*.h)
OBJS = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))

# Output
TARGET = stopwatch

################
# END OF SETUP #
################

# Defaulttarget
.PHONY: all
all: $(TARGET)

# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)
	@if [ "$@" = "$(firstword $(OBJS))" ]; then \
		echo "\n$(BOLD)$(CYAN)Compiling:$(RESET) $(BOLD)$(NEEDEDOBJS) Files"; \
		if [ "$(NEEDEDOBJS)" = "0" ]; then \
			echo "$(BOLD)$(YELLOW)WARNING:$(RESET)"; \
			echo "$(YELLOW)Looks like you supplied '-B' or '--always-make' to 'make'. Some Variables may be wrong.$(RESET)"; \
			echo "$(YELLOW)You may also encounter some errors, which are $(BOLD)NOT$(RESET)$(YELLOW) breaking the build process.$(RESET)\n"; \
			echo "$(GREEN)$(BOLD)SOLUTION:$(RESET)"; \
			echo "If you want to rebuild everything simply run 'make clean' before rebuilding!$(RESET)\n"; \
			sleep 1; \
		fi \
	fi
	@echo "$(YELLOW)$(UNDERLINE)Now Compiling:$(RESET) $(BOLD)$< $(RESET)into $(BOLD)$@$(RESET)"
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "$(GREEN)$(UNDERLINE)Done compiling$(RESET) $(BOLD)$(notdir $@)$(RESET)"
	@$(eval DONEOBJS = $(shell expr $(DONEOBJS) + "1"))
	@printf "$(BOLD)$(CYAN)Progress: $(BOLD)$(GREEN)%.0f%%$(RESET)\n" $(shell echo "scale=2; ($(DONEOBJS) * 100) / $(NEEDEDOBJS)" | bc)

# Link
$(TARGET): $(OBJS)
	@echo "\n$(BOLD)$(CYAN)Linking: $(BOLD)$(TARGET)$(RESET)"
	$(CXX) $^ -o $@ $(LDFLAGS)
	@echo "$(BOLD)$(GREEN)DONE BUILDING EXECUTABLE$(RESET)"

# Make the build directory if needed
$(BUILD_DIR):
	@echo "\n$(BOLD)$(CYAN)Making build directory:$(RESET)"
	mkdir -pv $(BUILD_DIR)

# Install target
.PHONY: install
install: $(TARGET)
	@echo "\n$(BOLD)$(CYAN)Installing $(TARGET) at $(INSTALLDIR):$(RESET)"
	@cp -fv $(TARGET) $(INSTALLDIR) || sudo mv -iv $(TARGET) $(INSTALLDIR)

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
	@echo
	@echo "The following are the valid targets for this Makefile:"
	@echo "... $(BOLD)all$(RESET)       the default if no target is provided (usually the same as \
	\"$(UNDERLINE)$(TARGET)$(RESET)\" and \"$(UNDERLINE)target$(RESET)\")"
	@echo "... $(BOLD)target$(RESET)    make the executable"
	@echo "... $(BOLD)install$(RESET)   make and move the executable to $(INSTALLDIR)"
	@echo "... $(BOLD)clean$(RESET)     removes the build directory and its contents like object files"
	@echo "... $(BOLD)cleanall$(RESET)  removes all of the above and also the executable inside this folder"
	@echo
	@echo "also the following are valid targets:"
	@echo "$(BOLD)$(TARGET) $(OBJS)$(RESET)"

# Some ASCII Escapes as constants
override RESET = \033[0m
override BOLD = \033[1m
override ITALIC = \033[36m
override UNDERLINE = \033[4m
override SWAPBGFG = \033[7m
override SWAPFGBG = $(SWAPBGFG)
override RED = \033[31m
override GREEN = \033[32m
override YELLOW = \033[33m
override BLUE = \033[34m
override MAGENTA = \033[35m
override CYAN = \033[36m
override WHITE = \033[37m

DONEOBJS := 0
override TSOBJS     = $(foreach obj, $(OBJS), $(shell stat -c %Y $(obj) 2>/dev/null || echo 0))
override TSSRCS     = $(foreach src, $(SRCS), $(shell stat -c %Y $(src) 2>/dev/null || echo 0))
NEEDEDOBJS := $(shell \
	count=0; \
	i=0; \
	for src in $(SRCS); do \
		obj=$$(echo $(OBJS) | cut -d' ' -f$$((i+1))); \
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
		obj=$$(echo $(OBJS) | cut -d' ' -f$$((i+1))); \
		ts_src=$$(stat -c %Y $$src 2>/dev/null || echo 0); \
		ts_obj=$$(stat -c %Y $$obj 2>/dev/null || echo 0); \
		if [ $$ts_src -gt $$ts_obj ]; then echo $$obj; fi; \
		i=$$((i+1)); \
	done \
)

.PHONY: target
target: all


