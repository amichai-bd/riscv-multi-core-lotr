// path to toolchain
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/

//====== -ffreestanding, -nostdlib =============== 
// --- This will fail due to no lib for mul or div ---
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive.c.s
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive.elf
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive.elf > alive_elf.txt
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive.elf alive_inst_mem.sv 

//====== -rv32i -ffreestanding, -nostartfiles ===============
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32i.c.s
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32i.elf
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive_rv32i.elf > alive_rv32i_elf.txt
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive_rv32i.elf alive_rv32i_inst_mem.sv

//====== -rv32e -ffreestanding, -nostartfiles ===============
GNU_DIR=/home/amichaibd/projects/riscv_e/install/rv32e/bin/
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32e -mabi=ilp32e -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32e.c.s
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic -march=rv32e -mabi=ilp32e -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32e.elf
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive_rv32e.elf > alive_rv32e_elf.txt
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive_rv32e.elf  alive_rv32e_inst_mem.sv 

//====== -rv32im -ffreestanding, -nostartfiles ===============
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32im -mabi=ilp32 -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32im.c.s
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic -march=rv32im -mabi=ilp32 -nostartfiles -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive_rv32im.elf
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive_rv32im.elf > alive_rv32im_elf.txt
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive_rv32im.elf alive_rv32im_inst_mem.sv 

//====== -ffreestanding, ===============
GNU_DIR=/home/amichaibd/projects/riscv/install/rv32i/bin/
$GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive.c.s
$GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -fno-pic -march=rv32i -mabi=ilp32 -Wl,-Ttext=0x0 -Wl,--no-relax alive.c -o alive.elf
$GNU_DIR/riscv32-unknown-elf-objdump -gd alive.elf > alive_elf.txt
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog alive.elf alive_inst_mem.sv 

