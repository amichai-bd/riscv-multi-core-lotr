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
localparam    NUM_TILE = 4;
logic  [7:0]  CoreID               [NUM_TILE:0];
logic         RingReqValidQnnnH    [NUM_TILE:0];
logic  [9:0]  RingReqRequestorQnnnH[NUM_TILE:0];
t_opcode      RingReqOpcodeQnnnH   [NUM_TILE:0];
logic  [31:0] RingReqAddressQnnnH  [NUM_TILE:0];
logic  [31:0] RingReqDataQnnnH     [NUM_TILE:0];
logic         RingRspValidQnnnH    [NUM_TILE:0];
logic  [9:0]  RingRspRequestorQnnnH[NUM_TILE:0];
t_opcode      RingRspOpcodeQnnnH   [NUM_TILE:0];
logic  [31:0] RingRspAddressQnnnH  [NUM_TILE:0];
logic  [31:0] RingRspDataQnnnH     [NUM_TILE:0];
//assign the last ring output to first ring input
assign RingReqValidQnnnH    [0] = RingReqValidQnnnH    [NUM_TILE];
assign RingReqRequestorQnnnH[0] = RingReqRequestorQnnnH[NUM_TILE];
assign RingReqOpcodeQnnnH   [0] = RingReqOpcodeQnnnH   [NUM_TILE];
assign RingReqAddressQnnnH  [0] = RingReqAddressQnnnH  [NUM_TILE];
assign RingReqDataQnnnH     [0] = RingReqDataQnnnH     [NUM_TILE];
assign RingRspValidQnnnH    [0] = RingRspValidQnnnH    [NUM_TILE];
assign RingRspRequestorQnnnH[0] = RingRspRequestorQnnnH[NUM_TILE];
assign RingRspOpcodeQnnnH   [0] = RingRspOpcodeQnnnH   [NUM_TILE];
assign RingRspAddressQnnnH  [0] = RingRspAddressQnnnH  [NUM_TILE];
assign RingRspDataQnnnH     [0] = RingRspDataQnnnH     [NUM_TILE];


genvar TILE;
generate for ( TILE=0 ; TILE<NUM_TILE ; TILE++) begin : generat_block_gpc_tiles
assign CoreID[TILE] = 8'(TILE); //cast to 8 bit the CoreID
gpc_4t_tile i_gpc_4t_tile
(
    //General Interface
    .QClk       (QClk)         , //input  logic        
    .RstQnnnH   (RstQnnnH)     , //input  logic        
    .CoreID     (CoreID[TILE]) , //input  logic  [7:0] 
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqValidQnnnH     [TILE])  ,//input
    .RingReqInRequestorQ500H    (RingReqRequestorQnnnH [TILE])  ,//input
    .RingReqInOpcodeQ500H       (RingReqOpcodeQnnnH    [TILE])  ,//input
    .RingReqInAddressQ500H      (RingReqAddressQnnnH   [TILE])  ,//input
    .RingReqInDataQ500H         (RingReqDataQnnnH      [TILE])  ,//input
    //Ring ---> RC , RingRspIn
    .RingRspInValidQ500H        (RingRspValidQnnnH     [TILE])  ,//input
    .RingRspInRequestorQ500H    (RingRspRequestorQnnnH [TILE])  ,//input
    .RingRspInOpcodeQ500H       (RingRspOpcodeQnnnH    [TILE])  ,//input
    .RingRspInAddressQ500H      (RingRspAddressQnnnH   [TILE])  ,//input
    .RingRspInDataQ500H         (RingRspDataQnnnH      [TILE])  ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqValidQnnnH    [TILE+1]),//output
    .RingReqOutRequestorQ502H   (RingReqRequestorQnnnH[TILE+1]),//output
    .RingReqOutOpcodeQ502H      (RingReqOpcodeQnnnH   [TILE+1]),//output
    .RingReqOutAddressQ502H     (RingReqAddressQnnnH  [TILE+1]),//output
    .RingReqOutDataQ502H        (RingReqDataQnnnH     [TILE+1]),//output
     //RC   ---> Ring , RingRspOut
    .RingRspOutValidQ502H       (RingRspValidQnnnH    [TILE+1]),//output
    .RingRspOutRequestorQ502H   (RingRspRequestorQnnnH[TILE+1]),//output
    .RingRspOutOpcodeQ502H      (RingRspOpcodeQnnnH   [TILE+1]),//output
    .RingRspOutAddressQ502H     (RingRspAddressQnnnH  [TILE+1]),//output
    .RingRspOutDataQ502H        (RingRspDataQnnnH     [TILE+1]) //output
);
end endgenerate // generate for


endmodule // module lotr
