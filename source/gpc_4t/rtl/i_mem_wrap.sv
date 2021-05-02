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
//  MMIO_drct_out
//  MMIO_ER      
//  MMIO_drct_in 
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
logic sample_range_rden_b;
logic range_rden_b;
`ifdef ALTERA
altera_sram_512x32_take3
altera_sram_512x32_inst_mem (
	.clock    (clock),
	.address  (address[10:2]),
	.data     (data),
	.rden     (rden)
	.wren     (wren)
	.q        (q)  
	);                  
`else                   
i_mem i_mem(      
    .clock    (clock),
    .address  (address),
    .data     (data),
    .rden     (rden),
    .wren     (wren),
    .q        (q)
    );
`endif
`LOTR_MSFF(sample_range_rden_b, range_rden_b, clock)
                        
endmodule               

