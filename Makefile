#!/usr/bin/make -f

MAKEFLAGS += --no-print-directory

# This Makefile has been proudly crafted by Malte Schilling in 2025.
# It is released into the Public Domain, you are free to use it in any
# project under any license!

#######################
# BEGIN OF USER SETUP #
#######################

.PHONY: defaulttarget
defaulttarget: target # Set this to 'target' to build the executable, 'all' to build everything, rebuild for a fresh build every time

# Set this to true for release build, false for debug build
RELEASE ?= false

# Compiler and Flags
COMPILER ?= g++
COMPILER_FLAGS =
STANDARD = c++17
LINKER ?= $(COMPILER)
LINKER_FLAGS = -lncurses
WARNINGS = -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion \
-Wformat=2 -Winvalid-pch -Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wcast-qual -Wcast-align -Wstrict-aliasing=2

# Directories
SRC_DIR ?= src
HDR_DIR ?= include
BUILD_DIR ?= build
INSTALL_DIR ?= ~/bin

# Source, Header and Object files
SRCS = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*.c)
HDRS = $(wildcard $(HDR_DIR)/*.hpp) $(wildcard $(HDR_DIR)/*.h) $(wildcard $(SRC_DIR)/*.hpp) $(wildcard $(SRC_DIR)/*.h)
OBJS = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(notdir $(basename $(SRCS)))))
ASMS = $(addprefix $(BUILD_DIR)/asm/, $(addsuffix .s, $(notdir $(basename $(SRCS)))))
DOTI = $(addprefix $(BUILD_DIR)/preprocessed/, $(addsuffix .i, $(notdir $(basename $(SRCS)))))

# Output
TARGET = stopwatch

################
# END OF SETUP #
################

.NOTPARALLEL: install

# Some ASCII Escapes as constants
override R = \033[0m
override B = \033[1m
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
override ONBLACK = \033[40m
override ONRED = \033[41m
override ONGREEN = \033[42m
override ONYELLOW = \033[43m
override ONBLUE = \033[44m
override ONMAGENTA = \033[45m
override ONCYAN = \033[46m
override ONWHITE = \033[47m
override ONBBLACK = \033[100m
override ONBRED = \033[101m
override ONBGREEN = \033[102m
override ONBYELLOW = \033[103m
override ONBBLUE = \033[104m
override ONBMAGENTA = \033[105m
override ONBCYAN = \033[106m
override ONBWHITE = \033[107m

ifeq (,$(findstring help,$(MAKECMDGOALS)))
ifeq ($(RELEASE),true) # Release Flags
override CONST_COMPILER_FLAGS = $(COMPILER_FLAGS) $(WARNINGS) -std=$(STANDARD) -flto -O3 -DNDEBUG -I$(HDR_DIR)
override CONST_LINKER_FLAGS = $(LINKER_FLAGS) -flto -O3
$(shell echo -e 1>&2 "$(B)$(GREEN)=== USING RELEASE CONFIGURATION ===$(R)")
$(shell echo -e 1>&2     "$(GREEN) This Build will utilize the best$(R)")
$(shell echo -e 1>&2     "$(GREEN)possible optimizations towards file$(R)")
$(shell echo -e 1>&2     "$(GREEN)      size and performance!$(R)")
$(shell echo -e 1>&2     "$(GREEN)$(R)")
else # Debug Flags
override CONST_COMPILER_FLAGS = $(COMPILER_FLAGS) $(WARNINGS) -std=$(STANDARD) -g -O0 -I$(HDR_DIR)
override CONST_LINKER_FLAGS = $(LINKER_FLAGS) -g -O0
$(shell echo -e 1>&2 "$(B)$(YELLOW)=== USING DEBUG CONFIGURATION ===$(R)")
$(shell echo -e 1>&2     "$(YELLOW) This Build will not utilize any $(R)")
$(shell echo -e 1>&2     "$(YELLOW) optimizations at all, this mode $(R)")
$(shell echo -e 1>&2     "$(YELLOW) focuses on fast build times and $(R)")
$(shell echo -e 1>&2     "$(YELLOW)           debugability! $(R)")
$(shell echo -e 1>&2     "$(YELLOW)$(R)")
endif
endif

ifneq (,$(findstring B,$(MAKEFLAGS)))
override NEEDEDOBJS = $(words $(OBJS))
override REBUILD_OBJS = $(OBJS)
$(shell echo -e 1>&2 "$(B)$(GREEN)=== ALWAYS MAKE MODE DETECTED ===$(R)")
endif

# Build executable, assembly files and preprocessed files
.PHONY: all
all: $(DOTI) $(ASMS) $(TARGET)

# Build the executable
.PHONY: target
target: $(TARGET)

# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)/
	@if [ "$(findstring j,$(MAKEFLAGS))" = "j" ]; then															\
	echo -e "\n$(YELLOW)$(B)=== PARALLEL COMPILING DETECTED ===";													\
	echo -e "$(YELLOW)This means, the progress shown might";														\
	echo -e "         $(YELLOW)be not accurate!";																	\
	fi
	@if [ "$@" = "$(firstword $(REBUILD_OBJS))" ]; then															\
		printf "\n$(B)$(CYAN)Compiling:$(R) $(B)$(BWHITE)$(NEEDEDOBJS) Files: ";								\
		echo -e "\n  $(B)[$(foreach var,$(notdir $(REBUILD_OBJS)), 												\
	$(UNDERLINE)$(B)$(BWHITE)$(var)$(R))$(B) ]\nwith $(B)$(BWHITE)$(words $(CONST_COMPILER_FLAGS)) \
	Flags:";																									\
	echo -e "$(CONST_COMPILER_FLAGS)\n";																			\
	else																										\
		echo -e;																									\
	fi;
	@sleep 0.1
	@echo -e "$(BMAGENTA)$(UNDERLINE)Now Compiling:$(R) $(B)$< $(R)into $(B)$(dir $@)$(UNDERLINE)$(notdir $@)$(R)"
	@$(COMPILER) -c $< -o $@ $(CONST_COMPILER_FLAGS)
	@echo -e "$(GREEN)$(UNDERLINE)Done compiling$(R) $(B)$(UNDERLINE)$(notdir $@)$(R)"
	@$(eval DONEOBJS = $(shell expr $(DONEOBJS) + "1"))
	@printf "$(B)$(CYAN)Progress: $(B)$(BGREEN)%.0f%%$(R)\n" $(shell echo "scale=0; ($(DONEOBJS) * 100) / $(NEEDEDOBJS)" | bc)

# Assemble
.PHONY: assemble
assemble: $(ASMS)
$(BUILD_DIR)/asm/%.s: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)/asm/
	@if [ "$@" = "$(firstword $(ASMS))" ]; then																	\
		printf "\n$(B)$(CYAN)Assembling:$(R)\n";																\
	fi
	@echo -e "$(BMAGENTA)$(UNDERLINE)Now Assembling:$(R) $(B)$< $(R)into $(B)$(dir $@)$(UNDERLINE)$(notdir $@)$(R)"
	@$(COMPILER) -S $< -o $@ $(CONST_COMPILER_FLAGS)
	@echo -e "$(GREEN)$(UNDERLINE)Done assembling$(R) $(B)$(UNDERLINE)$(notdir $@)$(R)"

# Preprocess
.PHONY: preprocess
preprocess: $(DOTI)
$(BUILD_DIR)/preprocessed/%.i: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)/preprocessed/
	@if [ "$@" = "$(firstword $(DOTI))" ]; then																	\
		printf "\n$(B)$(CYAN)Preprocessing:$(R)\n";																\
	fi
	@echo -e "$(BMAGENTA)$(UNDERLINE)Now Preprocessing:$(R) $(B)$< $(R)into $(B)$(dir $@)$(UNDERLINE)$(notdir $@)$(R)"
	@$(COMPILER) -E $< -o $@ $(CONST_COMPILER_FLAGS)
	@echo -e "$(GREEN)$(UNDERLINE)Done preprocessing$(R) $(B)$(UNDERLINE)$(notdir $@)$(R)"

# Link
$(TARGET): $(OBJS)
	@printf "\n$(B)$(CYAN)Linking executable:$(R) $(B)$(TARGET)$(R) from $(B)$(words $(OBJS)) Files: "
	@echo -e "\n$(B)  [$(foreach var,$(notdir $(OBJS)),															\
	$(UNDERLINE)$(B)$(BWHITE)$(var)$(R))$(B) ]\nwith \
	$(B)$(BWHITE)$(words $(CONST_LINKER_FLAGS)) Flags:";														\
	echo -e "$(CONST_LINKER_FLAGS)\n";																				\
	$(LINKER) $^ $(CONST_LINKER_FLAGS) -o $@
	@echo -e "$(B)$(ONBGREEN)$(BLACK) DONE BUILDING EXECUTABLE! $(R)"

# Make the build directory if needed
.PHONY: $(BUILD_DIR)
$(BUILD_DIR)/:
	@echo -e "\n$(B)$(CYAN)Making build directory:$(R)"
	mkdir -pv $(BUILD_DIR)

$(BUILD_DIR)/asm/:
	@echo -e "$(B)$(CYAN)Making build directory for assembly files:$(R)"
	mkdir -pv $(BUILD_DIR)/asm

$(BUILD_DIR)/preprocessed/:
	@echo -e "$(B)$(CYAN)Making build directory for preprocessed files:$(R)"
	mkdir -pv $(BUILD_DIR)/preprocessed

# Install target
.PHONY: install
.NOTPARALLEL: install
install: clean
	@$(MAKE) target RELEASE=true
	@echo -e "\n$(B)$(CYAN)Installing $(TARGET) at $(INSTALL_DIR):$(R)"
	@cp -fv $(TARGET) $(INSTALL_DIR) || sudo mv -iv $(TARGET) $(INSTALL_DIR)

# Release target
.PHONY: release
release: clean
	@$(MAKE) target RELEASE=true

# Debug target
.PHONY: debug
debug: clean
	@$(MAKE) target RELEASE=false


# Uninstall target
.PHONY: uninstall
uninstall:
	@echo -e "$(B)$(CYAN)Uninstalling $(INSTALL_DIR)/$(TARGET)$(R)"
	@rm -rfv $(INSTALL_DIR)/$(TARGET) || sudo rm -rfv $(INSTALL_DIR)/$(TARGET)
	@echo -e "$(B)$(GREEN)DONE UNINSTALLING!$(R)"

# Clean Object files
.PHONY: clean
clean:
	@echo -e "\n$(B)$(CYAN)Removing object files:$(R)"
	@rm -fv $(OBJS)
	@sleep 0.1

# Clean out file and objects
.PHONY:cleanall
cleanall:
	@echo -e "$(B)$(CYAN)Removing executable:$(R)"
	rm -fv $(TARGET)
	@echo -e "$(B)$(CYAN)Removing build directory:$(R)"
	rm -rfv $(BUILD_DIR)

# Rebuild
.PHONY: rebuild
rebuild: clean init_rebuild target

.PHONY: init_rebuild
init_rebuild:
	$(eval NEEDEDOBJS = $(words $(OBJS)))
	$(eval REBUILD_OBJS = $(OBJS))

# help target
.PHONY: help
help:
	@echo -e "\n$(B)$(CYAN)Help for this Makefile:$(R)"
	@echo -e "Invoke $(BWHITE)\"make\"$(R)                      to build $(B)$(TARGET)$(R)"
	@echo -e "or     $(BWHITE)\"make [target] [option(s)]\"$(R) to specify a target and/or options."
	@echo -e
	@echo -e "The following are the valid $(BWHITE)targets$(R) for this Makefile:"
	@echo -e "... $(B)all$(R)             build the executable, assembly files and preprocessed files"
	@echo -e "... $(B)release$(R)         build the executable with optimizations for release"
	@echo -e "... $(B)debug$(R)           build the executable without optimizations"
	@echo -e "... $(B)target$(R)          build the executable"
	@echo -e "... $(B)rebuild$(R)         remake the executable from scratch"
	@echo -e "... $(B)install$(R)         make and move the executable to $(INSTALL_DIR)"
	@echo -e "... $(B)uninstall$(R)       removes the executable from $(INSTALL_DIR)"
	@echo -e "... $(B)help$(R)            prints this help message"
	@echo -e "... $(B)assemble$(R)        compiles the source files into assembly files in the build directory ($(BUILD_DIR))"
	@echo -e "... $(B)preprocess$(R)      compiles the source files into preprocessed files in the build directory ($(BUILD_DIR))"
	@echo -e "... $(B)clean$(R)           removes the build directory and its contents like object files"
	@echo -e "... $(B)cleanall$(R)        removes all of the above and also the executable inside this folder"
	@echo -e "\nalso the following are valid targets:"
#	@echo -e "... $(B)$(TARGET)$(R)\n\
	... $(B)$(foreach obj,$(OBJS),$(notdir $(obj)),)\n$(R)\
	... $(B)$(foreach doti,$(DOTI),$(notdir $(doti)),)\n$(R)\
	... $(B)$(foreach asm,$(ASMS),$(notdir $(asm)),)\n$(R)\
	\n"
	@echo -e "... $(B)$(TARGET)$(R)\n\
	... $(B)$(foreach obj,$(OBJS),$(obj),)\n$(R)\
	... $(B)$(foreach doti,$(DOTI),$(doti),)\n$(R)\
	... $(B)$(foreach asm,$(ASMS),$(asm),)\n$(R)\
	\n"
	@echo -e "The following are the valid $(BWHITE)options$(R) for this Makefile:"
	@echo -e "... $(B)RELEASE=$(R)        set to '$(BWHITE)true$(R)' for release build, false for debug build,\
	    default is $(BWHITE)$(RELEASE)"
	@echo -e "... $(B)BUILD_DIR=$(R)      directory, where intermediate files will be stored         default is $(BWHITE)$(BUILD_DIR)"
	@echo -e "... $(B)SRC_DIR=$(R)        directory, where make will look for source files           default is $(BWHITE)$(SRC_DIR)"
	@echo -e "... $(B)HDR_DIR=$(R)        directory, where make will look for header files           default is $(BWHITE)$(HDR_DIR)"
	@echo -e "... $(B)INSTALL_DIR=$(R)    directory, where the executable will be installed to       default is $(BWHITE)$(INSTALL_DIR)"
	@echo -e "... $(B)COMPILER=$(R)       compiler to use                                            default is $(BWHITE)$(COMPILER)"
	@echo -e "... $(B)COMPILER_FLAGS=$(R) compiler flags to use                                      default is $(BBLACK)empty"
	@echo -e "... $(B)STANDARD=$(R)       C++ standard to use                                        default is $(BWHITE)$(STANDARD)"
	@echo -e "... $(B)LINKER=$(R)         linker to use                                              default is $(BWHITE)$(LINKER)"
	@echo -e "... $(B)LINKER_FLAGS=$(R)   linker flags to use                                        default is $(BBLACK)empty"

# $(notdir $(BUILD_DIR)/preprocessed/%.i):
# 	@printf "$(B)"
# 	$(MAKE) $(BUILD_DIR)/preprocessed/$@ $(MAKEFLAGS)

# $(notdir $(BUILD_DIR)/%.o):
# 	@printf "$(B)"
# 	$(MAKE) $(BUILD_DIR)/$@ $(MAKEFLAGS)

# $(notdir $(BUILD_DIR)/asm/%.s):
# 	@printf "$(B)"
# 	$(MAKE) $(BUILD_DIR)/asm/$@ $(MAKEFLAGS)



DONEOBJS := 0
override TSOBJS     = $(foreach obj, $(OBJS), $(shell stat -c %Y $(obj) 2>/dev/null || echo -e 0))
override TSSRCS     = $(foreach src, $(SRCS), $(shell stat -c %Y $(src) 2>/dev/null || echo -e 0))
NEEDEDOBJS := $(shell \
	count=0; \
	i=0; \
	for src in $(SRCS); do \
		obj=$$(echo -e $(OBJS) | cut -d" " -f$$((i+1))); \
		ts_src=$$(stat -c %Y $$src 2>/dev/null || echo -e 0); \
		ts_obj=$$(stat -c %Y $$obj 2>/dev/null || echo -e 0); \
		if [ $$ts_src -gt $$ts_obj ]; then count=$$((count+1)); fi; \
		i=$$((i+1)); \
	done; \
	echo -e $$count \
)
REBUILD_OBJS := $(shell i=0; \
	for src in $(SRCS); do \
		obj=$$(echo -e $(OBJS) | cut -d" " -f$$((i+1))); \
		ts_src=$$(stat -c %Y $$src 2>/dev/null || echo -e 0); \
		ts_obj=$$(stat -c %Y $$obj 2>/dev/null || echo -e 0); \
		if [ $$ts_src -gt $$ts_obj ]; then echo -e $$obj; fi; \
		i=$$((i+1)); \
	done \
)

