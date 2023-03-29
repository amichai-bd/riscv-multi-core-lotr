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
    input   logic        CLK_50    ,
    // input   logic        RstQnnnH,
    //==============================
    // LOTR <-> FPGA TOP
    //==============================
    // LOTR ---> Top
    input logic Button_0,
    input logic Button_1,
    input logic [9:0] Switch,
    input logic [15:0] Arduino_dg_io,
    input logic uart_master_tx,
    output logic uart_master_rx,
    output logic interrupt,

    // Top ----> LOTR
    output logic [7:0] SEG7_0,
    output logic [7:0] SEG7_1,
    output logic [7:0] SEG7_2,
    output logic [7:0] SEG7_3,
    output logic [7:0] SEG7_4,
    output logic [7:0] SEG7_5,
    output logic [3:0] RED,
    output logic [3:0] GREEN,
    output logic [3:0] BLUE,
    output logic       h_sync,
    output logic       v_sync,
    output logic [9:0] LED 
);


logic RstQnnnH;
logic ALL_PC_RESET;
assign RstQnnnH = (~Button_0);

//=========================================
//=====    ===========
//=========================================
localparam    NUM_TILE = 4;
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
// garbage collector
logic RingReqGarbage;
logic RingRspGarbage;
assign RingReqGarbage = (RingReqAddressQnnnH[NUM_TILE+1][31:24] != 8'h1) &&
                        (RingReqAddressQnnnH[NUM_TILE+1][31:24] != 8'h2) &&
                        (RingReqAddressQnnnH[NUM_TILE+1][31:24] != 8'h3) &&
                        (RingReqAddressQnnnH[NUM_TILE+1][31:24] != 8'h4) &&
                        (RingReqAddressQnnnH[NUM_TILE+1][31:24] != 8'hff) ;
assign RingRspGarbage = (RingRspAddressQnnnH[NUM_TILE+1][31:24] != 8'h1) &&
                        (RingRspAddressQnnnH[NUM_TILE+1][31:24] != 8'h2) &&
                        (RingRspAddressQnnnH[NUM_TILE+1][31:24] != 8'h3) &&
                        (RingRspAddressQnnnH[NUM_TILE+1][31:24] != 8'h4) &&
                        (RingRspAddressQnnnH[NUM_TILE+1][31:24] != 8'hff) ;                        

assign RingReqValidQnnnH    [1] = RingReqGarbage ? 1'b0 : RingReqValidQnnnH[NUM_TILE+1];
assign RingReqRequestorQnnnH[1] = RingReqRequestorQnnnH[NUM_TILE+1];
assign RingReqOpcodeQnnnH   [1] = RingReqOpcodeQnnnH   [NUM_TILE+1];
assign RingReqAddressQnnnH  [1] = RingReqAddressQnnnH  [NUM_TILE+1];
assign RingReqDataQnnnH     [1] = RingReqDataQnnnH     [NUM_TILE+1];

assign RingRspValidQnnnH    [1] = RingRspGarbage ? 1'b0 : RingRspValidQnnnH[NUM_TILE+1];
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
    .ALL_PC_RESET(ALL_PC_RESET),
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
    .ALL_PC_RESET(ALL_PC_RESET),
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
//=======================
//		TEMP
//=======================
// bypass gpc_4t_tile_2
//=======================

//assign RingReqValidQnnnH     [3] = RingReqValidQnnnH     [2];
//assign RingReqRequestorQnnnH [3] = RingReqRequestorQnnnH [2];
//assign RingReqOpcodeQnnnH    [3] = RingReqOpcodeQnnnH    [2];
//assign RingReqAddressQnnnH   [3] = RingReqAddressQnnnH   [2];
//assign RingReqDataQnnnH      [3] = RingReqDataQnnnH      [2];
//assign RingRspValidQnnnH     [3] = RingRspValidQnnnH     [2];
//assign RingRspRequestorQnnnH [3] = RingRspRequestorQnnnH [2];
//assign RingRspOpcodeQnnnH    [3] = RingRspOpcodeQnnnH    [2];
//assign RingRspAddressQnnnH   [3] = RingRspAddressQnnnH   [2];
//assign RingRspDataQnnnH      [3] = RingRspDataQnnnH      [2];

//=======================


fpga_tile fpga_tile
(
    //General Interface
    .QClk       (QClk)         , //input  logic        
    .CLK_50     (CLK_50)         , //input  logic        
    .RstQnnnH   (RstQnnnH)     , //input  logic        
    .CoreID     (8'd3) , //input  logic  [7:0] 
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqValidQnnnH     [3])  ,//input
    .RingReqInRequestorQ500H    (RingReqRequestorQnnnH [3])  ,//input
    .RingReqInOpcodeQ500H       (RingReqOpcodeQnnnH    [3])  ,//input
    .RingReqInAddressQ500H      (RingReqAddressQnnnH   [3])  ,//input
    .RingReqInDataQ500H         (RingReqDataQnnnH      [3])  ,//input
    //Ring ---> RC , RingRspIn                          
    .RingRspInValidQ500H        (RingRspValidQnnnH     [3])  ,//input
    .RingRspInRequestorQ500H    (RingRspRequestorQnnnH [3])  ,//input
    .RingRspInOpcodeQ500H       (RingRspOpcodeQnnnH    [3])  ,//input
    .RingRspInAddressQ500H      (RingRspAddressQnnnH   [3])  ,//input
    .RingRspInDataQ500H         (RingRspDataQnnnH      [3])  ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqValidQnnnH    [4]),//output
    .RingReqOutRequestorQ502H   (RingReqRequestorQnnnH[4]),//output
    .RingReqOutOpcodeQ502H      (RingReqOpcodeQnnnH   [4]),//output
    .RingReqOutAddressQ502H     (RingReqAddressQnnnH  [4]),//output
    .RingReqOutDataQ502H        (RingReqDataQnnnH     [4]),//output
     //RC   ---> Ring , RingRspOut                     
    .RingRspOutValidQ502H       (RingRspValidQnnnH    [4]),//output
    .RingRspOutRequestorQ502H   (RingRspRequestorQnnnH[4]),//output
    .RingRspOutOpcodeQ502H      (RingRspOpcodeQnnnH   [4]),//output
    .RingRspOutAddressQ502H     (RingRspAddressQnnnH  [4]),//output
    .RingRspOutDataQ502H        (RingRspDataQnnnH     [4]), //output
        //==============================
    // Tile <-> FPGA TOP
    //==============================
    // FPGA interface inputs
    .Button_0    (Button_0),
    .Button_1    (Button_1),
    .Switch      (Switch),
    .Arduino_dg_io (~Arduino_dg_io), // active high

    //outputs
    .SEG7_0  (SEG7_0),//(SEG7_0),
    .SEG7_1  (SEG7_1),//(SEG7_1),
    .SEG7_2  (SEG7_2),//(SEG7_2),
    .SEG7_3  (SEG7_3),//(SEG7_3),
    .SEG7_4  (SEG7_4),//(SEG7_4),
    .SEG7_5  (SEG7_5),//(SEG7_5),
    .RED     (RED),//(RED),//output logic [3:0] 
    .GREEN   (GREEN),//(GREEN),//output logic [3:0] 
    .BLUE    (BLUE),//(BLUE),//output logic [3:0] 
    .v_sync  (v_sync),//(v_sync),//output logic       
    .h_sync  (h_sync),//(h_sync),//output logic      
    .LED     (LED),//(LED)
    .ALL_PC_RESET(ALL_PC_RESET)

);

// UART TILE
uart_tile uart_tile
	(
    //General Interface
    //.QClk                     (CLK_50),
    .QClk                     (QClk),
    .RstQnnnH                 (RstQnnnH),
    .CoreID                   (8'd4),
    //================================================
    //        RING Interface
    //================================================
    //Ring ---> RC , RingReqIn
    .RingReqInValidQ500H        (RingReqValidQnnnH     [4])  ,//input
    .RingReqInRequestorQ500H    (RingReqRequestorQnnnH [4])  ,//input
    .RingReqInOpcodeQ500H       (RingReqOpcodeQnnnH    [4])  ,//input
    .RingReqInAddressQ500H      (RingReqAddressQnnnH   [4])  ,//input
    .RingReqInDataQ500H         (RingReqDataQnnnH      [4])  ,//input
    //Ring ---> RC , RingRspIn                          
    .RingRspInValidQ500H        (RingRspValidQnnnH     [4])  ,//input
    .RingRspInRequestorQ500H    (RingRspRequestorQnnnH [4])  ,//input
    .RingRspInOpcodeQ500H       (RingRspOpcodeQnnnH    [4])  ,//input
    .RingRspInAddressQ500H      (RingRspAddressQnnnH   [4])  ,//input
    .RingRspInDataQ500H         (RingRspDataQnnnH      [4])  ,//input
    //RC   ---> Ring , RingReqOut
    .RingReqOutValidQ502H       (RingReqValidQnnnH    [5]),//output
    .RingReqOutRequestorQ502H   (RingReqRequestorQnnnH[5]),//output
    .RingReqOutOpcodeQ502H      (RingReqOpcodeQnnnH   [5]),//output
    .RingReqOutAddressQ502H     (RingReqAddressQnnnH  [5]),//output
    .RingReqOutDataQ502H        (RingReqDataQnnnH     [5]),//output
     //RC   ---> Ring , RingRspOut                     
    .RingRspOutValidQ502H       (RingRspValidQnnnH    [5]),//output
    .RingRspOutRequestorQ502H   (RingRspRequestorQnnnH[5]),//output
    .RingRspOutOpcodeQ502H      (RingRspOpcodeQnnnH   [5]),//output
    .RingRspOutAddressQ502H     (RingRspAddressQnnnH  [5]),//output
    .RingRspOutDataQ502H        (RingRspDataQnnnH     [5]), //output
    // UART RX/TX.
    .uart_master_tx           (uart_master_tx), 
    .uart_master_rx           (uart_master_rx),
    .interrupt                (interrupt)
    );

endmodule // module lotr
