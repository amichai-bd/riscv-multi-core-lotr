# Compile C source
if [ "$1" == "-help" ];then
    cat ./README.txt
    exit 1
fi
str=riscv/install/rv32i/bin/
mod=i
if [ "$1" == "-e" ];then
    str=riscv_e/install/rv32e/bin/
    mod=e
fi

GNU_DIR=/home/adlv/projects/$str
#create assembly file from c file
if [ "$2" == "-l" ]||[ "$2" == "-n" ];then
    $GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -march=rv32$mod $3.c -o $3_rv32$mod.c.s;
fi
 #link new ams file with gpc initializer and creates elf file
if [ "$2" == "-l" ]||[ "$2" == "-s" ];then
    echo "Gpc Linker"
    $GNU_DIR/riscv32-unknown-elf-gcc  -O3  -march=rv32$mod -T./gpc_link.common.ld -nostartfiles -D__riscv__ $3_rv32$mod.c.s ./crt0_gpc.S -o $3_rv32$mod.elf
fi
if [ "$2" == "-n" ];then
    echo "Default linker, ingore message"
    $GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -march=rv32$mod -nostdlib $3.c -o $3_rv32$mod.elf
fi
#creates readable elf file
$GNU_DIR/riscv32-unknown-elf-objdump -gd $3_rv32$mod.elf > $3_rv32$mod_elf.txt
#creates the instruction file 
$GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $3_rv32$mod.elf $3_inst_mem_rv32$mod.sv 
