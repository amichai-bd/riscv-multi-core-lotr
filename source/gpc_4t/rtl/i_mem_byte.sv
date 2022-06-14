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

module i_mem_byte 
import lotr_pkg::*;
                (
                input  logic               clock    ,
                //core access
                //input  logic [MSB_I_MEM-2:0] address_a,//curr_pc    ,
                input  logic [MSB_I_MEM:0] address_a,//curr_pc    ,
                input  logic [7:0]        data_a   ,//core_wr_data ,
                input  logic               rden_a   ,//core_rd_en   ,
                input  logic               wren_a   ,//core_wr_en ,
                output logic [7:0]        q_a      ,//instruction,
                // ring access
                //input  logic [MSB_I_MEM-2:0] address_b,//curr_pc    ,
                input  logic [MSB_I_MEM:0] address_b,//curr_pc    ,
                input  logic [7:0]        data_b   ,//core_wr_data ,
                input  logic               rden_b   ,//core_rd_en   ,
                input  logic               wren_b   ,//core_wr_en ,
                output logic [7:0]        q_b       //instruction,
                );
logic [7:0]  mem     [SIZE_I_MEM-1:0];
logic [7:0]  next_mem[SIZE_I_MEM-1:0];
logic [MSB_D_MEM:0] address_a_byte;
logic [MSB_D_MEM:0] address_b_byte;
//assign  address_a_byte = {address_a,2'b00};
//assign  address_b_byte = {address_b,2'b00}; 
assign  address_a_byte = address_a;
assign  address_b_byte = address_b; 
logic [7:0] pre_q_a;  
logic [7:0] pre_q_b;  

always_comb begin : write_to_memory
    next_mem = mem;
    if(wren_a) begin
        next_mem[address_a_byte]= data_a;
    end
    if(wren_b) begin
        next_mem[address_b_byte]= data_b;
    end
end 

// the memory flipflops
`LOTR_MSFF(mem, next_mem, clock)

assign pre_q_a = rden_a ? mem[address_a_byte] : '0;
assign pre_q_b = rden_b ? mem[address_b_byte] : '0;

`LOTR_MSFF(q_a, pre_q_a, clock)
`LOTR_MSFF(q_b, pre_q_b, clock)
endmodule
