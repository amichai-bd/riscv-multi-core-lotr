# Compile C source
if [ "$#" != "3" ]&&[ "$#" != "1" ];then
    echo "Not enought arguments, enter '-help' for help"
    exit 1
fi

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
if [ "$#" == "3" ];then
    #create assembly file from c file
    if [ "$2" == "-l" ]||[ "$2" == "-n" ];then
        $GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -march=rv32$mod $3.c -o $3_rv32$mod.c.s;
    fi
     #link new ams file with gpc initializer and creates elf file
    if [ "$2" == "-l" ]||[ "$2" == "-s" ];then
        echo "Gpc Linker with RV32"$mod
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

    if [ ! -d "../alive/$3" ];then
        mkdir ../alive/$3
    fi
    mv $3_rv32$mod.c.s ../alive/$3
    mv $3_rv32$mod.elf ../alive/$3
    mv $3_rv32$mod_elf.txt ../alive/$3
    cp $3_inst_mem_rv32$mod.sv ../alive
    mv $3_inst_mem_rv32$mod.sv ../alive/$3
    exit 1
fi
if [ "$#" == "1" ];then
    #create assembly file from c file
    $GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -march=rv32$mod $1.c -o $1_rv32$mod.c.s;
     #link new ams file with gpc initializer and creates elf file
    echo "Gpc Linker with RV32i"
    $GNU_DIR/riscv32-unknown-elf-gcc  -O3  -march=rv32$mod -T./gpc_link.common.ld -nostartfiles -D__riscv__ $1_rv32$mod.c.s ./crt0_gpc.S -o $1_rv32$mod.elf
    #creates readable elf file
    $GNU_DIR/riscv32-unknown-elf-objdump -gd $1_rv32$mod.elf > $1_rv32$mod_elf.txt
    #creates the instruction file 
    $GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $1_rv32$mod.elf $1_inst_mem_rv32$mod.sv 

    if [ ! -d "../alive/$1" ];then
        mkdir ../alive/$1
    fi
    mv $1_rv32$mod.c.s ../alive/$1
    mv $1_rv32$mod.elf ../alive/$1
    mv $1_rv32$mod_elf.txt ../alive/$1
    cp $1_inst_mem_rv32$mod.sv ../alive
    mv $1_inst_mem_rv32$mod.sv ../alive/$1
    exit 1
fi



