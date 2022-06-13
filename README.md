# riscv-multi-core-lotr
Accelerator for multi-thread processing IP.     
LOTR:  Lord-Of-The-Ring  
Based on a Ring architecture to share all memory regions between threads and cores.

![image](https://user-images.githubusercontent.com/81047407/173294229-dec18c7b-75c9-429f-b922-b4633fe54678.png)

*** 
## The reposetory has 4 main projects:
### *1) GPC_4T - RISCV core RV32I/E.*  
Written  in System verilog.  
Main Blocks:
1. Core - 4 HW thread. Compatible with RV32I/E.
2. I_MEM (Instruction Memory). 4KB of SRAM memory with dual access (core & Fabric).
3. D_MEM (Data Memory) - 4KB of SRAM memory with duel access (core & Fabric).    
Devided to: Cmpiler Scratchpad + Shared MEM Space + CR Space (Control Registers)

### *2) RC - Ring Controller*  
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
- WSL (Windows subsystem Linux):  
https://docs.microsoft.com/en-us/windows/wsl/install-win10  
Will allow you to install Linux on your Windows machine without Linux virtual machine.  
This will help to install the RISC-V toolchain.  
- RISCV Tool-Chain:  
https://github.com/riscv/riscv-gnu-toolchain.  
This will allow you to generate the machine code needed to load our instruction memory and simulate the RISCV multi-core design.  
C -> Compile -> Assembly -> linker -> assembler -> Machin-Code -> System Verilog readfile  

- Compilation and Simulation:  
Using Modelsim - https://fpgasoftware.intel.com/


- Core - GPC_4T - RTL Design:   
HAS (High-Level-Architecture-Specification):     
RISCV Spec - https://github.com/amichai-bd/riscv-multi-core-lotr/blob/master/doc/GPC_4T_doc/riscv-spec-20191213.pdf   
HW Spec - <TODO>  
MAS (Micro-Level-Architecture-Specification):  
<TODO>  

- Ring Controler - RC - RTL Deisgn:     
HAS (High-Level-Architecture-Specification):      
<TODO>  
MAS (Micro-Level-Architecture-Specification):  
<TODO>  

- Fabric - LOTR - (Integration Model) - RTL Deisgn:     
HAS (High-Level-Architecture-Specification):  
<TODO>  
MAS (Micro-Level-Architecture-Specification):  
<TODO>  

- SW Stack: 
  <TODO>  

- Validation:  
<TODO>  

 
