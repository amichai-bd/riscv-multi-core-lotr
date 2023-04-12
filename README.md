[![LOTR](https://github.com/amichai-bd/riscv-multi-core-lotr/actions/workflows/main.yml/badge.svg)](https://github.com/amichai-bd/riscv-multi-core-lotr/actions/workflows/main.yml)  

# riscv-multi-core-lotr
Accelerator for multi-thread processing IP.     
LOTR:  Lord-Of-The-Ring  
Based on a Ring architecture to share all memory regions between threads, cores & other devices.  
![image](https://user-images.githubusercontent.com/81047407/183586818-3f5a700d-85d8-4f3c-91e2-4090b58ed9d7.png)

The Design is loaded to the DE10Lite FPGA.  
<img src="https://user-images.githubusercontent.com/81047407/178192726-6d1c9de1-9247-433f-bb86-c1d0235372d0.jpeg" width="300">  
  
Writing to FPGA IO - LED:  
<img src="https://user-images.githubusercontent.com/81047407/215293191-c94de6dd-c692-4a23-9371-06797f56941a.png" width="300"> 

Writing to Display - accessable with LOAD/STORE from any Thread.  
<img src="https://user-images.githubusercontent.com/81047407/178192931-b3714594-96ae-46d2-856a-4d72668a098f.jpeg" width="200">
<img src="https://user-images.githubusercontent.com/81047407/215293221-36c92fe4-b7eb-45d6-8a4d-3bcce21c3fe0.png" width="200">
<img src="https://user-images.githubusercontent.com/81047407/183402370-438cc503-4065-4fd7-b9e2-d2f81aa5d5fb.png" width="200">
<img src="https://user-images.githubusercontent.com/81047407/215293172-04321d70-7c37-490d-8168-ac708b69acf0.png" width="200">
<img src="https://user-images.githubusercontent.com/81047407/215293297-d192322d-9e78-4dc3-93b6-c4fabbd5003e.png" width="200">

*** 
## The reposetory has 4 main projects:  
### *1) GPC_4T - RISCV core RV32I/E. with 4 HW threads*  
<img src="https://user-images.githubusercontent.com/81047407/183592644-405f9afd-e804-4680-8908-1f82b70eb6db.png" width="500">

Written in System verilog.   
Main Blocks:  
1. Core - 4 HW thread. Compatible with RV32I/E.  
2. I_MEM (Instruction Memory). 4KB of SRAM memory with dual access (core & Fabric).  
3. D_MEM (Data Memory) - 4KB of SRAM memory with duel access (core & Fabric).      
Devided to: Compiler Scratchpad(.data.bss.rodata) + Shared MEM Space + CR Space (Control Registers)

### *2) RC - Ring Controller*  
<img src="https://user-images.githubusercontent.com/81047407/196517501-b4e99028-2fa7-4d6b-aeeb-f4c5391df47b.png" width="600">

Written  in SystemVerilog.  
Ring EP (EndPoint) to Manage the cores & ring RD/WR traffic.
Main logic:
1. A2F buffer (Agent2Fabric).
2. F2A buffer (Fabric2Agent).
3. Ring output Arbiter. (A2F,F2A,Ring input)

### *3) LOTR: Integration Model, Lord-Of-The-Ring*  
Written  in SystemVerilog.  
Instantiating the Cores and Ring into a single Fabric IP design.  
Main Blocks:  
1. GPC_4T core with its own "local" 4k memory - interface with the RC (ring controller).  
2. RC - Ring EndPoint to arbitrate requests - interface with the other RC and the core.  
The GPC&RC are always coupled and have a unique "ID".  
In the fabric, we can link many RC to each other.  
which will enable the Many-core Ring Fabric Design.  
  
### *4) Software stack for multi-thread processing*  
Written in C and compiled using the RISCV toolchain (rv32i/e).  
Proof of concept for multi-thread applications for the multi-core design.  
1. Design programs that can run on the 4 threaded core and share data between threads.  
2. Design programs that can be run on many cores, utilize the threads in each core, and share data between all cores.


***

# Pointers To Get Started

## Getting Started
To see your build and run options, run the following command:  
```python build.py -h ```  
example:  
```python build.py -dut 'lotr' -debug -tests 'wip' -app ```   
Will compile using gcc the program called 'wip', which then can be used to load the FPGA with the uart:   
``` cd source/uart_io/pyterminal/src ```   
Then:   
``` python uart_term.py < sequence_abd/load_wip.txt  ```   
will load the FGPA with the program 'wip' and run it.   
## Prerequisite
Before you start, make sure you have the following tools and software installed:
- [RISCV gcc releases](https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/releases/) & [install](https://xpack.github.io/riscv-none-embed-gcc/install/), a Windows gcc for RISCV ISA.  
- [Intel design SW for windows](https://www.intel.com/content/www/us/en/software-kit/660907/intel-quartus-prime-lite-edition-design-software-version-20-1-1-for-windows.html) , modelsim + quartus + MAX10 (de10-lite). used to compile, simulate & load to FPGA the HW systemverilog design.  
### Recommendations
To make your experience smoother, we recommend installing the following tools:
- [GitBash](https://gitforwindows.org/), a Windows version of Git that includes a "Unix-like" shell.  
- [Visual Studio Code](https://code.visualstudio.com/download), a code editor that supports many programming languages.  

- RISCV GCC for windows:
TODO - write a script to download and install the toolchain.

- Compilation and Simulation:  
Using Modelsim - https://fpgasoftware.intel.com/

### The HW & SW in the project:

- Core - GPC_4T - RTL Design:   
HAS (High-Level-Architecture-Specification):     
RISCV Spec - https://github.com/amichai-bd/riscv-multi-core-lotr/blob/master/doc/GPC_4T_doc/riscv-spec-20191213.pdf   
HW Spec - <TODO>  
MAS (Micro-Level-Architecture-Specification):  
see under documentation
<TODO>  

- Ring Controler - RC - RTL Design:     
HAS (High-Level-Architecture-Specification):        
see under documentation     
MAS (Micro-Level-Architecture-Specification):     
<TODO>     

- Fabric - LOTR - (Integration Model) - RTL Design:  
HAS (High-Level-Architecture-Specification):  
MAS (Micro-Level-Architecture-Specification):  
<TODO>  

- uart_io tile- RTL Design & python terminal for FPGA IO:  
HAS (High-Level-Architecture-Specification):  
MAS (Micro-Level-Architecture-Specification):  
<TODO>  
- SW Stack: 
  <TODO>  

- Validation:  
<TODO>  

 
