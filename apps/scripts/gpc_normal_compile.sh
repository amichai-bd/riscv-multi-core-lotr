# Compile C source
GNU_DIR=/home/adlv/projects/riscv/install/rv32i/bin/
#create assembly file from c file
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic\
 -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -Wl,--no-relax $1.c -o $1.c.s
 #link new ams file with gpc initializer and creates elf file
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic\
 -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -Wl,--no-relax\
 $1.c -o $1.elf
#creates readable elf file
$GNU_DIR/riscv32-unknown-elf-objdump -gd $1.elf > $1_elf.txt
#creates the instruction file 
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $1.elf $1_inst_mem.sv 
