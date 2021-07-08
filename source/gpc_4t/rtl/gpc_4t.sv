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
    import lotr_pkg::*;  
    (
    input  logic          QClk                ,
    input  logic          RstQnnnH            ,
    input  logic [7:0]    CoreID              ,
    //Core To Fabric(C2F)
    input  logic          C2F_RspValidQ502H   ,  
    input  t_opcode       C2F_RspOpcodeQ502H  ,  
    input  logic [1:0]    C2F_RspThreadIDQ502H,  
    input  logic [31:0]   C2F_RspDataQ502H    ,
    input  logic          C2F_RspStall        ,
    output logic          C2F_ReqValidQ500H   ,
    output t_opcode       C2F_ReqOpcodeQ500H  ,
    output logic [1:0]    C2F_ReqThreadIDQ500H,
    output logic [31:0]   C2F_ReqAddressQ500H ,
    output logic [31:0]   C2F_ReqDataQ500H    ,
    //Fabric To Core(F2C)
    input  logic          F2C_ReqValidQ502H   ,
    input  t_opcode       F2C_ReqOpcodeQ502H  ,
    input  logic [31:0]   F2C_ReqAddressQ502H ,
    input  logic [31:0]   F2C_ReqDataQ502H    ,
    output logic          F2C_RspValidQ500H   ,
    output t_opcode       F2C_RspOpcodeQ500H  ,
    output logic [31:0]   F2C_RspAddressQ500H ,
    output logic [31:0]   F2C_RspDataQ500H   
    );

//=========================================
//     Local GPC_4T interface
//=========================================
logic [31:0] PcQ100H        ;
logic [31:0] MemAdrsQ103H   ;
logic [31:0] MemWrDataQ103H;
logic        CtrlMemWrQ103H ;
logic        CtrlMemRdQ103H ;
logic [3:0]  MemByteEnQ103H ;
logic [3:0]  ThreadQ103H    ;
logic [31:0] PcQ103H        ;
logic [31:0] MemRdDataQ104H ;
t_core_cr    CRQnnnH        ;
logic [31:0] InstFetchQ101H ;

//=========================================
//      Fabric to local memory interface 
//=========================================
//input 
logic          F2C_ReqValidQ503H  ; 
t_opcode       F2C_ReqOpcodeQ503H ; 
logic [31:0]   F2C_ReqAddressQ503H;
logic [31:0]   F2C_ReqDataQ503H   ; 
//output
logic          F2C_RspValidQ504H  ; 
t_opcode       F2C_RspOpcodeQ504H ; 
logic [31:0]   F2C_RspAddressQ504H;
logic [31:0]   F2C_RspDataQ504H   ; 
logic [31:0]   F2C_I_MemRspDataQ504H; 
logic [31:0]   F2C_D_MemRspDataQ504H; 

logic  F2C_RdEnQ503H;
logic  F2C_WrEnQ503H;
logic  F2C_I_MemHitQ503H;
logic  F2C_D_MemHitQ503H;

//=========================================
//      Fabric to local memory interface repeater
//=========================================
//Sample input
`LOTR_MSFF(F2C_ReqValidQ503H   ,F2C_ReqValidQ502H   , QClk)
`LOTR_MSFF(F2C_ReqOpcodeQ503H  ,F2C_ReqOpcodeQ502H  , QClk)
`LOTR_MSFF(F2C_ReqAddressQ503H ,F2C_ReqAddressQ502H , QClk)
`LOTR_MSFF(F2C_ReqDataQ503H    ,F2C_ReqDataQ502H    , QClk)

//===========================================
//    set F2C request 503 ( D_MEM | I_MEM )
//===========================================
assign F2C_RdEnQ503H     = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == RD);
assign F2C_WrEnQ503H     = F2C_ReqValidQ503H && (F2C_ReqOpcodeQ503H == WR);
assign F2C_I_MemHitQ503H =(F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == I_MEM_REGION) ;
assign F2C_D_MemHitQ503H =(F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == D_MEM_REGION) ||
                          (F2C_ReqAddressQ503H[MSB_REGION:LSB_REGION] == CR_REGION);

//============================================
//    set F2C Respose 504 ( D_MEM | I_MEM )
//============================================
`LOTR_MSFF(F2C_RspValidQ504H  , F2C_RdEnQ503H      , QClk)
`LOTR_MSFF(F2C_RspOpcodeQ504H , RD_RSP             , QClk)
`LOTR_MSFF(F2C_RspAddressQ504H, F2C_ReqAddressQ502H, QClk)
assign F2C_RspDataQ504H = F2C_I_MemHitQ503H ? F2C_I_MemRspDataQ504H :
                          F2C_D_MemHitQ503H ? F2C_D_MemRspDataQ504H :
                                              32'b0;
//Sample output
`LOTR_MSFF(F2C_RspValidQ500H   ,F2C_RspValidQ504H   , QClk)
`LOTR_MSFF(F2C_RspOpcodeQ500H  ,F2C_RspOpcodeQ504H  , QClk)
`LOTR_MSFF(F2C_RspAddressQ500H ,F2C_RspAddressQ504H , QClk)
`LOTR_MSFF(F2C_RspDataQ500H    ,F2C_RspDataQ504H    , QClk)

//============================================
//      core 
//============================================
core_4t core_4t (
    .QClk            (QClk)           ,  // input 
    .RstQnnnH        (RstQnnnH)       ,  // input 
    //Instruction Memory
    .PcQ100H         (PcQ100H)        ,  // output 
    .InstFetchQ101H  (InstFetchQ101H) ,  // input
    //Data Memory
    .MemAdrsQ103H    (MemAdrsQ103H)   ,  // output 
    .MemWrDataQ103H  (MemWrDataQ103H) ,  // output 
    .CtrlMemWrQ103H  (CtrlMemWrQ103H) ,  // output 
    .CtrlMemRdQ103H  (CtrlMemRdQ103H) ,  // output 
    .MemByteEnQ103H  (MemByteEnQ103H) ,  // output 
    .ThreadQ103H     (ThreadQ103H)    ,  // output   
    .PcQ103H         (PcQ103H)        ,  //
    .MemRdDataQ104H  (MemRdDataQ104H) ,  // input
    //MMIO
    .CRQnnnH         (CRQnnnH)           // input
);

//============================================
//      d_mem_wrap 
//============================================
d_mem_wrap d_mem_wrap (
    .QClk               (QClk)           ,  // input   
    .RstQnnnH           (RstQnnnH)       ,  // input    
    .CoreIdStrap        (CoreID)         ,  // input    
    .CRQnnnH            (CRQnnnH)        ,  // output 
    //============================================
    //      core interface
    //============================================
    //req rd/wr interace
    .AddressQ103H       (MemAdrsQ103H)   ,  // input
    .ByteEnQ103H        (MemByteEnQ103H) ,
    .ThreadQ103H        (ThreadQ103H)    ,  // input     
    .PcQ103H            (PcQ103H)        ,    
    .WrDataQ103H        (MemWrDataQ103H) ,  // input
    .RdEnQ103H          (CtrlMemRdQ103H) ,  // input
    .WrEnQ103H          (CtrlMemWrQ103H) ,  // input
    .MemRdDataQ104H     (MemRdDataQ104H) ,  // output
    //============================================
    //      RC interface
    //============================================
    .F2C_AddressQ503H   (F2C_ReqAddressQ503H)  ,  // input 
    .F2C_WrDataQ503H    (F2C_ReqDataQ503H)     ,  // input 
    .F2C_RdEnQ503H      (F2C_RdEnQ503H)        ,  // input 
    .F2C_WrEnQ503H      (F2C_WrEnQ503H)        ,  // input 
    .F2C_MemRdDataQ504H (F2C_D_MemRspDataQ504H)   // output
);

//============================================
//      i_mem_wrap 
//============================================
i_mem_wrap i_mem_wrap (
    .QClk                   (QClk)           ,  // input 
    .RstQnnnH               (RstQnnnH)       ,  // input 
    //============================================
    //      core interface
    //============================================
    .PcQ100H                (PcQ100H)        ,  // input  
    .RdEnableQ100H          (1'b1)           ,  // input  
    .InstFetchQ101H         (InstFetchQ101H) ,  // output 
    //============================================
    //      RC interface
    //============================================
    .F2C_ReqAddressQ503H    (F2C_ReqAddressQ503H)    ,  // input   address input  should mux CORE vs MMIO
    .F2C_ReqDataQ503H       (F2C_ReqDataQ503H)       ,  // input   wr_data only the MMIO inerface can write to the i_mem
    .F2C_RdEnQ503H          (F2C_RdEnQ503H)          ,  // input   rden    only the MMIO inerface can write to the i_mem
    .F2C_WrEnQ503H          (F2C_WrEnQ503H)          ,  // input   wren    when writing to i_mem rden should be desabled 
    .F2C_I_MemRspDataQ504H  (F2C_I_MemRspDataQ504H)     // output  data    output should rename to general i_mem output data
);

endmodule
