# riscv-multi-core
An accelerator for multi-thread processing IP.  
Based on a Ring architecture for sharing memory between cores  

### The reposetory has 3 main projects:
- *GPC_4T: RISCV core RV32I/E.*  
4 thread core.
i_mem (Instruction Memory)
d_mem (Data Memory) - compiler Scratchpad + MMIO + MMIO CRs (Control Register)

- *RING Controller*  
Ring EP (EndPoint) to Mangae the core & ring RD/WR traffic.

- *Integration Model*  
Instantiating the Cores and Ring into a single IP design.

- *Software stack for multi-thread processing*  
Proof of concept for multi-thread applications for the multi-core design

# Pointers To Get Started
- RISCV Tool Chain: TODO  
- Core - RTL Design: TODO  
- Ring - RTL Deisgn: TODO  
- Validation - SW Stack: TODO  
- Proof Of Concept - SW Stack:TODO  

# 

