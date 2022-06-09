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
                input  logic               clock    ,
                //core access
                input  logic [MSB_I_MEM-2:0] address_a,//curr_pc    ,
                input  logic [31:0]        data_a   ,//core_wr_data ,
                input  logic               rden_a   ,//core_rd_en   ,
                input  logic               wren_a   ,//core_wr_en ,
                output logic [31:0]        q_a      ,//instruction,
                // ring access
                input  logic [MSB_I_MEM-2:0] address_b,//curr_pc    ,
                input  logic [31:0]        data_b   ,//core_wr_data ,
                input  logic               rden_b   ,//core_rd_en   ,
                input  logic               wren_b   ,//core_wr_en ,
                output logic [31:0]        q_b       //instruction,
                );
logic [7:0]  mem     [SIZE_I_MEM-1:0];
logic [7:0]  next_mem[SIZE_I_MEM-1:0];
logic [MSB_D_MEM:0] address_a_byte;
logic [MSB_D_MEM:0] address_b_byte;
assign  address_a_byte = {address_a,2'b00};
assign  address_b_byte = {address_b,2'b00}; 
logic [31:0] pre_q_a;  
logic [31:0] pre_q_b;  

always_comb begin : write_to_memory
    next_mem = mem;
    if(wren_a) begin
        next_mem[address_a_byte+0]= data_a[7:0];
        next_mem[address_a_byte+1]= data_a[15:8];
        next_mem[address_a_byte+2]= data_a[23:16];
        next_mem[address_a_byte+3]= data_a[31:24]; 
    end
    if(wren_b) begin
        next_mem[address_b_byte+0]= data_b[7:0];
        next_mem[address_b_byte+1]= data_b[15:8];
        next_mem[address_b_byte+2]= data_b[23:16];
        next_mem[address_b_byte+3]= data_b[31:24]; 
    end
end 

// the memory flipflops
`LOTR_MSFF(mem, next_mem, clock)

assign pre_q_a = rden_a ? {mem[address_a_byte+3], mem[address_a_byte+2], mem[address_a_byte+1], mem[address_a_byte+0]} : '0;
assign pre_q_b = rden_b ? {mem[address_b_byte+3], mem[address_b_byte+2], mem[address_b_byte+1], mem[address_b_byte+0]} : '0;

`LOTR_MSFF(q_a, pre_q_a, clock)
`LOTR_MSFF(q_b, pre_q_b, clock)
endmodule
