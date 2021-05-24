CC = riscv64-elf-gcc
LD = riscv64-elf-ld
AR = riscv64-elf-ar

override CFLAGS := -Iinclude/ -ffreestanding -march=rv32i -mabi=ilp32 -nostdinc -nostartfiles -std=c11 $(CFLAGS)
override LDFLAGS := -Tbuild/gpc_link.common.lds -nostdlib -m elf32lriscv $(LDFLAGS)

all: bin/empty

obj/entry_point.o: src/lib/entry_point.S
	$(CC) $(CFLAGS) -c -o $@ $^

obj/helper.o: src/helper.c
	$(CC) $(CFLAGS) -c -o $@ $^

lib/liblotr.a: obj/entry_point.o
	$(AR) -csr $@ $^
	cp -f $^ $@

obj/empty.o: src/apps/empty.c
	$(CC) $(CFLAGS) -c -o $@ $^

bin/empty: lib/liblotr.a obj/empty.o
	$(LD) $(LDFLAGS) $^ -o $@

clean:
	rm -f bin/* lib/* obj/*
