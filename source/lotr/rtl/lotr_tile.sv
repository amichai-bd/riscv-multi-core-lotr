//-----------------------------------------------------------------------------
// Title            : Lotar Tile
// Project          : LOTR: Lord-Of-The-Ring
//-----------------------------------------------------------------------------
// File             : lotr_tile.sv 
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
module lotr_tile 
    import lotr_pkg::*;  
    (
    //General Interface
    input   logic        QClk                   ,
    input   logic        RstQnnnH               ,
    input   logic [7:0]  tile_id                ,
    //Tile Input 
    input   logic [31:0] RingInputAddressQ500H  ,
    input   logic [31:0] RingInputDataQ500H     ,
    //Tile Output 
    output  logic [31:0] RingOutputAddressQ502H ,
    output  logic [31:0] RingOutputDataQ502H 
    );

//=========================================
//=====    Data Path Signals    ===========
//=========================================
// Core <-> RC interface
// C2F Req/Rsp
logic            [31:0] C2F_ReqAddressQ500H;
logic            [31:0] C2F_ReqDataQ500H;
logic            [31:0] C2F_RspAddressQ502H;
logic            [31:0] C2F_RspDataQ502H;

// F2C Req/Rsp
logic            [31:0] F2C_RspAddressQ500H;
logic            [31:0] F2C_RspDataQ500H;
logic            [31:0] F2C_ReqAddressQ502H;
logic            [31:0] F2C_ReqDataQ502H;


endmodule // module lotr_tile
