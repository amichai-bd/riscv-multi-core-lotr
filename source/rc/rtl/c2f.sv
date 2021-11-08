//-----------------------------------------------------------------------------
// Title            : RC - Ring Controller 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : c2f.sv 
// Original Author  : Amichai Ben-David
// Adviser          : Amichai Ben-David
// Created          : 11/2021
//-----------------------------------------------------------------------------
// Description :
// 
//------------------------------------------------------------------------------
// Modification history :
//
//------------------------------------------------------------------------------
`include "lotr_defines.sv"
module c2f
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  CoreID                 ,
    input   t_winner      SelRingReqOutQ501H     ,
    //===================================
    // Request Flow
    //===================================
    //Core ---> C2F
    input   logic         C2F_ReqValidQ500H      ,
    input   t_opcode      C2F_ReqOpcodeQ500H     ,
    input   logic  [31:0] C2F_ReqAddressQ500H    ,
    input   logic  [31:0] C2F_ReqDataQ500H       ,
    input   logic  [1:0]  C2F_ReqThreadIDQ500H   ,
    //F2C ---> RING , RingRspOut
    output  logic         C2F_ReqValidQ501H      ,
    output  logic  [9:0]  C2F_ReqRequestorQ501H  ,     
    output  t_opcode      C2F_ReqOpcodeQ501H     ,
    output  logic  [31:0] C2F_ReqAddressQ501H    ,
    output  logic  [31:0] C2F_ReqDataQ501H       ,
    //===================================
    // Response Flow
    //===================================
    //Ring ---> F2C , RingReqIn
    input   logic         RingRspInValidQ501H    ,
    input   logic  [9:0]  RingRspInRequestorQ501H,    
    input   t_opcode      RingRspInOpcodeQ501H   ,
    input   logic  [31:0] RingRspInAddressQ501H  ,
    input   logic  [31:0] RingRspInDataQ501H     ,
    //C2F ---> Core
    output  logic         C2F_RspValidQ502H      ,
    output  t_opcode      C2F_RspOpcodeQ502H     ,
    output  logic  [31:0] C2F_RspDataQ502H       ,
    output  logic         C2F_RspStall           ,
    output  logic  [1:0]  C2F_RspThreadIDQ502H   
);
//=====    Req Interface - not implemenntaed , related to C2F    ===========
logic  [1:0]  C2F_ReqThreadIdQ501H;
//FIXME - Temporarly connecting the C2F_request to the RingReqOut to allow simple Enablemnt of writes from core to Fabric.
`LOTR_RST_MSFF( C2F_ReqValidQ501H, C2F_ReqValidQ500H   , QClk ,RstQnnnH)
`LOTR_MSFF( C2F_ReqOpcodeQ501H   , C2F_ReqOpcodeQ500H  , QClk )
`LOTR_MSFF( C2F_ReqAddressQ501H  , C2F_ReqAddressQ500H , QClk )
`LOTR_MSFF( C2F_ReqDataQ501H     , C2F_ReqDataQ500H    , QClk )
`LOTR_MSFF( C2F_ReqRequestorQ501H , {CoreID,C2F_ReqThreadIDQ500H}, QClk )
//==========================================================================
//FIXME - temporary until the C2F BUFFER will be ready:
logic         C2F_RspValidQ501H    ;
t_opcode      C2F_RspOpcodeQ501H   ;
logic  [31:0] C2F_RspDataQ501H     ;
logic  [1:0]  C2F_RspThreadIDQ501H ; 
logic         RingRspValidMatchQ501H;
logic         RequestorMatchIdQ501H;
assign C2F_RspStall             = '0;
assign RequestorMatchIdQ501H    = (RingRspInRequestorQ501H[9:2] == CoreID) ; //This means the Rsp matches the requestor
assign RingRspValidMatchQ501H   = RequestorMatchIdQ501H && RingRspInValidQ501H;
//Send Rsp to Core only if RingRspValidMatchQ501H
assign C2F_RspValidQ501H        = RingRspValidMatchQ501H ? RingRspInValidQ501H          : 1'b0;
assign C2F_RspOpcodeQ501H       = RingRspValidMatchQ501H ? RingRspInOpcodeQ501H         : RD;
assign C2F_RspDataQ501H         = RingRspValidMatchQ501H ? RingRspInDataQ501H           : '0;
assign C2F_RspThreadIDQ501H     = RingRspValidMatchQ501H ? RingRspInRequestorQ501H[1:0] : '0;
`LOTR_MSFF( C2F_RspValidQ502H     , C2F_RspValidQ501H    , QClk )
`LOTR_MSFF( C2F_RspOpcodeQ502H    , C2F_RspOpcodeQ501H    , QClk )
`LOTR_MSFF( C2F_RspDataQ502H      , C2F_RspDataQ501H     , QClk )
`LOTR_MSFF( C2F_RspThreadIDQ502H  , C2F_RspThreadIDQ501H , QClk )

endmodule // module c2f

