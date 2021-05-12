
Compile & Link C file using toolchain : 
---------------------------------------
Type : ./gpc_compile_link.sh -flag program

flag :
1."-l" to compile & link the C using the gpc linker.
	create an S file only for c program, an elf file for the full linked program and sv file

2."-n" to compile the C file with default linker.
	create an S file only for c program, an elf file only for c program and sv file

3."-s" to compile a S file using the gpc linker.
	create an elf file for the full linked program and sv file

program :
The .c or .s file without extension

