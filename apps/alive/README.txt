// path to toolchain
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/

//====== -rv32e -ffreestanding, -nostartfiles ===============
GNU_DIR=/home/amichaibd/projects/riscv_e/install/rv32e/bin/
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32e -mabi=ilp32e -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32e.c.s
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic -march=rv32e -mabi=ilp32e -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32e.elf
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive_rv32e.elf > alive_rv32e_elf.txt
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive_rv32e.elf  alive_rv32e_inst_mem.sv 
