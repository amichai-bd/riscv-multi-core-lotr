//-----------------------------------------------------------------------------
// Title            : data memory - Behavioral
// Project          : gpc_4t
//-----------------------------------------------------------------------------
// File             : d_mem.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2020
//-----------------------------------------------------------------------------
// Description :
// Behavioral duel read dueal write memory
//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------

`include "lotr_defines.sv"

//---------------------------------------------------
module d_mem 
import lotr_pkg::*; 
               (input  logic               clock    ,
                //core access
                input  logic [MSB_D_MEM:0] address  ,
                input  logic [3:0]         byteena  ,
                input  logic [31:0]        data     ,
                input  logic               rden     ,
                input  logic               wren     ,
                output logic [31:0]        q        
               );
logic [7:0]  mem     [SIZE_D_MEM-1:0];
logic [7:0]  next_mem[SIZE_D_MEM-1:0];
logic [31:0] pre_q;  

always_comb begin
    next_mem = mem;
    if(wren) begin
        if(byteena[0]) next_mem[address+0]= data[7:0];
        if(byteena[1]) next_mem[address+1]= data[15:8];
        if(byteena[2]) next_mem[address+2]= data[23:16];
        if(byteena[3]) next_mem[address+3]= data[31:24]; 
    end
end 

`LOTR_MSFF(mem, next_mem, clock)

assign pre_q = {mem[address+3],
                mem[address+2],
                mem[address+1],
                mem[address+0]};

`LOTR_MSFF(q, pre_q, clock)

endmodule
