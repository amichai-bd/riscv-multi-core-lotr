# Fantastic4 Core Design - RV32I/E  
Fantastic4 is a RISC-V based GPC_4t - General Purpose Compute Unit with 4 physical Threads

## Fantastic4 General Description
Our _Fantastic 4_ Project, named after Marvel Comics superhero team, is an implementation of a RISC-V 32I/E  base integer **Core** .
In this design, there will be a single core with 4 main threads(Thus the name "Fantastic 4 Threads")
The goal of this project is to study the RISC-V instruction set and then to design and implement a minimal RV32I/E Core that supports all the instructions.
Additional features will be added if time permits. The design will be synthesized, and the design implemented on an FPGA.


## RISC-V Background
RISC-V is an open-source base-integer instruction set architecture (ISA) based on established reduced instruction set computer (RISC) principles. It is a classic RISC architecture rebuilt for modern times. At its heart is an array of 32 registers containing the processor's running state, the data is immediately operated on, and housekeeping information.  RISC-V comes in 32-bit and 64-bit variants, with register size changing to match.
The project began in 2010 at the University of California, Berkeley along with many volunteer contributors not affiliated with the university. It was originally designed to support computer architecture research and education but eventually in nowadays used for industry and many other uses.


## MAS Design schematics
### General:

This schematics (not final) are the MAS CORE design of the **_Fantastic4_** pipeline Core. More information plus zoom-in on each stage in the next section.

<img src="https://user-images.githubusercontent.com/81635109/115972099-21096880-a555-11eb-9bff-8ff7f432a121.jpg" width="2000" height="400">
---  

## Core Pipe-Stage
### Q100H:
First pipe stage. Represent the RISC-V "_**FETCH**_" stage. In this stage , 4 D-ff based counters , also known as Program Counters, are command line counters that determine which line number of the program will be the one that will execute. Each thread Pc at its turn passes to the memory - AKA Instruction Memory, the address of the command it wants to execute. The I-MEM then "fetch" the instruction in the designated address, as a 32-bit vector and pass it to the next pipe stage
![q100](https://user-images.githubusercontent.com/81635109/115973404-57e37c80-a55d-11eb-9f34-f3d279985577.jpg)

### Q101H:
Second pipe stage . Represent the RISC-V "_**DECODE**_" stage. In this stage , the 32-bit instruction vector is broke down of all the information it contains such as register numbers, immediate , the code that indicate the operation to perform(Opcode) etc...
This stage also includes the register file, or to be more accurate - 4 register files, one for each thread and each contains 16 32-bit registers.
The control signals also wakes up according to the instruction and some of the control signals moves to next pipe stages in order to "tell" the other components what to do.
The chosen registers data passed to the next stage along with other information such as immediates, the program counter and other 
![q101](https://user-images.githubusercontent.com/81635109/115973406-587c1300-a55d-11eb-8cda-c6348e5092cd.jpg)


### Q102H:
Third pipe stage . Represent the RISC-V "_**EXECUTE**_" stage. The main unit in this stage is the ALU, which perform  the arithmetic operation between two arguments that passed to it. The ALU also performs as a "Branch Comparator" that determine if the branch condition is true or false.
Another important feature is the "Next Pc Calculator". In a single thread pipe , if a branch condition is true (determine in third stage), then the core need to "flush" the pipe - clean the commands in the earlier stages or to insert NOP right after it fetches a branch instruction. In "Fantastic4" between each thread command entered 3 other commands from three other thread thus no flush is needed and we can determine on Q102H weather we need to Jump or not. The unit then passes the current thread's PC that runs at Q102H ,the next command on the program. Control signals passes to the next stage along with the ALU result.
 ![q102](https://user-images.githubusercontent.com/81635109/115973407-587c1300-a55d-11eb-8ad1-d12eef3b14e6.jpg)


### Q103H:
Fourth pipe stage . Represent the RISC-V "_**Memory R/W**_" stage. In this stage , data is read or written to the Data Memory if necessary. If data is read, the data passes on to the last stage 
![q103](https://user-images.githubusercontent.com/81635109/115973402-56b24f80-a55d-11eb-9800-86819898a730.jpg)

### Q104H:
The last and some say "smallest" stage. Represent the RISC-V "_**WRITE BACK**_" stage.  In this stage , data , that can be Alu result, data from memory or the next program line number, is written directly to the register at a designated address/register number that decoded from instruction on stage Q101 and "piped" all the way to this stage .


![q1044](https://user-images.githubusercontent.com/81635109/115973673-87938400-a55f-11eb-8bd8-a25b3bff873a.jpg)


## Supported Instructions
> ABD - add a short explanation on the different RISCV variation (m/a/d)

### R-Type

| funct7 [31:25] |  rs2 [24:20] |  rs1[19:15] |  funct3[14:12] |  rd[11:7] |  opcode [6:0] |
| :-----: | :-: | :-: | :-: | :-: | :-: |

| instruction Name |  Description |
| :-----: | :-: |
| ADD | performs addition of rs1 and rs2 |
| SUB |  performs the subtraction of rs2 from rs1 |
| SSL | perform logical left shift on the value in rs1 by the amount held in the lower 5 bits of rs2.|
| SRL | perform logical right shift on the value in rs1 by the amount held in the lower 5 bits of rs2.|
| SRA | perform arithmetic right shift on the value in rs1 by the amount held in the lower 5 bits of rs2.|
| SLT | signed compares respectively, writing 1 to rd if rs1 < rs2, 0 otherwise |
| SLTU | unsigned compares respectively, writing 1 to rd if rs1 < rs2, 0 otherwise |
| XOR |  perform bitwise "Xor" operation|
| OR |  perform bitwise "Or" operation|
| AND |  perform bitwise "And" operation|


### I-Type

| imm[31:20] |  rs1[19:15] |  funct3[14:12] |  rd[11:7] |  opcode [6:0] |
| :----------------: | :-: | :-: | :-: | :-: |

| instruction Name |  Description |
| :-----: | :-: |
| ADDI | performs addition of rs1 and immediate |
| SLTI | places the value 1 in register rd if register rs1 is less than the immediate |
| SLTIU | places the value 1 in register rd if register rs1 is less than the unsigned immediate |
| XORI | perform bitwise "Xor" operation of rs1 and immediate|
| ORI | perform bitwise "Or" operation of rs1 and immediate|
| ADNI | perform bitwise "And" operation of rs1 and immediate |
| JALR | jumps to the address stored in rs1 and store the address of the instruction following the jump in rd |
| LB | loads a 8-bit value from memory into rd|
| LH | loads a 16-bit value from memory into rd |
| LW | loads a 32-bit value from memory into rd |
| LBU | loads a 8-bit value from memory but then zero extends to 32-bits before storing in rd |
| LHU | loads a 16-bit value from memory but then zero extends to 32-bits before storing in rd |

### S-Type

| imm[31:25] |   rs2[24:20] | rs1[19:15] |  funct3[14:12] |  imm[11:7] |  opcode [6:0] |
| :------: | :-: | :-: | :-: | :-: | :-: |

| instruction Name |  Description |
| :-----: | :-: |
| SB | store 32-bit values from the low bits of register rs2 to memory |
| SH | store 16-bit values from the low bits of register rs2 to memory |
| SW | store 32-bit values from the low bits of register rs2 to memory |


### B-Type

| imm[31:25] |   rs2[24:20] | rs1[19:15] |  funct3[14:12] |  imm[11:7] |  opcode [6:0] |
| :------: | :-: | :-: | :-: | :-: | :-: |

| instruction Name |  Description |
| :-----: | :-: |
| BEQ | compare two registers. take the branch if registers rs1 and rs2are equal |
| BNE | compare two registers. take the branch if registers rs1 and rs2are unequal |
| BLT | compare two registers. take the branch  if rs1 is less than rs2 (signed comparison) |
| BGE | compare two registers. take the branch  if rs1 is greater than or equal to rs2 (signed comparison) |
| BLTU | compare two registers. take the branch  if rs1 is less than rs2 (unsigned comparison) |
| BGEU | compare two registers. take the branch  if rs1 is greater than or equal to rs2 (unsigned comparison) |


### U-Type

| imm[31:12]             |  rd[11:7] |  opcode [6:0] |
| :--------------------: | :-: | :-: |

| instruction Name |  Description |
| :-----: | :-: |
| LUI | places the U-immediate value in the top 20 bits of the destination register rd, filling in the lowest 12 bits with zeros|
| AUIPC | is used to build pc-relative addresses. forms a 32-bit offset from the 20-bit U-immediate, filling in the lowest 12 bits with zeros, adds this offset to the address of the AUIPC instruction, then places the result in register rd|


### J-Type

| imm[31:12]             |  rd[11:7] |  opcode [6:0] |
| :--------------------: | :-: | :-: |

| instruction Name |  Description |
| :-----: | :-: |
| JAL | jumps to the immediate address and stores the address of the instruction following the jump (pc+4) into register rd |



