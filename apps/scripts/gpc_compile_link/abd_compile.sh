#!/bin/bash 

shopt -s expand_aliases
source ~/.aliases

#create assembly file from c file
rv_gcc -S -ffreestanding -march=rv32i $1.c -o $1_rv32i.c.s
 #link new ams file with gpc initializer and creates elf file
echo "ABD Linker with RV32i"
rv_gcc  -O3  -march=rv32i -T./gpc_link.common.ld -nostartfiles -D__riscv__ $1_rv32i.c.s ./crt0_gpc.S -o $1_rv32i.elf
#creates readable elf file
rv_objdump -gd $1_rv32i.elf > $1_rv32i_elf_txt.txt
#creates the instruction file 
rv_objcopy --srec-len 1 --output-target=verilog $1_rv32i.elf $1_inst_mem_rv32i.sv 
if [ ! -d "../../../verif/Tests/$1" ];then
    mkdir ../../../verif/Tests/$1
fi
rm -rf ../../../verif/Tests/$1/*
cp $1.c ../../../verif/Tests/$1
mv $1_rv32i.c.s ../../../verif/Tests/$1
mv $1_rv32i.elf ../../../verif/Tests/$1
mv $1_rv32i_elf_txt.txt ../../../verif/Tests/$1
if grep -q @00400800 "$1_inst_mem_rv32i.sv"; then
    c=`cat $1_inst_mem_rv32i.sv | wc -l`
    y=`cat $1_inst_mem_rv32i.sv | grep -n @00400800 | cut -d ':' -f 1 |tail -n 1`
    (( y-- ))
    cat $1_inst_mem_rv32i.sv | tail -n $(( c-y )) > $1_data_mem_rv32i.sv
    cat $1_inst_mem_rv32i.sv | head -n $(( y )) > $1_inst_mem_rv32i.sv
else
    echo "@00400800" > $1_data_mem_rv32i.sv
fi  
mv $1_data_mem_rv32i.sv ../../../verif/Tests/$1
mv $1_inst_mem_rv32i.sv ../../../verif/Tests/$1

