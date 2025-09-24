# Makefile for Flex lexer project with build directory

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g
FLEX = flex
LEX_FILE = c_lexer.l
BUILD_DIR = build
OUT = $(BUILD_DIR)/lexer.out
LEX_C = $(BUILD_DIR)/lex.yy.c

# Default target
all: $(OUT)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Generate lex.yy.c inside build dir
$(LEX_C): $(LEX_FILE) | $(BUILD_DIR)
	$(FLEX) -o$(LEX_C) $(LEX_FILE)

# Compile lex.yy.c into executable
$(OUT): $(LEX_C)
	$(CC) $(CFLAGS) $(LEX_C) -lfl -o $(OUT)

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)
