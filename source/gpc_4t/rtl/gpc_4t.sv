//-----------------------------------------------------------------------------
// Title            : gpc_4t 
// Project          : gpc_4t
//-----------------------------------------------------------------------------
// File             : gpc_4t 
// Original Author  : Amichai Ben-David
// Created          : 2/2021
//-----------------------------------------------------------------------------
// Description :
// The "gpc_4t" instantiates:
// core
// d_mem
// i_mem
// mmio_interface
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "gpc_4t_defines.sv"
module gpc_4t 
    import gpc_4t_pkg::*;  
    (
    input  logic        QClk     ,
    input  logic        RstQnnnH
    );

logic [31:0] PcQ100H        ;
logic [31:0] MemAdrsQ103H   ;
logic [31:0] MemWrDataWQ102H;
logic        CtrlMemWrQ103H ;
logic        CtrlMemRdQ103H ;
logic [3:0]  MemByteEnQ103H ;
t_dfd_reg    DftSignlasQnnnH;
logic [31:0] MemRdDataQ104H ;
t_cr         CRQnnnH        ;
t_drct_out   drct_out       ;
logic [31:0] InstFetchQ101H ;


core_4t core_4t (
    .QClk            (QClk)           ,  // input 
    .RstQnnnH        (RstQnnnH)       ,  // input 
    //Instruction Memory
    .PcQ100H         (PcQ100H)        ,  // output 
    .InstFetchQ101H  (InstFetchQ101H) ,  // input
    //Data Memory
    .MemAdrsQ103H    (MemAdrsQ103H)   ,  // output 
    .MemWrDataWQ102H (MemWrDataWQ102H),  // output 
    .CtrlMemWrQ103H  (CtrlMemWrQ103H) ,  // output 
    .CtrlMemRdQ103H  (CtrlMemRdQ103H) ,  // output 
    .MemByteEnQ103H  (MemByteEnQ103H) ,  // output 
    .MemRdDataQ104H  (MemRdDataQ104H) ,  // input
    //MMIO
    .DftSignlasQnnnH (DftSignlasQnnnH),  // output 
    .CRQnnnH         (CRQnnnH)           // input
);

d_mem_wrap d_mem_wrap (
    .clock           (QClk)           ,  // input   
    .rst             (RstQnnnH)       ,  // input    
    //req rd/wr interace
    .address         (MemAdrsQ102H)   ,  // input  TODO - address input should mux CORE vs MMIO
    .byteena         (MemByteEnQ102H) ,  
    .data            (MemWrDataWQ102H),  // input  TODO - wr_data input should mux CORE vs MMIO
    .rden            (CtrlMemRdQ102H) ,  // input  TODO - rden    when reading from d_mem wren should be desabled   input should mux CORE vs MMIO    
    .wren            (CtrlMemWrQ102H) ,  // input  TODO - wren    when writing to d_mem rden should be desabled     input should mux CORE vs MMIO
    .q               (MemRdDataQ103H) ,  // output TODO - data    output should rename to general d_mem output data 
    //other singlas
    .cr              (CRQnnnH)        ,  // output 
    .drct_out        (drct_out)          // output 
);

i_mem_wrap i_mem_wrap (
    .clock           (QClk)           ,  // input 
    .rst             (RstQnnnH)       ,  // input 
    //req rd/wr interace
    .address         (PcQ100H)        ,  // input  TODO - address input  should mux CORE vs MMIO
    .data            (32'b0)          ,  // input  TODO - wr_data only the MMIO inerface can write to the i_mem
    .rden            (1'b1)           ,  // input  TODO - rden    only the MMIO inerface can write to the i_mem
    .wren            (1'b0)           ,  // input  TODO - wren    when writing to i_mem rden should be desabled 
    .q               (InstFetchQ101H)    // output TODO - data    output should rename to general i_mem output data
);

endmodule
