CC = riscv64-elf-gcc
LD = riscv64-elf-ld
AR = riscv64-elf-ar

CFLAGS += -Iinclude/ -ffreestanding -march=rv32i -mabi=ilp32 -nostdinc -nostartfiles -std=c11
LDFLAGS += -Tbuild/gpc_link.common.lds -nostdlib -m elf32lriscv
#LDFLAGS += -nostdlib -m elf32lriscv

all: lib/liblotr.o bin/test

obj/crt0_gpc.o: src/crt0_gpc.S
	$(CC) $(CFLAGS) -c -o $@ $^

obj/helper.o: src/helper.c
	$(CC) $(CFLAGS) -c -o $@ $^

lib/liblotr.o: obj/crt0_gpc.o
	#$(AR) -csr $@ $^
	cp -f $^ $@

obj/test.o: src/test.c
	$(CC) $(CFLAGS) -c -o $@ $^

bin/test: lib/liblotr.o obj/test.o
	$(LD) $(LDFLAGS) $^ -o $@

clean:
	rm -f bin/* lib/* obj/*
