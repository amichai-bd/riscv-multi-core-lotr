#####################################################
######Compile & Link C file using toolchain : #######
#####################################################
To compile and link a C program to support riscv32i :
1.Put your .c program in /apps/scripts/gpc_compile_link

2.Open Linux-Shell on path:  /apps/scripts/gpc_compile_link

3.Type on terminal : ./gpc_compile_link.sh [program]

[program] should be replaced with the .c  file without extension


**if recieving "syntax error: unexpected end of file" use the following command:
dos2unix gpc_compile_link.sh

***if dos2unix is missing please follow installation instractions on terminal.



###########################################
####riscv32e NOT SUPPORTED AT THIS TIME####
###########################################
To compile and link a C program to support riscv32e :
mod:
1."-i" to use riscv32i compiler

2."-e" to use riscv32e compiler

flag :
1."-l" to compile & link the C using the gpc linker.
	create an S file only for c program, an elf file for the full linked program and sv file

2."-n" to compile the C file with default linker.
	create an S file only for c program, an elf file only for c program and sv file

3."-s" to compile an S file using the gpc linker.
	create an elf file for the full linked program and sv file

program :
The .c or .s file without extension

###########################################
####riscv32e NOT SUPPORTED AT THIS TIME####
###########################################
