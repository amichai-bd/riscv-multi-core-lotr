# Compile C source
if [ "$1" == "-help" ];then
    cat ./README.txt
    exit 1
fi
GNU_DIR=/home/adlv/projects/riscv/install/rv32i/bin/
#create assembly file from c file
if [ "$1" == "-l" ]||[ "$1" == "-n" ];then
    $GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -march=rv32i $2.c -o $2.c.s;
fi
 #link new ams file with gpc initializer and creates elf file
if [ "$1" == "-l" ]||[ "$1" == "-s" ];then
    echo "Gpc Linker"
    $GNU_DIR/riscv32-unknown-elf-gcc  -O3  -march=rv32i -T./gpc_link.common.ld -nostartfiles -D__riscv__ $2.c.s ./crt0_gpc.S -o $2.elf
fi
if [ "$1" == "-n" ];then
    echo "Default linker, ingore message"
    $GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -march=rv32i -nostdlib $2.c -o $2.elf
fi
#creates readable elf file
$GNU_DIR/riscv32-unknown-elf-objdump -gd $2.elf > $2_elf.txt
#creates the instruction file 
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $2.elf $2_inst_mem.sv 
