CC = riscv64-elf-gcc
CPP = riscv64-elf-cpp
LD = riscv64-elf-ld
AR = riscv64-elf-ar
OBJDUMP = riscv64-elf-objdump

DEBUG_BUILD ?= 0

ifeq ($(DEBUG_BUILD), 0)
    CONFIG = release
else
    CONFIG = debug
endif

ARCH := rv32i
ABI := ilp32

ifeq ($(RV32E), 1)
    ARCH := $(ARCH:i=e)
    ABI := $(ABI)e
endif

PREFIX := $(CONFIG)/$(ARCH)/$(ABI)

BASE_CFLAGS := -Iinclude -ffreestanding -march=$(ARCH) -mabi=$(ABI) -nostdinc -nostartfiles -std=c11

ifeq ($(DEBUG_BUILD), 0)
    BASE_CFLAGS += -O3
else
    BASE_CFLAGS += -g -DDEBUG
endif

BASE_DEFINES :=

ifeq ($(RV32E), 1)
    LIB_DEFINES += -DUSE_RV32E=1
endif

override CFLAGS := $(BASE_CFLAGS) $(DEFINES) $(CFLAGS)
override LDFLAGS := -Tout/$(PREFIX)/lib/libgpc_link.lds -nostdlib -m elf32lriscv $(LDFLAGS)

LIB_INCLUDES := -Isrc/include

LIB_CFLAGS := $(CFLAGS) $(LIB_INCLUDES) $(LIB_DEFINES)

CPPFLAGS = -P

all: out/$(PREFIX)/lib/libgpc.a out/$(PREFIX)/lib/libgpc_entry.a out/$(PREFIX)/bin/empty out/$(PREFIX)/bin/prime_factoring out/$(PREFIX)/lib/libgpc_link.lds

libgpc: out/$(PREFIX)/lib/libgpc_link.lds out/$(PREFIX)/lib/libgpc.a out/$(PREFIX)/lib/libgpc_entry.a

out/$(PREFIX)/lib/libgpc_link.lds: build/gpc_link.common.lds
	mkdir -p `basename $@`
	$(CPP) $(CFLAGS) $(CPPFLAGS) $^ -o $@

obj/$(PREFIX)/entry_point.o: src/entry_point.S
	@mkdir -p `dirname $@`
	$(CC) $(LIB_CFLAGS) -c -o $@ $^

obj/$(PREFIX)/gpc_utils.o: src/gpc_utils.c
	@mkdir -p `dirname $@`
	$(CC) $(LIB_CFLAGS) -c -o $@ $^

obj/$(PREFIX)/gpc_core.o: src/gpc_core.c
	@mkdir -p `dirname $@`
	$(CC) $(LIB_CFLAGS) -c -o $@ $^

out/$(PREFIX)/lib/libgpc_entry.a: obj/$(PREFIX)/entry_point.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^
	cp -f $^ $@

out/$(PREFIX)/lib/libgpc.a: obj/$(PREFIX)/gpc_utils.o obj/$(PREFIX)/gpc_core.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^

obj/$(PREFIX)/empty.o: examples/empty.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/$(PREFIX)/prime_factoring.o: examples/prime_factoring.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/$(PREFIX)/bin/empty: out/$(PREFIX)/lib/libgpc_entry.a obj/$(PREFIX)/empty.o
	@mkdir -p `dirname $@`
	$(LD) $(LDFLAGS) -Lout/$(PREFIX)/lib $^ -lgpc -o $@
	$(OBJDUMP) -gd $@ > $@.txt

out/$(PREFIX)/bin/empty: .EXTRA_PREREQS = libgpc

out/$(PREFIX)/bin/prime_factoring: out/$(PREFIX)/lib/libgpc_entry.a obj/$(PREFIX)/prime_factoring.o
	@mkdir -p `dirname $@`
	$(LD) $(LDFLAGS) -Lout/$(PREFIX)/lib $^ -lgpc -o $@
	$(OBJDUMP) -gd $@ > $@.txt

out/$(PREFIX)/bin/prime_factoring: .EXTRA_PREREQS = libgpc

clean:
	rm -rf out/$(PREFIX)/* obj/$(PREFIX)/*

cleanall:
	rm -rf out/* obj/*
