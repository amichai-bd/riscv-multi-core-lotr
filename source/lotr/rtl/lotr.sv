//-----------------------------------------------------------------------------
// Title            : Lotar 
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : lotr.sv 
// Original Author  : Amichai
// Created          : 5/2021
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
module lotr 
import lotr_pkg::*;
(
    //General Interface
    input   logic        QClk    ,
    input   logic        RstQnnnH 
);

//=========================================
//=====    ===========
//=========================================
localparam    NUM_TILE = 2;
logic  [7:0]  CoreID               [NUM_TILE + 1 : 1];
logic         RingReqValidQnnnH    [NUM_TILE + 1 : 1];
logic  [9:0]  RingReqRequestorQnnnH[NUM_TILE + 1 : 1];
t_opcode      RingReqOpcodeQnnnH   [NUM_TILE + 1 : 1];
logic  [31:0] RingReqAddressQnnnH  [NUM_TILE + 1 : 1];
logic  [31:0] RingReqDataQnnnH     [NUM_TILE + 1 : 1];
logic         RingRspValidQnnnH    [NUM_TILE + 1 : 1];
logic  [9:0]  RingRspRequestorQnnnH[NUM_TILE + 1 : 1];
t_opcode      RingRspOpcodeQnnnH   [NUM_TILE + 1 : 1];
logic  [31:0] RingRspAddressQnnnH  [NUM_TILE + 1 : 1];
logic  [31:0] RingRspDataQnnnH     [NUM_TILE + 1 : 1];
//assign the last ring output to first ring input
assign RingReqValidQnnnH    [1] = RingReqValidQnnnH    [NUM_TILE+1];
assign RingReqRequestorQnnnH[1] = RingReqRequestorQnnnH[NUM_TILE+1];
assign RingReqOpcodeQnnnH   [1] = RingReqOpcodeQnnnH   [NUM_TILE+1];
assign RingReqAddressQnnnH  [1] = RingReqAddressQnnnH  [NUM_TILE+1];
assign RingReqDataQnnnH     [1] = RingReqDataQnnnH     [NUM_TILE+1];
assign RingRspValidQnnnH    [1] = RingRspValidQnnnH    [NUM_TILE+1];
assign RingRspRequestorQnnnH[1] = RingRspRequestorQnnnH[NUM_TILE+1];
assign RingRspOpcodeQnnnH   [1] = RingRspOpcodeQnnnH   [NUM_TILE+1];
assign RingRspAddressQnnnH  [1] = RingRspAddressQnnnH  [NUM_TILE+1];
assign RingRspDataQnnnH     [1] = RingRspDataQnnnH     [NUM_TILE+1];


//genvar TILE;
//generate for ( TILE = 1 ; TILE<NUM_TILE + 1  ; TILE++) begin : gen_gpc_tiles
//assign CoreID[TILE] = 8'(TILE); //cast to 8 bit the CoreID
//gpc_4t_tile gpc_4t_tile
//(
//    //General Interface
//    .QClk       (QClk)         , //input  logic        
//    .RstQnnnH   (RstQnnnH)     , //input  logic        
//    .CoreID     (CoreID[TILE]) , //input  logic  [7:0] 
//    //================================================
//    //        RING Interface
//    //================================================
//    //Ring ---> RC , RingReqIn
//    .RingReqInValidQ500H        (RingReqValidQnnnH     [TILE])  ,//input
//    .RingReqInRequestorQ500H    (RingReqRequestorQnnnH [TILE])  ,//input
//    .RingReqInOpcodeQ500H       (RingReqOpcodeQnnnH    [TILE])  ,//input
//    .RingReqInAddressQ500H      (RingReqAddressQnnnH   [TILE])  ,//input
//    .RingReqInDataQ500H         (RingReqDataQnnnH      [TILE])  ,//input
//    //Ring ---> RC , RingRspIn
//    .RingRspInValidQ500H        (RingRspValidQnnnH     [TILE])  ,//input
//    .RingRspInRequestorQ500H    (RingRspRequestorQnnnH [TILE])  ,//input
//    .RingRspInOpcodeQ500H       (RingRspOpcodeQnnnH    [TILE])  ,//input
//    .RingRspInAddressQ500H      (RingRspAddressQnnnH   [TILE])  ,//input
//    .RingRspInDataQ500H         (RingRspDataQnnnH      [TILE])  ,//input
//    //RC   ---> Ring , RingReqOut
//    .RingReqOutValidQ502H       (RingReqValidQnnnH    [TILE+1]),//output
//    .RingReqOutRequestorQ502H   (RingReqRequestorQnnnH[TILE+1]),//output
//    .RingReqOutOpcodeQ502H      (RingReqOpcodeQnnnH   [TILE+1]),//output
//    .RingReqOutAddressQ502H     (RingReqAddressQnnnH  [TILE+1]),//output
//    .RingReqOutDataQ502H        (RingReqDataQnnnH     [TILE+1]),//output
//     //RC   ---> Ring , RingRspOut
//    .RingRspOutValidQ502H       (RingRspValidQnnnH    [TILE+1]),//output
//    .RingRspOutRequestorQ502H   (RingRspRequestorQnnnH[TILE+1]),//output
//    .RingRspOutOpcodeQ502H      (RingRspOpcodeQnnnH   [TILE+1]),//output
//    .RingRspOutAddressQ502H     (RingRspAddressQnnnH  [TILE+1]),//output
//    .RingRspOutDataQ502H        (RingRspDataQnnnH     [TILE+1]) //output
//);
//end endgenerate // generate for


gpc_4t_tile gpc_4t_tile_1
(
    //General Interface
    .QClk       (QClk)         , //input  logic        
    .RstQnnnH   (RstQnnnH)     , //input  logic        
    .CoreID     (8'd1) , //input  logic  [7:0] 
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqValidQnnnH     [1])  ,//input
    .RingReqInRequestorQ500H    (RingReqRequestorQnnnH [1])  ,//input
    .RingReqInOpcodeQ500H       (RingReqOpcodeQnnnH    [1])  ,//input
    .RingReqInAddressQ500H      (RingReqAddressQnnnH   [1])  ,//input
    .RingReqInDataQ500H         (RingReqDataQnnnH      [1])  ,//input
    //Ring ---> RC , RingRspIn                          
    .RingRspInValidQ500H        (RingRspValidQnnnH     [1])  ,//input
    .RingRspInRequestorQ500H    (RingRspRequestorQnnnH [1])  ,//input
    .RingRspInOpcodeQ500H       (RingRspOpcodeQnnnH    [1])  ,//input
    .RingRspInAddressQ500H      (RingRspAddressQnnnH   [1])  ,//input
    .RingRspInDataQ500H         (RingRspDataQnnnH      [1])  ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqValidQnnnH    [2]),//output
    .RingReqOutRequestorQ502H   (RingReqRequestorQnnnH[2]),//output
    .RingReqOutOpcodeQ502H      (RingReqOpcodeQnnnH   [2]),//output
    .RingReqOutAddressQ502H     (RingReqAddressQnnnH  [2]),//output
    .RingReqOutDataQ502H        (RingReqDataQnnnH     [2]),//output
     //RC   ---> Ring , RingRspOut                     
    .RingRspOutValidQ502H       (RingRspValidQnnnH    [2]),//output
    .RingRspOutRequestorQ502H   (RingRspRequestorQnnnH[2]),//output
    .RingRspOutOpcodeQ502H      (RingRspOpcodeQnnnH   [2]),//output
    .RingRspOutAddressQ502H     (RingRspAddressQnnnH  [2]),//output
    .RingRspOutDataQ502H        (RingRspDataQnnnH     [2]) //output
);
gpc_4t_tile gpc_4t_tile_2
(
    //General Interface
    .QClk       (QClk)         , //input  logic        
    .RstQnnnH   (RstQnnnH)     , //input  logic        
    .CoreID     (8'd2) , //input  logic  [7:0] 
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqValidQnnnH     [2])  ,//input
    .RingReqInRequestorQ500H    (RingReqRequestorQnnnH [2])  ,//input
    .RingReqInOpcodeQ500H       (RingReqOpcodeQnnnH    [2])  ,//input
    .RingReqInAddressQ500H      (RingReqAddressQnnnH   [2])  ,//input
    .RingReqInDataQ500H         (RingReqDataQnnnH      [2])  ,//input
    //Ring ---> RC , RingRspIn                          2
    .RingRspInValidQ500H        (RingRspValidQnnnH     [2])  ,//input
    .RingRspInRequestorQ500H    (RingRspRequestorQnnnH [2])  ,//input
    .RingRspInOpcodeQ500H       (RingRspOpcodeQnnnH    [2])  ,//input
    .RingRspInAddressQ500H      (RingRspAddressQnnnH   [2])  ,//input
    .RingRspInDataQ500H         (RingRspDataQnnnH      [2])  ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqValidQnnnH    [3]),//output
    .RingReqOutRequestorQ502H   (RingReqRequestorQnnnH[3]),//output
    .RingReqOutOpcodeQ502H      (RingReqOpcodeQnnnH   [3]),//output
    .RingReqOutAddressQ502H     (RingReqAddressQnnnH  [3]),//output
    .RingReqOutDataQ502H        (RingReqDataQnnnH     [3]),//output
     //RC   ---> Ring , RingRspOut                     3
    .RingRspOutValidQ502H       (RingRspValidQnnnH    [3]),//output
    .RingRspOutRequestorQ502H   (RingRspRequestorQnnnH[3]),//output
    .RingRspOutOpcodeQ502H      (RingRspOpcodeQnnnH   [3]),//output
    .RingRspOutAddressQ502H     (RingRspAddressQnnnH  [3]),//output
    .RingRspOutDataQ502H        (RingRspDataQnnnH     [3]) //output
);


endmodule // module lotr
