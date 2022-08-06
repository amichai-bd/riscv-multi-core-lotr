# Compile C source
if [ "$#" != "3" ]&&[ "$#" != "1" ] && [ "$2" != "-abd" ];then
    echo "Not enought arguments, enter '-help' for help"
    exit 1
fi

if [ "$1" == "-help" ];then
    cat ./README.txt
    exit 1
fi

if [[ "$1" == *"."* ]];then
    echo "Please enter .c program without without extantion"
    exit 1
fi

temp=`find /home/ -name 'riscv32-unknown-elf-gcc'`
GNU_DIR_NAME=`echo $temp |cut -d/ -f 3`
str=riscv/install/rv32i/bin/
mod=i
if [ "$1" == "-e" ];then
    str=riscv_e/install/rv32e/bin/
    mod=e
fi

GNU_DIR=/home/${GNU_DIR_NAME}/projects/$str
if [ "$#" == "2" ]&&[ "$2" == "-abd" ];then
  GNU_DIR=/root/riscv_local_repo/install/rv32i/bin
fi

if [ "$#" != "3" ];then
    #create assembly file from c file
    $GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -march=rv32$mod $1.c -o $1_rv32$mod.c.s;
     #link new ams file with gpc initializer and creates elf file
    echo "Gpc Linker with RV32i"
    $GNU_DIR/riscv32-unknown-elf-gcc  -O3  -march=rv32$mod -T./gpc_link.common.ld -nostartfiles -D__riscv__ $1_rv32$mod.c.s ./crt0_gpc.S -o $1_rv32$mod.elf
    #creates readable elf file
    $GNU_DIR/riscv32-unknown-elf-objdump -gd $1_rv32$mod.elf > $1_rv32${mod}_elf_txt.txt
    #creates the instruction file 
    $GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $1_rv32$mod.elf $1_inst_mem_rv32$mod.sv 
    #creates the hex file for FPGA
    $GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=ihex $1_rv32$mod.elf $1_inst_mem_rv32$mod.hex 
    #create mif file from hex file
    srec_cat $1_inst_mem_rv32$mod.hex -Intel -o $1.mif -Memory_Initialization_File 32
    #transform mif to little Endian
    ./BEtoLE.sh $1


    if [ ! -d "../../../verif/Tests/$1" ];then
        mkdir ../../../verif/Tests/$1
    fi

    cp $1.c ../../../verif/Tests/$1
   
    mv $1_rv32$mod.c.s ../../../verif/Tests/$1
    
    mv $1_rv32$mod.elf ../../../verif/Tests/$1
    
    mv $1_rv32${mod}_elf_txt.txt ../../../verif/Tests/$1
    
    if grep -q @00400800 "$1_inst_mem_rv32$mod.sv"; then
        c=`cat $1_inst_mem_rv32$mod.sv | wc -l`
        y=`cat $1_inst_mem_rv32$mod.sv | grep -n @00400800 | cut -d ':' -f 1 |tail -n 1`
        (( y-- ))
        cat $1_inst_mem_rv32$mod.sv | tail -n $(( c-y )) > $1_data_mem_rv32$mod.sv
        cat $1_inst_mem_rv32$mod.sv | head -n $(( y )) > $1_instt_mem_rv32$mod.sv
    else
        echo "@00400800" > $1_data_mem_rv32$mod.sv
    fi  
    mv $1_data_mem_rv32$mod.sv ../../../verif/Tests/$1
    mv $1_inst_mem_rv32$mod.sv ../../../verif/Tests/$1
    # mv $1_instt_mem_rv32$mod.sv ../../../verif/Tests/$1
    mv $1_inst_mem_rv32$mod.hex ../../../FPGA/mem_bkp
    #mv $1.mif ../../../FPGA/mem_bkp
    
    exit 1
fi

## unused for now - compile with rv32e
###if [ "$#" == "3" ];then
###    #create assembly file from c file
###    if [ "$2" == "-l" ]||[ "$2" == "-n" ];then
###        $GNU_DIR/riscv32-unknown-elf-gcc -S -ffreestanding -march=rv32$mod $3.c -o $3_rv32$mod.c.s;
###    fi
###     #link new ams file with gpc initializer and creates elf file
###    if [ "$2" == "-l" ]||[ "$2" == "-s" ];then
###        echo "Gpc Linker with RV32"$mod
###        $GNU_DIR/riscv32-unknown-elf-gcc  -O3  -march=rv32$mod -T./gpc_link.common.ld -nostartfiles -D__riscv__ $3_rv32$mod.c.s ./crt0_gpc.S -o $3_rv32$mod.elf
###    fi
###    if [ "$2" == "-n" ];then
###        echo "Default linker, ingore message"
###        $GNU_DIR/riscv32-unknown-elf-gcc -ffreestanding -march=rv32$mod -nostdlib $3.c -o $3_rv32$mod.elf
###    fi
###    #creates readable elf file
###    $GNU_DIR/riscv32-unknown-elf-objdump -gd $3_rv32$mod.elf > $3_rv32$mod_elf.txt
###    #creates the instruction file 
###    $GNU_DIR/riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $3_rv32$mod.elf $3_inst_mem_rv32$mod.sv 
###
###    if [ ! -d "../tests_files/$3" ];then
###        mkdir ../tests_files/$3
###    fi
###    mv $3_rv32$mod.c.s ../tests_files/$3
###    mv $3_rv32$mod.elf ../tests_files/$3
###    mv $3_rv32$mod_elf.txt ../tests_files/$3
###    cp $3_inst_mem_rv32$mod.sv ../../verif/test_mem
###    mv $3_inst_mem_rv32$mod.sv ../tests_files/$3
###    exit 1
###fi



