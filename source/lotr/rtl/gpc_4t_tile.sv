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
(
    //General Interface
    input   logic         QClk                   ,
    input   logic         RstQnnnH               ,
    input   logic  [7:0]  CoreID                 ,
    //Ring ---> RC
    input   logic         RingInputValidQ500H    ,
    input   logic  [1:0]  RingInputOpcodeQ500H   ,
    input   logic  [31:0] RingInputAddressQ500H  ,
    input   logic  [31:0] RingInputDataQ500H     ,
    //RC   ---> Ring
    output  logic         RingOutputValidQ502H   ,
    output  logic  [1:0]  RingOutputOpcodeQ502H  ,
    output  logic  [31:0] RingOutputAddressQ502H ,
    output  logic  [31:0] RingOutputDataQ502H
);

//================================================
// Core <-> RC interface
//================================================
// Core To Fabric(C2F) logic
// C2F_Rsp
logic        C2F_RspValidQ502H   ;  
logic [1:0]  C2F_RspOpcodeQ502H  ;  
logic [1:0]  C2F_RspThreadIDQ502H;  
logic [31:0] C2F_RspDataQ502H    ;
logic        C2F_RspStall        ;
// C2F_Req
logic        C2F_ReqValidQ500H   ;
logic [1:0]  C2F_ReqOpcodeQ500H  ;
logic [1:0]  C2F_ReqThreadIDQ500H;
logic [31:0] C2F_ReqAddressQ500H ;
logic [31:0] C2F_ReqDataQ500H    ;
//Fabric To Core(F2C) logic
logic        F2C_ReqValidQ502H   ;
logic [1:0]  F2C_ReqOpcodeQ502H  ;
logic [31:0] F2C_ReqAddressQ502H ;
logic [31:0] F2C_ReqDataQ502H    ;
logic        F2C_RspValidQ500H   ;
logic [1:0]  F2C_RspOpcodeQ500H  ;
logic [31:0] F2C_RspAddressQ500H ;
logic [31:0] F2C_RspDataQ500H    ;




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
    // input - Req/Rsp from Ring
    .RingInputValidQ500H    (RingInputValidQ500H)    ,//input
    .RingInputOpcodeQ500H   (RingInputOpcodeQ500H)   ,//input
    .RingInputAddressQ500H  (RingInputAddressQ500H)  ,//input
    .RingInputDataQ500H     (RingInputDataQ500H)     ,//input
    // output - Req/Rsp to Ring
    .RingOutputValidQ502H   (RingOutputValidQ502H)   ,//output
    .RingOutputOpcodeQ502H  (RingOutputOpcodeQ502H)  ,//output
    .RingOutputAddressQ502H (RingOutputAddressQ502H) ,//output 
    .RingOutputDataQ502H    (RingOutputDataQ502H)    ,//output
    //================================================
    //        Core Interface
    //================================================
    // input - Req from Core
    .C2F_ReqValidQ500H      (C2F_ReqValidQ500H)      ,//input
    .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H)     ,//input
    .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H)   ,//input
    .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H)    ,//input
    .C2F_ReqDataQ500H       (C2F_ReqDataQ500H)       ,//input
    // input - Rsp to Core
    .C2F_RspValidQ502H      (C2F_RspValidQ502H)      ,//output
    .C2F_RspThreadIDQ502H   (C2F_RspThreadIDQ502H)   ,//output
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
    //================================================
    //        Core Interface
    //================================================
    // input - Rsp to Core
    .C2F_RspValidQ502H      (C2F_RspValidQ502H)      ,//input
    .C2F_RspOpcodeQ502H     (C2F_RspOpcodeQ502H)     ,//input
    .C2F_RspThreadIDQ502H   (C2F_RspThreadIDQ502H)   ,//input
    .C2F_RspDataQ502H       (C2F_RspDataQ502H)       ,//input
    .C2F_RspStall           (C2F_RspStall)           ,//input
    // output - Req from Core
    .C2F_ReqValidQ500H      (C2F_ReqValidQ500H)      ,//output
    .C2F_ReqOpcodeQ500H     (C2F_ReqOpcodeQ500H)     ,//output
    .C2F_ReqThreadIDQ500H   (C2F_ReqThreadIDQ500H)   ,//output
    .C2F_ReqAddressQ500H    (C2F_ReqAddressQ500H)    ,//output
    .C2F_ReqDataQ500H       (C2F_ReqDataQ500H)       ,//output
    //================================================
    //        Core Interface
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
