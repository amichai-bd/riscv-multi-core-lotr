//-----------------------------------------------------------------------------
// Title            : Lotar Tile
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : gpc_4t_tile.sv 
// Original Author  : Amichai
// Created          : 7/2021
//-----------------------------------------------------------------------------
// Description :
// 
//
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "lotr_defines.sv"
module gpc_4t_tile
import lotr_pkg::*;
(
    //General Interface
    input   logic         QClk                     ,
    input   logic         RstQnnnH                 ,
    input   logic  [7:0]  CoreID                   ,
    input   logic         ALL_PC_RESET             ,
    //===================================
    // Tile <-> Fabric Inteface
    //===================================
    //Ring ---> RC , RingReqIn
    input   logic         RingReqInValidQ500H      ,
    input   logic  [9:0]  RingReqInRequestorQ500H  ,    
    input   t_opcode      RingReqInOpcodeQ500H     ,
    input   logic  [31:0] RingReqInAddressQ500H    ,
    input   logic  [31:0] RingReqInDataQ500H       ,
    //Ring ---> RC , RingRspIn
    input   logic         RingRspInValidQ500H      ,
    input   logic  [9:0]  RingRspInRequestorQ500H  ,    
    input   t_opcode      RingRspInOpcodeQ500H     ,
    input   logic  [31:0] RingRspInAddressQ500H    ,
    input   logic  [31:0] RingRspInDataQ500H       ,
    //RC   ---> Ring , RingReqOut
    output  logic         RingReqOutValidQ502H     ,
    output  logic  [9:0]  RingReqOutRequestorQ502H ,    
    output  t_opcode      RingReqOutOpcodeQ502H    ,
    output  logic  [31:0] RingReqOutAddressQ502H   ,
    output  logic  [31:0] RingReqOutDataQ502H      ,
     //RC   ---> Ring , RingRspOut
    output  logic         RingRspOutValidQ502H     ,
    output  logic  [9:0]  RingRspOutRequestorQ502H ,    
    output  t_opcode      RingRspOutOpcodeQ502H    ,
    output  logic  [31:0] RingRspOutAddressQ502H   ,
    output  logic  [31:0] RingRspOutDataQ502H 
);

//================================================
// Core <-> RC interface
//================================================
// Core To Fabric(C2F) logic
// C2F_Rsp
logic        C2F_RspValidQ502H   ;  
t_opcode     C2F_RspOpcodeQ502H  ;  
logic [9:0]  C2F_RspThreadIDQ502H;  
logic [31:0] C2F_RspDataQ502H    ;
logic        C2F_RspStall        ;
// C2F_Req
logic        C2F_ReqValidQ500H   ;
t_opcode     C2F_ReqOpcodeQ500H  ;
logic [9:0]  C2F_ReqThreadIDQ500H;
logic [31:0] C2F_ReqAddressQ500H ;
logic [31:0] C2F_ReqDataQ500H    ;
//Fabric To Core(F2C) logic
logic        F2C_ReqValidQ502H   ;
t_opcode     F2C_ReqOpcodeQ502H  ;
logic [31:0] F2C_ReqAddressQ502H ;
logic [31:0] F2C_ReqDataQ502H    ;
logic        F2C_RspValidQ500H   ;
t_opcode     F2C_RspOpcodeQ500H  ;
logic [31:0] F2C_RspAddressQ500H ;
logic [31:0] F2C_RspDataQ500H    ;



assign C2F_ReqThreadIDQ500H[9:2] = CoreID;
assign C2F_RspThreadIDQ502H[9:2] = CoreID;
rc rc(	  
    //================================================
    //        General Interface
    //================================================
    .QClk  		            (QClk)                   ,//input 
    .RstQnnnH  	            (RstQnnnH)               ,//input 
    .CoreID       		    (CoreID)                 ,//input 
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqInValidQ500H)      ,//input
    .RingReqInRequestorQ500H    (RingReqInRequestorQ500H)  ,//input
    .RingReqInOpcodeQ500H       (RingReqInOpcodeQ500H)     ,//input
    .RingReqInAddressQ500H      (RingReqInAddressQ500H)    ,//input
    .RingReqInDataQ500H         (RingReqInDataQ500H)       ,//input
    //Ring ---> RC , RingRspIn
    .RingRspInValidQ500H        (RingRspInValidQ500H)      ,//input
    .RingRspInRequestorQ500H    (RingRspInRequestorQ500H)  ,//input
    .RingRspInOpcodeQ500H       (RingRspInOpcodeQ500H)     ,//input
    .RingRspInAddressQ500H      (RingRspInAddressQ500H)    ,//input
    .RingRspInDataQ500H         (RingRspInDataQ500H)       ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqOutValidQ502H)     ,//output
    .RingReqOutRequestorQ502H   (RingReqOutRequestorQ502H) ,//output
    .RingReqOutOpcodeQ502H      (RingReqOutOpcodeQ502H)    ,//output
    .RingReqOutAddressQ502H     (RingReqOutAddressQ502H)   ,//output
    .RingReqOutDataQ502H        (RingReqOutDataQ502H)      ,//output
     //RC   ---> Ring , RingRspOut
    .RingRspOutValidQ502H       (RingRspOutValidQ502H)     ,//output
    .RingRspOutRequestorQ502H   (RingRspOutRequestorQ502H) ,//output
    .RingRspOutOpcodeQ502H      (RingRspOutOpcodeQ502H)    ,//output
    .RingRspOutAddressQ502H     (RingRspOutAddressQ502H)   ,//output
    .RingRspOutDataQ502H        (RingRspOutDataQ502H)      ,//output
    //================================================
    //        Core Interface
    //================================================
    // input - Req from Core
    .C2F_ReqValidQ500H      (C2F_ReqValidQ500H)      ,//input
    .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H)     ,//input
    .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H[1:0])   ,//input
    .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H)    ,//input
    .C2F_ReqDataQ500H       (C2F_ReqDataQ500H)       ,//input
    // output - Rsp to Core
    .C2F_RspValidQ502H      (C2F_RspValidQ502H)      ,//output
    .C2F_RspOpcodeQ502H     (C2F_RspOpcodeQ502H)     ,//output
    .C2F_RspThreadIDQ502H   (C2F_RspThreadIDQ502H[1:0])   ,//output
    .C2F_RspDataQ502H       (C2F_RspDataQ502H)       ,//output
    .C2F_RspStall           (C2F_RspStall)           ,//output
    // input - Rsp from Local Memory -> to Ring/Fabric
    .F2C_RspValidQ500H      (F2C_RspValidQ500H)      ,//input
    .F2C_RspOpcodeQ500H     (F2C_RspOpcodeQ500H)     ,//input
    .F2C_RspAddressQ500H    (F2C_RspAddressQ500H)    ,//input
    .F2C_RspDataQ500H       (F2C_RspDataQ500H)       ,//input
    // output - Req to Local Memory
    .F2C_ReqValidQ502H      (F2C_ReqValidQ502H)      ,//output
    .F2C_ReqOpcodeQ502H     (F2C_ReqOpcodeQ502H)     ,//output
    .F2C_ReqAddressQ502H    (F2C_ReqAddressQ502H)    ,//output
    .F2C_ReqDataQ502H       (F2C_ReqDataQ502H)        //output
    );

gpc_4t gpc_4t(
    //================================================
    //        General Interface
    //================================================
    .QClk                   (QClk)                   ,//input
    .RstQnnnH               (RstQnnnH)               ,//input
    .CoreID                 (CoreID)                 ,//input
    .ALL_PC_RESET(ALL_PC_RESET),
    //================================================
    //        Core to Fabric
    //================================================
    // input - Rsp to Core
    .C2F_RspValidQ502H      (C2F_RspValidQ502H)      ,//input
    .C2F_RspOpcodeQ502H     (C2F_RspOpcodeQ502H)     ,//input
    .C2F_RspThreadIDQ502H   (C2F_RspThreadIDQ502H[1:0])   ,//input
    .C2F_RspDataQ502H       (C2F_RspDataQ502H)       ,//input
    .C2F_RspStall           (C2F_RspStall)           ,//input
    // output - Req from Core
    .C2F_ReqValidQ500H      (C2F_ReqValidQ500H)      ,//output
    .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H)     ,//output
    .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H[1:0])   ,//output
    .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H)    ,//output
    .C2F_ReqDataQ500H       (C2F_ReqDataQ500H)       ,//output
    //================================================
    //        Fabric to Core
    //================================================
    // input - Req from Ring/Fabric
    .F2C_ReqValidQ502H      (F2C_ReqValidQ502H)      ,//input
    .F2C_ReqOpcodeQ502H     (F2C_ReqOpcodeQ502H)     ,//input
    .F2C_ReqAddressQ502H    (F2C_ReqAddressQ502H)    ,//input
    .F2C_ReqDataQ502H       (F2C_ReqDataQ502H)       ,//input
    // output - Rsp to Ring/Fabric
    .F2C_RspValidQ500H      (F2C_RspValidQ500H)      ,//output
    .F2C_RspOpcodeQ500H     (F2C_RspOpcodeQ500H)     ,//output
    .F2C_RspAddressQ500H    (F2C_RspAddressQ500H)    ,//output
    .F2C_RspDataQ500H       (F2C_RspDataQ500H)        //output
    );

endmodule // module goc_4t_tile
