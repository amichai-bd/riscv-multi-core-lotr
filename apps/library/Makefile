CC = riscv64-elf-gcc
LD = riscv64-elf-ld
AR = riscv64-elf-ar

override CFLAGS := -Iinclude/ -ffreestanding -march=rv32i -mabi=ilp32 -nostdinc -nostartfiles -std=c11 $(CFLAGS)
override LDFLAGS := -Tbuild/gpc_link.common.lds -nostdlib -m elf32lriscv $(LDFLAGS)

all: lib/libgpc.a lib/libgpc_entry.o bin/empty

obj/entry_point.o: src/lib/entry_point.S
	$(CC) $(CFLAGS) -c -o $@ $^

obj/gpc_utils.o: src/lib/gpc_utils.c
	$(CC) $(CFLAGS) -c -o $@ $^

obj/helper.o: src/helper.c
	$(CC) $(CFLAGS) -c -o $@ $^

lib/libgpc_entry.o: obj/entry_point.o
	#$(AR) -csr $@ $^
	cp -f $^ $@

lib/libgpc.a: obj/gpc_utils.o
	$(AR) -csr $@ $^

obj/empty.o: src/apps/empty.c
	$(CC) $(CFLAGS) -c -o $@ $^

bin/empty: lib/libgpc_entry.o obj/empty.o
	$(LD) $(LDFLAGS) -Llib $^ -lgpc -o $@

clean:
	rm -f bin/* lib/* obj/*
