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
               (input  logic               clock      ,
                //core access
                input  logic [MSB_D_MEM-2:0] address_a  ,
                input  logic [3:0]         byteena_a  ,
                input  logic [31:0]        data_a     ,
                input  logic               rden_a     ,
                input  logic               wren_a     ,
                output logic [31:0]        q_a        ,
                //ring access
                input  logic [MSB_D_MEM-2:0] address_b  ,
                input  logic [3:0]         byteena_b  ,
                input  logic [31:0]        data_b     ,
                input  logic               rden_b     ,
                input  logic               wren_b     ,
                output logic [31:0]        q_b   
               );
logic [7:0]  mem     [SIZE_D_MEM-1:0];
logic [7:0]  next_mem[SIZE_D_MEM-1:0];
logic [31:0] pre_q_a;  
logic [31:0] pre_q_b;
logic [MSB_D_MEM:0] address_a_byte;
logic [MSB_D_MEM:0] address_b_byte;
assign  address_a_byte = {address_a,2'b00};
assign  address_b_byte = {address_b,2'b00}; 

//=======================================
//          Writing to memory
//=======================================
always_comb begin
    next_mem = mem;
    if(wren_a) begin
        if(byteena_a[0]) next_mem[address_a_byte+0]= data_a[7:0];
        if(byteena_a[1]) next_mem[address_a_byte+1]= data_a[15:8];
        if(byteena_a[2]) next_mem[address_a_byte+2]= data_a[23:16];
        if(byteena_a[3]) next_mem[address_a_byte+3]= data_a[31:24]; 
    end
    if(wren_b) begin
        if(byteena_b[0]) next_mem[address_b_byte+0]= data_b[7:0];
        if(byteena_b[1]) next_mem[address_b_byte+1]= data_b[15:8];
        if(byteena_b[2]) next_mem[address_b_byte+2]= data_b[23:16];
        if(byteena_b[3]) next_mem[address_b_byte+3]= data_b[31:24]; 
    end
end 

//=======================================
//          the memory Array
//=======================================
`LOTR_MSFF(mem, next_mem, clock)

//=======================================
//          reading the memory
//=======================================
assign pre_q_a = rden_a ? {mem[address_a_byte+3], mem[address_a_byte+2], mem[address_a_byte+1], mem[address_a_byte+0]} : '0;
assign pre_q_b = rden_b ? {mem[address_b_byte+3], mem[address_b_byte+2], mem[address_b_byte+1], mem[address_b_byte+0]} : '0;
// sample the read - synchorus read
`LOTR_MSFF(q_a, pre_q_a, clock)
`LOTR_MSFF(q_b, pre_q_b, clock)

endmodule
