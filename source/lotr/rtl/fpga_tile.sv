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
module fpga_tile
import lotr_pkg::*;
(
    //General Interface
    input   logic         QClk                     ,
    input   logic         CLK_50                     ,
    input   logic         RstQnnnH                 ,
    input   logic  [7:0]  CoreID                   ,
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
    output  logic  [31:0] RingRspOutDataQ502H      ,

    //==============================
    // Tile <-> FPGA TOP
    //==============================
    // Tile ---> Top
    input logic Button_0                            ,
    input logic Button_1                            ,
    input logic [9:0] Switch                        ,
    input logic [15:0] Arduino_dg_io,

    // Top ----> Tile
    output logic [7:0] SEG7_0                       ,
    output logic [7:0] SEG7_1                       ,
    output logic [7:0] SEG7_2                       ,
    output logic [7:0] SEG7_3                       ,
    output logic [7:0] SEG7_4                       ,
    output logic [7:0] SEG7_5                       ,
    output logic [3:0] RED,
    output logic [3:0] GREEN,
    output logic [3:0] BLUE,
    output logic       v_sync,
    output logic       h_sync,
    output logic [9:0] LED,
    output logic       ALL_PC_RESET

);

//================================================
// DE10Lite_MMIO <-> RC interface
//================================================
//Fabric To Core(F2C) logic
logic        F2C_ReqValidQ502H   ;
t_opcode     F2C_ReqOpcodeQ502H  ;
logic [31:0] F2C_ReqAddressQ502H ;
logic [31:0] F2C_ReqDataQ502H    ;
logic        F2C_RspValidQ500H   ;
t_opcode     F2C_RspOpcodeQ500H  ;
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
    //        DE10Lite_MMIO Interface
    //================================================
    // input - Req from Core
    .C2F_ReqValidQ500H      ('0)   ,//input
    .C2F_ReqOpcodeQ500H     (t_opcode'('0))   ,//input
    .C2F_ReqThreadIDQ500H   ('0)   ,//input
    .C2F_ReqAddressQ500H    ('0)   ,//input
    .C2F_ReqDataQ500H       ('0)   ,//input
    // output - Rsp to Core
    .C2F_RspValidQ502H      ()   ,//output
    .C2F_RspOpcodeQ502H     ()   ,//output
    .C2F_RspThreadIDQ502H   ()   ,//output
    .C2F_RspDataQ502H       ()   ,//output
    .C2F_RspStall           ()   ,//output
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

DE10Lite_MMIO DE10Lite_MMIO(
    //================================================
    //        General Interface
    //================================================
    .QClk                   (QClk)                   ,//input
    .CLK_50                 (CLK_50)                 ,//input
    .RstQnnnH               (RstQnnnH)               ,//input
    .CoreID                 (CoreID)                 ,//input
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
    .F2C_RspDataQ500H       (F2C_RspDataQ500H),        //output
    // FPGA interface inputs
    .Button_0    (Button_0),
    .Button_1    (Button_1),
    .Switch      (Switch),
    .Arduino_dg_io (Arduino_dg_io),

    //outputs
    .SEG7_0  (SEG7_0),
    .SEG7_1  (SEG7_1),
    .SEG7_2  (SEG7_2),
    .SEG7_3  (SEG7_3),
    .SEG7_4  (SEG7_4),
    .SEG7_5  (SEG7_5),
    .RED     (RED   ),//output logic [3:0] 
    .GREEN   (GREEN ),//output logic [3:0] 
    .BLUE    (BLUE  ),//output logic [3:0] 
    .v_sync  (v_sync),//output logic       
    .h_sync  (h_sync),//output logic       
    .LED     (LED   ),
    .ALL_PC_RESET(ALL_PC_RESET   )




    );

endmodule // module fpga_tile
