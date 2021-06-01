CC = riscv64-elf-gcc
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

PREFIX := $(CONFIG)/$(ARCH)/$(ABI)

BASE_CFLAGS := -Iinclude -ffreestanding -march=$(ARCH) -mabi=$(ABI) -nostdinc -nostartfiles -std=c11

ifeq ($(DEBUG_BUILD), 0)
    BASE_CFLAGS += -O3
else
    BASE_CFLAGS += -g -DDEBUG
endif

override CFLAGS := $(BASE_CFLAGS) $(CFLAGS)
override LDFLAGS := -Tbuild/gpc_link.common.lds -nostdlib -m elf32lriscv $(LDFLAGS)

all: out/$(PREFIX)/lib/libgpc.a out/$(PREFIX)/lib/libgpc_entry.o out/$(PREFIX)/bin/empty out/$(PREFIX)/bin/prime_factoring

obj/$(PREFIX)/entry_point.o: src/lib/entry_point.S
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/$(PREFIX)/gpc_utils.o: src/lib/gpc_utils.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/$(PREFIX)/gpc_core.o: src/lib/gpc_core.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/$(PREFIX)/helper.o: src/helper.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/$(PREFIX)/lib/libgpc_entry.o: obj/$(PREFIX)/entry_point.o
	@mkdir -p `dirname $@`
	#$(AR) -csr $@ $^
	cp -f $^ $@

out/$(PREFIX)/lib/libgpc.a: obj/$(PREFIX)/gpc_utils.o obj/$(PREFIX)/gpc_core.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^

obj/$(PREFIX)/empty.o: src/apps/empty.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/$(PREFIX)/prime_factoring.o: src/apps/prime_factoring.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/$(PREFIX)/bin/empty: out/$(PREFIX)/lib/libgpc_entry.o obj/$(PREFIX)/empty.o
	@mkdir -p `dirname $@`
	$(LD) $(LDFLAGS) -Lout/$(PREFIX)/lib $^ -lgpc -o $@
	$(OBJDUMP) -gd $@ > $@.txt

out/$(PREFIX)/bin/prime_factoring: out/$(PREFIX)/lib/libgpc_entry.o obj/$(PREFIX)/prime_factoring.o
	@mkdir -p `dirname $@`
	$(LD) $(LDFLAGS) -Lout/$(PREFIX)/lib $^ -lgpc -o $@
	$(OBJDUMP) -gd $@ > $@.txt

clean:
	rm -rf out/$(PREFIX)/* obj/$(PREFIX)/*

cleanall:
	rm -rf out/* obj/*
