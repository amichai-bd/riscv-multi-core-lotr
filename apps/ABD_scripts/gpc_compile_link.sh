# Compile C source
# GNU_DIR=/home/adlv/projects/riscv/install/rv32i/bin/
# GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/
#create assembly file from c file
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive.c.s 
#link new ams file with gpc initializer and creates elf file
$GNU_DIR/riscv32-unknown-elf-gcc -O3 -march=rv32i -mabi=ilp32 -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -fdata-sections -ffunction-sections -fdiagnostics-color=always  -T../scripts/gpc_link.common.ld -nostartfiles -Wl,--gc-sections -D__riscv__ alive.c.s ../scripts/crt0_gpc.S  -o alive.elf 
#creates readable elf file
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive.elf > alive_elf.txt 
#creates the instruction file 
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive.elf alive_inst_mem.sv 
