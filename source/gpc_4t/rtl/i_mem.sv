//-----------------------------------------------------------------------------
// Title            : core_rv32i 
// Project          : LOTR
//-----------------------------------------------------------------------------
// File             : i_mem.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2021
//-----------------------------------------------------------------------------
// Description :
// Behavioral duel read dueal write memory
//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------
`include "lotr_defines.sv"

module i_mem 
import lotr_pkg::*;
                (
                input  logic               clock  ,
                //core access
                input  logic [MSB_I_MEM:0] address,//curr_pc    ,
                input  logic [31:0]        data   ,//core_wr_data ,
                input  logic               rden   ,//core_rd_en   ,
                input  logic               wren   ,//core_wr_en ,
                output logic [31:0]        q       //instruction,
                );
logic [7:0]  mem     [SIZE_I_MEM-1:0];
logic [7:0]  next_mem[SIZE_I_MEM-1:0];
logic [31:0] pre_q;  

always_comb begin : write_to_memory
    next_mem = mem;
    if(wren) begin
        next_mem[address+0]= data[7:0];
        next_mem[address+1]= data[15:8];
        next_mem[address+2]= data[23:16];
        next_mem[address+3]= data[31:24]; 
    end
end 

// the memory flipflops
`LOTR_MSFF(mem, next_mem, clock)

assign pre_q = {mem[address+3],
                mem[address+2],
                mem[address+1],
                mem[address+0]};

`LOTR_MSFF(q, pre_q, clock)
endmodule
