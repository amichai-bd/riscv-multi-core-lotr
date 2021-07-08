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
module i_mem_wrap 
import lotr_pkg::*;
                (
                input  logic        QClk  ,
                input  logic        RstQnnnH    ,
                //============================================
                //      core interface
                //============================================
                input  logic [31:0] PcQ100H,        //curr_pc    ,
                input  logic        RdEnableQ100H,  //core_rd_en   ,
                output logic [31:0] InstFetchQ101H, //instruction,
                //============================================
                //      RC interface
                //============================================
                input  logic [31:0] F2C_ReqAddressQ503H,    // input   address input  should mux CORE vs MMIO
                input  logic [31:0] F2C_ReqDataQ503H,       // input   wr_data only the MMIO inerface can write to the i_mem
                input  logic        F2C_RdEnQ503H,          // input   rden    only the MMIO inerface can write to the i_mem
                input  logic        F2C_WrEnQ503H,          // input   wren    when writing to i_mem rden should be desabled 
                output logic [31:0] F2C_I_MemRspDataQ504H   // output  data    output should rename to general i_mem output data
                );

i_mem i_mem(      
    .clock    (QClk),
    .address  (PcQ100H[MSB_I_MEM:0]),
    .data     ('0),
    .rden     (RdEnableQ100H),
    .wren     ('0),
    .q        (InstFetchQ101H)
    );

endmodule               

