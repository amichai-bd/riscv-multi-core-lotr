# riscv-multi-core
An accelerator for multi-thread processing IP.
Based on a Ring architecture for sharing memory between cores

The reposetory has 3 main projects:
- *RISCV core RV32I/E.*  
4 thread core.
i_mem (Instruction Memory)
d_mem (Data Memory) - compiler Scratchpad + MMIO + MMIO CRs (Control Register)

- *RING Controller*  
Ring EP (EndPoint) to Mangae the core & ring RD/WR traffic.

- *Software stack for multi-thread processing*  
Proof of concept for multi-thread applications for the multi-core design
