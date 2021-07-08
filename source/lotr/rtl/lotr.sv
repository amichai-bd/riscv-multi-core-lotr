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
logic         RingValidQnnnH   [NUM_TILE:0];
t_opcode      RingOpcodeQnnnH  [NUM_TILE:0];
logic  [31:0] RingAddressQnnnH [NUM_TILE:0];
logic  [31:0] RingDataQnnnH    [NUM_TILE:0];
logic  [7:0]  CoreID           [NUM_TILE:0];

assign RingValidQnnnH  [0] = RingValidQnnnH  [NUM_TILE];    //assign the last ring output to first ring input
assign RingOpcodeQnnnH [0] = RingOpcodeQnnnH [NUM_TILE];
assign RingAddressQnnnH[0] = RingAddressQnnnH[NUM_TILE];
assign RingDataQnnnH   [0] = RingDataQnnnH   [NUM_TILE];

genvar tile;
generate for ( tile=0 ; tile<NUM_TILE ; tile++) begin : generat_block_gpc_tiles
assign CoreID[tile] = 8'(tile); //cast to 8 bit the CoreID
gpc_4t_tile i_gpc_4t_tile
(
    //General Interface
    .QClk                   (QClk)                    , //input  logic        
    .RstQnnnH               (RstQnnnH)                , //input  logic        
    .CoreID                 (CoreID[tile])            , //input  logic  [7:0] 
    //Ring ---> RC
    .RingInputValidQ500H    (RingValidQnnnH  [tile])  , //input  logic        
    .RingInputOpcodeQ500H   (RingOpcodeQnnnH [tile])  , //input  logic  [1:0] 
    .RingInputAddressQ500H  (RingAddressQnnnH[tile])  , //input  logic  [31:0]
    .RingInputDataQ500H     (RingDataQnnnH   [tile])  , //input  logic  [31:0]
    //RC   ---> Ring
    .RingOutputValidQ502H   (RingValidQnnnH  [tile+1]), //output logic        
    .RingOutputOpcodeQ502H  (RingOpcodeQnnnH [tile+1]), //output logic  [1:0] 
    .RingOutputAddressQ502H (RingAddressQnnnH[tile+1]), //output logic  [31:0]
    .RingOutputDataQ502H    (RingDataQnnnH   [tile+1])  //output logic  [31:0]
);
end endgenerate // generate for


endmodule // module lotr
