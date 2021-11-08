    #create assembly file from c file
    gcc -S -ffreestanding -march=rv32i abd_MultiCore.c -o abd_MultiCore_rv32i.c.s
     #link new ams file with gpc initializer and creates elf file
    echo "Gpc Linker with RV32i"
    gcc  -O3  -march=rv32i -T./gpc_link.common.ld -nostartfiles -D__riscv__ abd_MultiCore_rv32i.c.s ./crt0_gpc.S -o abd_MultiCore_rv32i.elf
    #creates readable elf file
    objdump -gd abd_MultiCore_rv32i.elf > abd_MultiCore_rv32i_elf_txt.txt
    #creates the instruction file 
    objcopy --srec-len 1 --output-target=verilog abd_MultiCore_rv32i.elf abd_MultiCore_inst_mem_rv32i.sv 
    if [ ! -d "../../../verif/Tests/abd_MultiCore" ];then
        mkdir ../../../verif/Tests/abd_MultiCore
    fi
    cp abd_MultiCore.c ../../../verif/Tests/abd_MultiCore
    mv abd_MultiCore_rv32i.c.s ../../../verif/Tests/abd_MultiCore
    mv abd_MultiCore_rv32i.elf ../../../verif/Tests/abd_MultiCore
    mv abd_MultiCore_rv32i_elf_txt.txt ../../../verif/Tests/abd_MultiCore
    if grep -q @00400800 "abd_MultiCore_inst_mem_rv32i.sv"; then
        c=`cat abd_MultiCore_inst_mem_rv32i.sv | wc -l`
        y=`cat abd_MultiCore_inst_mem_rv32i.sv | grep -n @00400800 | cut -d ':' -f 1 |tail -n 1`
        (( y-- ))
        cat abd_MultiCore_inst_mem_rv32i.sv | tail -n $(( c-y )) > abd_MultiCore_data_mem_rv32i.sv
        cat abd_MultiCore_inst_mem_rv32i.sv | head -n $(( y )) > abd_MultiCore_inst_mem_rv32i.sv
    else
        echo "@00400800" > abd_MultiCore_data_mem_rv32i.sv
    fi  
    mv abd_MultiCore_data_mem_rv32i.sv ../../../verif/Tests/abd_MultiCore
    mv abd_MultiCore_inst_mem_rv32i.sv ../../../verif/Tests/abd_MultiCore