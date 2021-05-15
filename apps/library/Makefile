CC = riscv64-elf-gcc
LD = riscv64-elf-ld
AR = riscv64-elf-ar

CFLAGS += -Iinclude/ -ffreestanding -march=rv32i -mabi=ilp32 -nostdinc -nostartfiles -D__riscv__
LDFLAGS += -Tbuild/gpc_link.common.ld -nostdlib -m elf32lriscv

all: bin/liblotr.a

obj/crt0_gpc.o: crt0_gpc.S
	$(CC) $(CFLAGS) -c -o $@ $^

bin/liblotr.a: obj/crt0_gpc.o
	$(AR) -csr $@ $^

clean:
	rm -f bin/* obj/*
