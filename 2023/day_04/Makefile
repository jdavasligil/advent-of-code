# Name of output binary executable
BINARY=bin

# List of code (.c) directories (sep=space)
CODEDIRS=src

# List of include (.h) directories (sep=space)
INCDIRS=./src

# Location to store binary
BUILD=build

# Compiler (gcc/clang)
CC=gcc

# Optimization flags (https://gcc.gnu.org/onlinedocs/gcc-3.4.6/gcc/Optimize-Options.html)
OPT=-O0

# Encode make rules for .h dependencies
DEPFLAGS=-MP -MD

# Extra flags (https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html)
CFLAGS=-Wall -Wextra -g $(foreach D,$(INCDIRS),-I$(D)) $(OPT) $(DEPFLAGS)

# List all .c files using regex (wildcard) pattern matching.
CFILES=$(foreach D,$(CODEDIRS),$(wildcard $(D)/*.c))

OBJECTS=$(patsubst %.c,%.o,$(CFILES))
DEPFILES=$(patsubst %.c,%.d,$(CFILES))

all: $(BUILD)/$(BINARY)

run: $(BUILD)/$(BINARY)
	./$^

debug: $(BUILD)/$(BINARY)
	gdb ./$^

$(BUILD)/$(BINARY): $(OBJECTS)
	$(CC) -o $@ $^

%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean: 
	rm -rf $(BINARY) $(OBJECTS) $(DEPFILES)

pack: clean
	tar zcvf pkg.tgz *

diff:
	$(info Repository status and volume of per-file changes:)
	@git status
	@git --no-pager diff --stat
