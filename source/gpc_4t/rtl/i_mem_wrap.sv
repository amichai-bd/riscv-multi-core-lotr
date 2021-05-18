//-----------------------------------------------------------------------------
// Title            : instruction memory wrap
// Project          : LOTR
//-----------------------------------------------------------------------------
// File             : i_mem_wrap.sv
// Original Author  : Amichai Ben-David
// Created          : 1/2020
//-----------------------------------------------------------------------------
// Description :
// will `ifdef the SRAM memory vs behavrial memory
//------------------------------------------------------------------------------
// Modification history :
//------------------------------------------------------------------------------
`include "lotr_defines.sv"
//---------------------MEMORY------------------------
//                start   size    end     # of words
//  i memory  
//  Data memory  
//  Stack        
//  MMIO_general 
//  MMIO_CSR     
//---------------------------------------------------
module i_mem_wrap import gpc_4t_pkg::*;
                (
                input  logic        clock  ,
                input  logic        rst    ,
                input  logic [31:0] address,//curr_pc    ,
                input  logic [31:0] data   ,//core_wr_data ,
                input  logic        rden   ,//core_rd_en   ,
                input  logic        wren   ,//core_wr_en ,
                output logic [31:0] q       //instruction,
                );

i_mem i_mem(      
    .clock    (clock),
    .address  (address[MSB_D_MEM:LSB_I_MEM]),
    .data     (data),
    .rden     (rden),
    .wren     (wren),
    .q        (q)
    );

endmodule               

