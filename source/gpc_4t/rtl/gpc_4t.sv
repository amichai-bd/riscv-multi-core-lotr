//-----------------------------------------------------------------------------
// Title            : gpc_4t 
// Project          : LOTR: Lord-Of-The-Ring
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

`include "lotr_defines.sv"
module gpc_4t 
    import gpc_4t_pkg::*;  
    (
    input  logic          QClk                ,
    input  logic          RstQnnnH            ,
    input  logic [7:0]    CoreID              ,
    //Core To Fabric(C2F)
    input  logic          C2F_RspValidQ502H   ,  
    input  logic [1:0]    C2F_RspOpcodeQ502H  ,  
    input  logic [1:0]    C2F_RspThreadIDQ502H,  
    input  logic [31:0]   C2F_RspDataQ502H    ,
    input  logic          C2F_RspStall        ,
    output logic          C2F_ReqValidQ500H   ,
    output logic [1:0]    C2F_ReqOpcodeQ500H  ,
    output logic [1:0]    C2F_ReqThreadIDQ500H,
    output logic [31:0]   C2F_ReqAddressQ500H ,
    output logic [31:0]   C2F_ReqDataQ500H    ,
    //Fabric To Core(F2C)
    input  logic          F2C_ReqValidQ502H   ,
    input  logic [1:0]    F2C_ReqOpcodeQ502H  ,
    input  logic [31:0]   F2C_ReqAddressQ502H ,
    input  logic [31:0]   F2C_ReqDataQ502H    ,
    output logic          F2C_RspValidQ500H   ,
    output logic [1:0]    F2C_RspOpcodeQ500H  ,
    output logic [31:0]   F2C_RspAddressQ500H ,
    output logic [31:0]   F2C_RspDataQ500H
    );

logic [31:0] PcQ100H        ;
logic [31:0] MemAdrsQ103H   ;
logic [31:0] MemWrDataWQ103H;
logic        CtrlMemWrQ103H ;
logic        CtrlMemRdQ103H ;
logic [3:0]  MemByteEnQ103H ;
logic [3:0]  ThreadQ103H    ;
logic [31:0] PcQ103H        ;
logic [31:0] MemRdDataQ104H ;
t_core_cr         CRQnnnH        ;
logic [31:0] InstFetchQ101H ;



core_4t core_4t (
    .QClk            (QClk)           ,  // input 
    .RstQnnnH        (RstQnnnH)       ,  // input 
    //Instruction Memory
    .PcQ100H         (PcQ100H)        ,  // output 
    .InstFetchQ101H  (InstFetchQ101H) ,  // input
    //Data Memory
    .MemAdrsQ103H    (MemAdrsQ103H)   ,  // output 
    .MemWrDataWQ103H (MemWrDataWQ103H),  // output 
    .CtrlMemWrQ103H  (CtrlMemWrQ103H) ,  // output 
    .CtrlMemRdQ103H  (CtrlMemRdQ103H) ,  // output 
    .MemByteEnQ103H  (MemByteEnQ103H) ,  // output 
    .ThreadQ103H     (ThreadQ103H)    ,  // output   
    .PcQ103H         (PcQ103H)        , //
    .MemRdDataQ104H  (MemRdDataQ104H) ,  // input
    //MMIO
    .CRQnnnH         (CRQnnnH)           // input
);

d_mem_wrap d_mem_wrap (
    .clock           (QClk)           ,  // input   
    .rst             (RstQnnnH)       ,  // input    
    //req rd/wr interace
    .address         (MemAdrsQ103H)   ,  // input  TODO - address input should mux CORE vs MMIO
    .byteena         (MemByteEnQ103H) ,
    .ThreadQ103H     (ThreadQ103H)    ,  // input     
    .PcQ103H         (PcQ103H)        ,    
    .data            (MemWrDataWQ103H),  // input  TODO - wr_data input should mux CORE vs MMIO
    .rden            (CtrlMemRdQ103H) ,  // input  TODO - rden    when reading from d_mem wren should be desabled   input should mux CORE vs MMIO    
    .wren            (CtrlMemWrQ103H) ,  // input  TODO - wren    when writing to d_mem rden should be desabled     input should mux CORE vs MMIO
    .q               (MemRdDataQ104H) ,  // output TODO - data    output should rename to general d_mem output data 
    //other singlas
    .core_cr              (CRQnnnH)           // output 
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
