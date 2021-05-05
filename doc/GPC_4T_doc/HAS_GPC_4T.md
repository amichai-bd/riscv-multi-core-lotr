# Fantastic4 Complete Module Design - RV32I/E

Fantastic4 is a RISC-V based GPC_4t - General Purpose Compute Unit with 4 physical Threads

## HAS Design schematics
The Main units in the project - the _fantastic4 _Core and the memory that splits to instruction and data memory modules, as seen in a HAS schematic : 
![HAS](https://user-images.githubusercontent.com/81635109/115765612-aa7f3600-a3af-11eb-846c-f4e68b18ebc1.jpg)

---  

## The units
### Core:
Four threaded RISC-V32I based pipeline core.

### Instruction Memory:
instructions of the program in shape of 32 bit vector is passed to the core according to the address the core supplies.

### Data Memory:
Data to be read is passed from this module to the core and data to be written is passed from the core to this module.



