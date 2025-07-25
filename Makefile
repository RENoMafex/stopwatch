# Compiler and Flags
CXX ?= g++
CXXFLAGS = $(WARNINGS) -std=c++17 -O0 -I../../headers_includes/shortint
WARNINGS = -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion -Wformat=2
LDFLAGS =

# Directories
SRC_DIR = src
HDR_DIR = src
BUILD_DIR = build

# Define pseudotargets
.PHONY: all install clean cleanall

# Source, Header and Object files
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
HDRS = $(wildcard $(HDR_DIR)/*.hpp) $(wildcard $(HDR_DIR)/*.h)
OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))

# Output
TARGET = stopwatch
INSTALLDIR = ~/bin/

# Defaulttarget
all: $(TARGET)

# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(HDRS) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Link
$(TARGET): $(OBJS)
	$(CXX) $^ -o $@ $(LDFLAGS)

# Make the build directory if needed
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Install target
install: $(TARGET)
	@sudo mv $(TARGET) $(INSTALLDIR)


# Clean Object files
clean:
	@rm -rfv $(BUILD_DIR)

# Clean out file and objects
cleanall: clean
	@rm -rfv $(TARGET)
